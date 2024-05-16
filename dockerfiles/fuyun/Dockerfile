ARG BASE_OS=${BASE_OS:-centos:7.6-fuyun-bare}

FROM ${BASE_OS}

LABEL Author="Salmon <yuzhi@ipp.ac.cn>"

#######################################################
# Setup  FuYun

ARG FY_ROOT=${FY_ROOT:-/opt/fuyun}

#######################################################
# Bootstrap

ARG INSTALL_PREFIX=${INSTALL_PREFIX:-/usr/local}

COPY bootstrap /tmp/bootstrap

RUN cd /tmp/bootstrap/ \
    && ./bootstrap.sh ${INSTALL_PREFIX} \
    && sudo rm -rf /tmp/bootstrap 

#######################################################
# Setup user account
ARG FY_USER=${FY_USER:-fuyun}
ARG FY_GROUP=${FY_GROUP:-fuyun}
ARG FY_UID=${FY_UID:-1000}
ARG FY_GID=${FY_UID:-1000}
ARG FY_HOME_PREFIX=${FY_HOME_PREFIX:-/home}
ARG FY_HOME=${FY_HOME:-${FY_HOME_PREFIX}/${FY_USER}}
    

RUN groupadd -g ${FY_GID} "${FY_GROUP}"  \
    && useradd -l -m -s /bin/bash -N -u "${FY_UID}" -g "${FY_GID}" --groups "${FY_GROUP}" -d "${FY_HOME}"  "${FY_USER}"   \
    && echo "${FY_USER} ALL=(ALL)   NOPASSWD: ALL" >>/etc/sudoers \
    && echo ". ${INSTALL_PREFIX}/etc/fy_profile " >> ${FY_HOME}/.bashrc   

#######################################################
# Setup directory

RUN mkdir -p ${FY_ROOT} -m 755 \
    && chown -R ${FY_USER}:${FY_GROUP} ${FY_ROOT}   

VOLUME ${FY_ROOT}


ENV FY_ROOT=${FY_ROOT} \
    FY_USER=${FY_USER}

USER ${FY_USER}    
WORKDIR ${FY_HOME}

 

#######################################################
#Usage:
# Build:
#    docker build  --build-arg BASE_OS=ubuntu:focal-fuyun-bare --build-arg FY_UID=1100 --build-arg FY_GID=504  -t fuyun:ubuntu-focal .
# Run:
#   docker run  --mount type=bind,source=/gpfs/fydev/repository/ubuntu/focal/opt/fuyun,target=/opt/fuyun \
#    --mount type=bind,source=/gpfs/fydev/sources,target=/opt/fuyun/sources \
#    --rm -it fuyun:ubuntu-focal fy_run eb --show-config