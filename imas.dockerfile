ARG BASE=fy_pkgenv:centos7

FROM ${BASE}

ARG IMAS_VERSION
ARG IMAS_HOME=${PKG_DIR}/software/imas/${IMAS_VERSION}

LABEL Description   "IMAS"

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b

ENV IMAS_HOME=${PKG_DIR}/software/imas/${IMAS_VERSION}
ENV UDA_VERSION=2.2.3
ENV TAG_DD=3.21.0
ENV TAG_AL=3.8.5

COPY imas_ebfiles ./
COPY imas_source ./

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    module load ${TOOLCHAIN_NAME}/${TOOLCHAIN_VERSION} &&\
    eb ./imas_ebfiles  ${EB_ARGS} &&\