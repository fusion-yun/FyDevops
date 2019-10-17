
ARG OS_VERSION=7

FROM centos:${OS_VERSION}

ENV container=docker


ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG BUILDPLATFORM

RUN echo "fydev_os is building for $TARGETPLATFORM on $BUILDPLATFORM "
# User for DevOps
ARG FYDEV_USER=fydev 
ARG FYDEV_USER_ID=1000

LABEL Name         fydev_os_${TARGETOS}_${TARGETARCH}_${TARGETVARIANT}
LABEL Author       "salmon <yuzhi@ipp.ac.cn>"
LABEL Description  "Base DevOps environment for 'fuyun'"

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
RUN yum -y --enablerepo=extras install epel-release 
RUN yum update -y
RUN yum groupinstall -y "Development Tools" 

# Requirement for lmod and easybuild
# TODO (salmon 20191015): include packages for IB,GPU...
RUN yum install -y \
    which \
    libibverbs-dev \
    libibverbs-devel \
    python3 \
    lua \
    lua-posix \
    lua-filesystem \
    lua-devel \
    tcl \
    tcl-devel \
    python-pip \
    python-wheel \
    openssl-devel 


RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} 
RUN usermod -a -G wheel ${FYDEV_USER} && echo '%wheel ALL=(ALL)    NOPASSWD: ALL'>>/etc/sudoers

ENV FYDEV_USER=${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
USER ${FYDEV_USER}