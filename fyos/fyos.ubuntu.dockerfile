
ARG OS_VERSION=18.04

FROM ubuntu:${OS_VERSION}

ENV container=docker


ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
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


############################
# base development tools
RUN apt-get  update -y

# Requirement for lmod and easybuild
# TODO (salmon 20191015): include packages for IB,GPU...
RUN apt-get install -y \
    build-essential \
    sudo \
    which \
    libibverbs-dev \
    libibverbs-devel \
    python3 \
    python3-devel \
    lua \
    lua-posix \
    lua-filesystem \
    lua-devel \
    tcl \
    tcl-devel \
    python-pip \
    python-wheel \
    openssl \
    openssl-devel \
    perl \
    pcre \
    tcl \
    libXt \
    libXext 

    
