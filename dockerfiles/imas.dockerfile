# syntax = docker/dockerfile:1.0-experimental
ARG UDA_VERSION=2.2.6
FROM uda:${UDA_VERSION}

LABEL Description   "IMAS"
LABEL Name          "IMAS"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS "


ARG IMAS_VERSION=4.2.0_3.24.0

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG JAVA_VERSION=13.0.1

RUN --mount=type=bind,target=sources,source=imas_sources  \
    --mount=type=bind,target=ebfiles,source=imas_ebfiles \
    --mount=type=ssh \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources --use-existing-modules  -r"  &&\
    eb --software-name=IMAS --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS} 

# RUN rm -rf imas