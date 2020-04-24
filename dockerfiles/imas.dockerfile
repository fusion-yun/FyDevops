# syntax=docker/dockerfile:experimental

ARG FYDEV_TAG=latest
FROM fydev:${FYDEV_TAG}  


ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=3.28.0_4.7.2


RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    --mount=type=bind,target=/tmp/sources,source=sources \
    --mount=type=ssh \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_BUILDPATH=/tmp/eb_build ; \
    module load EasyBuild ; \   
    export _EB_ARGS=" "  &&\
    eb --software=IMAS,${IMAS_VERSION} \
        --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
        --amend=versionsuffix=-Python-${PYTHON_VERSION} \
        --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs \
         --sourcepath=$EASYBUILD_PREFIX/sources/:/tmp/sources \
         --use-existing-modules --info   -l  -r   


  
LABEL Description   "IMAS (${IMAS_VERSION}) + UDA(${UDA_VERSION})"
LABEL Name          "IMAS"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"
