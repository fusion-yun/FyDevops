ARG OS_TAG=centos_8
FROM fybase:${OS_TAG}  

ARG OS_TAG=${OS_TAG:-centos8}
ARG FUYUN_DIR=${FUYUN_DIR:-/packages}
# ENV FUYUN_DIR ${FUYUN_DIR}
RUN echo ${FUYUN_DIR}

# ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}

# #-------------------------------------------------------------------------------
# # GCCcore 
# ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 
# ENV GCCCORE_VERSION=${GCCCORE_VERSION} 

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     eb --software=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS}

# #-------------------------------------------------------------------------------
# # gompi :  compiler + MPI 

# ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
# ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

# ENV TOOLCHAIN_NAME=${TOOLCHAIN_NAME}
# ENV TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION}


# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     eb --software=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}   ${EB_ARGS} 

# #-------------------------------------------------------------------------------
# # Python : 

# ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
# ENV PYTHON_VERSION=${PYTHON_VERSION}

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     eb --software=Python,${PYTHON_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}   

# # RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
# #     --mount=type=bind,target=ebfiles,source=ebfiles \
# #     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
# #     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
# #     eb --software-name=SWIG    --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS}


# # # -------------------------------------------------------------------------------
# # # Perl : 
# # ARG PERL_VERSION=${PERL_VERSION:-5.30.0}
# # ENV PERL_VERSION=${PERL_VERSION}

# # RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
# #     source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
# #     eb --software=Perl,${PERL_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}  

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

# # -------------------------------------------------------------------------------

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     sudo rm  ${FUYUN_DIR} &&\
#     sudo mkdir  ${FUYUN_DIR} &&\
#     sudo chown -R ${FYDEV_USER}:${FYDEV_USER} ${FUYUN_DIR} &&\
#     cp -rf /eb_repos/${BASE_OS}/software           ${FUYUN_DIR}/ &&\
#     cp -rf /eb_repos/${BASE_OS}/modules            ${FUYUN_DIR}/ &&\ 
#     cp -rf /eb_repos/${BASE_OS}/ebfiles_repo       ${FUYUN_DIR}/ 

# # &&\
# # sudo ln -sf ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions   && \
# # sudo ln -sf ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile.fish   /etc/fish/conf.d/z00_lmod.fish && \
