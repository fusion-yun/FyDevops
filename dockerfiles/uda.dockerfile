# syntax = docker/dockerfile:1.0-experimental
ARG BASE=fybox:latest
FROM ${BASE}

LABEL Description   "UDA"
LABEL Name          "UDA"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=4.2.0_3.24.0

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b

RUN --mount=type=bind,target=sources,source=imas_sources \
    --mount=type=bind,target=ebfiles,source=imas_ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources --use-existing-modules  -r"  &&\
    eb --software=UDA,${UDA_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}
    



# RUN --mount=type=bind,target=sources,source=imas_sources  --mount=type=bind,target=ebfiles,source=imas_ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     eb --software=IMAS,${IMAS_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${UO_EB_ARGS} 

# RUN rm -rf imas