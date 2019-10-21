# syntax = docker/dockerfile:1.0-experimental


ARG BASE=fybox:2018b

FROM ${BASE}

LABEL Description   "IMAS"

LABEL Name          "imas_dev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=4.2.0_3.24.0
ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b



# need : export DOCKER_BUILDKIT=1
RUN mkdir -p imas
COPY ebfiles/imas/UDA-2.2.6-foss-2018b.eb ./imas/
COPY sources/imas/uda-2.2.6.tar.gz  ./imas/

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb -f imas/UDA-${UDA_VERSION}-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb ${EB_ARGS} 

RUN sudo yum install -y vim 

USER fydev
COPY ebfiles/imas/* ./imas/
COPY sources/imas/* ./imas/

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb -f imas/IMAS-${IMAS_VERSION}-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb  ${EB_ARGS} 

# RUN rm -rf imas