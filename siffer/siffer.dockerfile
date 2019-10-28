# syntax = docker/dockerfile:1.0-experimental
ARG BASE=fybox_matlab:latest

FROM ${BASE} 

LABEL Description   "IMAS (${IMAS_VERSION}) + UDA(${UDA_VERSION})"
LABEL Name          "IMAS"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"

ARG TOOLCHAIN_NAME=GCCcore
ARG TOOLCHAIN_VERSION=6.3.0
ARG PYTHON_VERSION=3.6.6
ARG JAVA_VERSION=13.0.1

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=3.24.0_4.2.0

ARG MATLAB_VERSION='R2017a'


# RUN --mount=type=bind,target=sources,source=sources \
#     --mount=type=bind,target=ebfiles,source=ebfiles \
#     --mount=type=bind,target=,source=ebfiles \
#     --mount=type=ssh \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources --use-existing-modules  -l --info  -r "  &&\
#     eb --software-name=UDA --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}

RUN mkdir -p /packages/modules/all/MATLAB/
COPY ebfiles/${MATLAB_VERSION}.lua /packages/modules/all/MATLAB/

# RUN --mount=type=bind,target=/packages/software/MATLAB/,source=Polyspace \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     eb --software-name=MATLAB --try-software-version=R2019b --module-only -l 
####
# build command:
# docker build --progress=plain --ssh=default --rm -f "dockerfiles/imas.dockerfile" -t imas:3_24_0_ual_4_2_0 .
