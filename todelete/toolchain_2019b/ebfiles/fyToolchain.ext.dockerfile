# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=2019b

FROM fytoolchain:${BASE_VERSION}

ARG TOOLCHAIN_NAME=gompi
ARG TOOLCHAIN_VERSION=${BASE_VERSION}
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

LABEL Description   "Toolchain ${TOOLCHAIN}"
LABEL Name          "fybox ext. ${BASE_VERSION}"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "toolchain and packages "

################################################################################
# INSTALL packages

ENV PKG_DIR=${PKG_DIR:-/packages}

ARG EB_ARGS=" --use-existing-modules --info -l -r"



ARG GCC_VERSION=${GCC_VERSION:-8.3.0}

RUN  --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
     --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION} ${_EB_ARGS} 


    
RUN  --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
     --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb ebfiles/Ninja-1.9.0-GCCcore-8.3.0-withfortran.eb ${EB_ARGS} 
 