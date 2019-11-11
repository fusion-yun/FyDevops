# syntax=docker/dockerfile:experimental
ARG BASE_VERSION=201910
ARG BASE_OS=centos7

FROM fyos:${BASE_OS} AS fy_base

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.2.3}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG PKG_DIR=${PKG_DIR:-/packages}

LABEL Description   "fyBox: lmod ${FY_LMOD_VERSION} + EasyBuild ${FY_EB_VERSION}, PKG_DIR=${PKG_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "
LABEL Name          "fyBox"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "Create module envirnments "


################################################################################
# Add user for DevOps
# Add user for DevOps
# RUN groupadd -f ${FYDEV_GROUP} -g ${FYDEV_GROUP_ID}
RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER}  && \
    usermod -a -G wheel  ${FYDEV_USER} && \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers



RUN sudo mkdir -p ${PKG_DIR} &&\
    sudo mkdir -p ${PKG_DIR}/build &&\
    sudo chown -R ${FYDEV_USER}:${FYDEV_USER} ${PKG_DIR} 


################################################################################
# Install lmod+easybuild
# Install lmod
# curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o lmod-${FY_LMOD_VERSION}.tar.gz
RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    mkdir -p  ${PKG_DIR}/sources/bootstrap && \
    if ! [ -f ${PKG_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  \
    curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${PKG_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  ; \
    fi && \    
    mkdir -p ${PKG_DIR}/build/lmod-${FY_LMOD_VERSION}  && \
    tar xzf ${PKG_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${PKG_DIR}/build/lmod-${FY_LMOD_VERSION} --strip-components=1 && \
    cd ${PKG_DIR}/build/lmod-${FY_LMOD_VERSION} &&\
    ./configure  && make install && \      
    sudo ln -s /usr/local/lmod/lmod/init/profile     /etc/profile.d/lmod.sh && \
    sudo ln -s /usr/local/lmod/lmod/init/bash        /etc/profile.d/lmod.bash && \
    sudo ln -s /usr/local/lmod/lmod/init/zsh         /etc/profile.d/lmod.zsh && \
    sudo ln -s /usr/local/lmod/lmod/init/csh         /etc/profile.d/lmod.csh && \
    sudo ln -s /usr/local/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  && \
    rm -rf ${PKG_DIR}/build/lmod-${FY_LMOD_VERSION}


USER ${FYDEV_USER}

## EasyBuild
RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    cd ${PKG_DIR}/sources/bootstrap && \
    if ! [ -f bootstrap_eb.py ]; then  \
    curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py ;\
    curl -LO https://files.pythonhosted.org/packages/48/aa/f05d350c358338d0e843835660e3993cc5eb28401f32c0c5b8bc9a9458d5/vsc-base-2.8.4.tar.gz  ; \
    curl -LO https://files.pythonhosted.org/packages/18/59/3274a58af6af84a87f7655735b452c06c769586ee73954f5ee15d303aa29/vsc-install-0.11.3.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz ; \
    fi && \    
    source /etc/profile.d/lmod.bash  &&\   
    EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES \
    EASYBUILD_BOOTSTRAP_SOURCEPATH=${PKG_DIR}/sources/bootstrap \
    EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION} \
    python bootstrap_eb.py ${PKG_DIR}   

ENV FYDEV_USER=${FYDEV_USER}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}
ENV PKG_DIR=${PKG_DIR}
ENV EASYBUILD_PREFIX=${PKG_DIR}
ENV MODULEPATH="${PKG_DIR}/modules/all${MODULEPATH}"
ENV FY_EB_VERSION=${FY_EB_VERSION}
WORKDIR /home/${FYDEV_USER}



FROM fy_base AS fy_gcccore

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}

#-------------------------------------------------------------------------------
# GCCcore 
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 
ENV GCCCORE_VERSION=${GCCCORE_VERSION} 

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS}

#-------------------------------------------------------------------------------
# gompi :  compiler + MPI 
FROM fy_gcccore AS fy_toolchain

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

ENV TOOLCHAIN_NAME=${TOOLCHAIN_NAME}
ENV TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION}


RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}   ${EB_ARGS} 

#-------------------------------------------------------------------------------
# Python : 

FROM fy_gcccore AS fy_python

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0}
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
ENV PYTHON_VERSION=${PYTHON_VERSION}

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=Python,${PYTHON_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}   

# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles_java \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=SWIG    --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS}

# -------------------------------------------------------------------------------
# Perl : 
FROM fy_gcccore AS fy_perl

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0}
ARG PERL_VERSION=${PERL_VERSION:-5.30.0}
ENV PERL_VERSION=${PERL_VERSION}

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=Perl,${PERL_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}  

#-------------------------------------------------------------------------------
# Java 
FROM fy_base AS fy_java

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}
ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
ENV JAVA_VERSION=${JAVA_VERSION}

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles_java \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} 


FROM fy_gcccore AS fy_buildtools

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0}
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} && \
    eb --software-name=pkg-config   --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\
    eb --software-name=CMake        --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\        
    eb --software-name=libxslt      --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\
    eb --software-name=libxml2      --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\
    eb --software-name=Doxygen      --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS}  


RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles_buildtools \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} && \    
    eb ebfiles/Ninja-1.9.0-GCCcore-8.3.0-withfortran.eb --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs ${EB_ARGS}



#-------------------------------------------------------------------------------
# libs:data
FROM fy_gcccore  AS fy_libs_data

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0}
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_NAME_VERSION=${TOOLCHAIN_NAME_VERSION:-2019b}

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles_libs_data \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=HDF5             --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  

COPY --from=fy_python /packages/ebfiles_repo  ${PKG_DIR}/ebfiles_repo
COPY --from=fy_python /packages/software  ${PKG_DIR}/software
COPY --from=fy_python /packages/modules  ${PKG_DIR}/modules

COPY --from=fy_java /packages/ebfiles_repo  ${PKG_DIR}/ebfiles_repo
COPY --from=fy_java /packages/software ${PKG_DIR}/software
COPY --from=fy_java /packages/modules ${PKG_DIR}/modules

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles_libs_data \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=MDSplus          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles_libs_data \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=PostgreSQL       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}   &&\
    eb --software-name=libMemcached     --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  




# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles_libs_data \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=HDF5           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
#     eb --software-name=netCDF           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
#     eb --software-name=netCDF-Fortran   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\
#     eb --software-name=netCDF-C++4      --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  

# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles_libs_data/${FY_EB_VERSION} \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles  ${EB_ARGS}"  &&\
#     eb --software-name=netcdf4-python   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}  


#-------------------------------------------------------------------------------
# libs:build tools
# FROM fy_toolchain as fy_libs
# ARG PKG_DIR=${PKG_DIR:-/packages}
# ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
# ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}
# ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0}
# ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
# ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
# ARG TOOLCHAIN_NAME_VERSION=${TOOLCHAIN_NAME_VERSION:-2019b}

# RUN sudo yum install -y libXt libXext

# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles_libs \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=Boost            --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=Blitz++          --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}   


