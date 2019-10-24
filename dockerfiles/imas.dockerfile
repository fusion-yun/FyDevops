# syntax = docker/dockerfile:1.0-experimental
ARG BASE=fybox:latest

FROM ${BASE} as imas_3_24_0_ual_4_2_0

LABEL Description   "IMAS (${IMAS_VERSION}) + UDA(${UDA_VERSION})"
LABEL Name          "IMAS"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG PYTHON_VERSION=3.6.6
ARG JAVA_VERSION=13.0.1

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=3.24.0_4.2.0


RUN source /etc/profile.d/lmod.bash  && module load Python &&\
    pip install future matplotlib

RUN --mount=type=bind,target=sources,source=imas_sources \
    --mount=type=bind,target=ebfiles,source=imas_ebfiles \
    --mount=type=ssh \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources --use-existing-modules  -l --info --debug -r "  &&\
    eb --software-name=UDA --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}
 
RUN --mount=type=bind,target=sources,source=imas_sources  \
    --mount=type=bind,target=ebfiles,source=imas_ebfiles \
    --mount=type=ssh \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources --use-existing-modules  -l --info --debug -r "  &&\
    eb --software-name=IMAS --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} 


####
# build command:
# docker build --progress=plain --ssh=default --rm -f "dockerfiles/imas.dockerfile" -t imas:3_24_0_ual_4_2_0 .
