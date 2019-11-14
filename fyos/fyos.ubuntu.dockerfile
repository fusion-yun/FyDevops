
ARG OS_VERSION=18.04

FROM ubuntu:${OS_VERSION}

ENV container=docker

ARG BUILDPLATFORM

LABEL Name         fyOS_ubuntu_${OS_VERSION}
LABEL Author       "salmon <yuzhi@ipp.ac.cn>"
LABEL Description  "Bare CentOS + denpendences for EasyBuild and lmod"

# #Dockerfile for systemd base image

# RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
#     systemd-tmpfiles-setup.service ] || rm -f $i; done); \
#     rm -f /lib/systemd/system/multi-user.target.wants/*;\
#     rm -f /etc/systemd/system/*.wants/*;\
#     rm -f /lib/systemd/system/local-fs.target.wants/*; \
#     rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
#     rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
#     rm -f /lib/systemd/system/basic.target.wants/*;\
#     rm -f /lib/systemd/system/anaconda.target.wants/*;
# VOLUME [ "/sys/fs/cgroup" ]
# CMD ["/usr/sbin/init"]

ARG TZ=${TZ:-Asia/Shanghai}
ENV TV=${TV}

############################
# base development tools
RUN apt-get  update -y
RUN export DEBIAN_FRONTEND=noninteractive &&\
    apt-get install -y  tzdata  && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime &&\
    dpkg-reconfigure --frontend noninteractive tzdata
# Requirement for lmod and easybuild
# TODO (salmon 20191015): include packages for IB,GPU...
RUN export DEBIAN_FRONTEND=noninteractive &&\
    apt-get install -y \
    build-essential \
    sudo \
    curl \
    vim \
    bash-completion \
    libreadline-dev \
    unzip  \
    libibverbs-dev \
    tcl \
    tcl-dev \
    python \
    openssl \
    libssl-dev \
    perl \
    libpcre3 \
    libxt6 \
    libxext6 

RUN export DEBIAN_FRONTEND=noninteractive &&\
    apt-get install -y \
    python-setuptools \
    openssh-client \
    git 
    
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER=${FYDEV_USER}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}
################################################################################
# Add user for DevOps
# Add user for DevOps
# RUN groupadd -f ${FYDEV_GROUP} -g ${FYDEV_GROUP_ID}
RUN useradd -m -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER}  && \
    usermod -aG sudo  ${FYDEV_USER} && \
    echo '%sudo ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

USER   ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}