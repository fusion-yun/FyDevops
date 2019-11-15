# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=latest
FROM fybox:${BASE_VERSION}  

ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=3.24.0_4.2.0

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.2.3}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}

ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}

# RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
#     source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \    
#     export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=Python       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=libxml2      --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=libMemcached --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=MDSplus      --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=PostgreSQL   --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=SWIG         --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=HDF5         --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=netCDF       --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=Boost        --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} 


ARG FYDEV_USER=${FYDEV_USER:-fydev}
WORKDIR /home/${FYDEV_USER}

SHELL ["/bin/bash","-c"]

RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    --mount=type=bind,target=/tmp/sources,source=sources \
    --mount=type=ssh \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \    
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:/tmp/sources --use-existing-modules  -l --info  -r "  &&\
    eb --software-name=UDA --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}


RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    --mount=type=bind,target=/tmp/sources,source=sources \
    --mount=type=ssh \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \    
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:/tmp/sources --use-existing-modules  -l --info  -r "  &&\
    eb --software-name=IMAS --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} 

  
LABEL Description   "IMAS (${IMAS_VERSION}) + UDA(${UDA_VERSION})"
LABEL Name          "IMAS"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"
