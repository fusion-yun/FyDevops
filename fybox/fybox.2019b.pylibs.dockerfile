# syntax=docker/dockerfile:experimental
ARG BASE_VERSION=latest

FROM fybox:${BASE_VERSION}  

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.2.3}
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
ARG PKG_DIR=${PKG_DIR:-/packages}

LABEL Description   "fyBox:Python libs, PKG_DIR=${PKG_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "
LABEL Name          "fyBox:Python libs,"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "Create module envirnments "

 
USER   ${FYDEV_USER}

#-------------------------------------------------------------------------------
# libs:python libs

RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=SWIG            --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${_EB_ARGS} 

RUN source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software=foss,${TOOLCHAIN_VERSION}  ${EB_ARGS}

RUN source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    module load Python/${PYTHON_VERSION}-GCCcore-${GCCCORE_VERSION} && \
    pip install pkgconfig cftime  numpy scipy matplotlib ipython jupyter pandas sympy nose jupyter 
 
RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs    ${EB_ARGS}"  &&\
        eb --software-name=mpi4py       --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}  &&\
        eb --software-name=h5py         --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}  

RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs    ${EB_ARGS}"  &&\
    eb --software-name=netcdf4-python   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}  


USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
