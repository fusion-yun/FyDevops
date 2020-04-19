# syntax=docker/dockerfile:experimental
ARG FY_OS=centos
ARG FY_OS_VERSION=centos
FROM fyeb:${FY_OS}_${FY_OS_VERSION}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
    module load EasyBuild ; \    
    export EB_ARGS=" --use-existing-modules --info -r" ; \
    eb --show-config ; \
    eb ${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb  ${EB_ARGS} 


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
    module load EasyBuild ; \
    export EB_ARGS=" --use-existing-modules --minimal-toolchains --info -r" ; \    
    eb --software-name=HDF5 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${EB_ARGS} 

#####################################################################
# Install Conda for Python
# ARG CONDA_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/anaconda
# ARG CONDA_DIR=${FUYUN_DIR}/software/conda
# ARG PIP_MIRROR=https://mirrors.aliyun.com/pypi/simple/

# RUN  --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \         
#     if ! [ -f ${FUYUN_DIR}/sources/bootstrap/miniconda3.sh ]; then  \    
#     # install conda with China mirror
#     mkdir -p  ${FUYUN_DIR}/sources/bootstrap/ ; \
#     curl -L ${CONDA_MIRROR}/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ${FUYUN_DIR}/sources/bootstrap/miniconda3.sh  ;\
#     fi  ; \    
#     rm -rf ${CONDA_DIR} ;\    
#     /usr/bin/bash ${FUYUN_DIR}/sources/bootstrap/miniconda3.sh  -b -p ${CONDA_DIR} ; \
#     ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/main ; \
#     ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/free ; \
#     ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/r ; \
#     ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/pro ; \
#     ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/cloud/conda-forge ; \
#     ${CONDA_DIR}/bin/conda config --remove channels defaults ; \
#     ${CONDA_DIR}/bin/conda config --set show_channel_urls yes ; \
#     ${CONDA_DIR}/bin/conda update -n base -c defaults conda  ; \
#     ${CONDA_DIR}/bin/conda clean --all ; \
#     ##############################################################################
#     # add pip mirror
#     ${CONDA_DIR}/bin/pip config set global.index-url ${PIP_MIRROR}} 
# # ${CONDA_DIR}/bin/pip install --upgrade pip ;

# ENV PATH=${CONDA_DIR}/bin:${PATH}



# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
#     module load EasyBuild ; \
#     export EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs   --use-existing-modules --info -r" ; \
#     eb --software-name=netCDF --toolchain=gompi,${TOOLCHAIN_VERSION}  ${EB_ARGS} ; \ 
#     eb --software-name=netCDF-Fortran --toolchain=gompi,${TOOLCHAIN_VERSION}  ${EB_ARGS} ;  \
#     eb --software-name=netCDF-C++4 --toolchain=gompi,${TOOLCHAIN_VERSION}  ${EB_ARGS} ; 


# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=SWIG    --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS}


# # -------------------------------------------------------------------------------
# # Perl : 
# ARG PERL_VERSION=${PERL_VERSION:-5.30.0}
# ENV PERL_VERSION=${PERL_VERSION}
# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     eb --software=Perl,${PERL_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}  

# #-------------------------------------------------------------------------------
# # Java 

# ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
# ENV JAVA_VERSION=${JAVA_VERSION}

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
#     eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} 



# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \
#     eb --software-name=pkg-config   --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\
#     eb --software-name=CMake        --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\        
#     eb --software-name=Doxygen      --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS}  

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \    
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb /tmp/ebfiles/Ninja-1.9.0-GCCcore-8.3.0-withfortran.eb ${_EB_ARGS} 



# #-------------------------------------------------------------------------------
# # libs:data
# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=HDF5             --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  &&\
#     eb --software-name=MDSplus          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=HDF5             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  


# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=PostgreSQL       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}   &&\
#     eb --software-name=libMemcached     --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  




# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=netCDF           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
#     eb --software-name=netCDF-Fortran   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\
#     eb --software-name=netCDF-C++4      --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  


# #-------------------------------------------------------------------------------
# # libs:build tools
# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=Boost            --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} && \
#     eb --software-name=Blitz++          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} && \
#     eb --software-name=libxslt          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} && \
#     eb --software-name=libxml2          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


# #-------------------------------------------------------------------------------
# # libs:math libs
# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=OpenBLAS            --toolchain=GCC,${GCCCORE_VERSION}  ${_EB_ARGS} && \
#     eb --software-name=ScaLAPACK           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} && \
#     eb --software-name=FFTW                --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} 

# #-------------------------------------------------------------------------------
# # libs:python libs

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=SWIG            --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${_EB_ARGS} 

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software=foss,${TOOLCHAIN_VERSION}  ${EB_ARGS}

# -------------------------------------------------------------------------------

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     sudo rm  ${FUYUN_DIR} &&\
#     sudo mkdir  ${FUYUN_DIR} &&\
#     sudo chown -R ${FYDEV_USER}:${FYDEV_USER} ${FUYUN_DIR} &&\
#     cp -rf /eb_repos/${BASE_OS}/software           ${FUYUN_DIR}/ &&\
#     cp -rf /eb_repos/${BASE_OS}/modules            ${FUYUN_DIR}/ &&\ 
#     cp -rf /eb_repos/${BASE_OS}/ebfiles_repo       ${FUYUN_DIR}/ 

# # &&\
# 