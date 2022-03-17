
FROM centos:7

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"


RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y dnf-plugins-core  \    
    && sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-Base.repo \
    && yum update -y  \
    && yum groupinstall -y "Development Tools" \
    && yum install -y sudo wget    python3 python3-pip perl tcl-devel openssl openssl-devel libibverbs-devel vim unzip \
    && yum clean all -y -q

#######################################################

ARG FY_LOCAL_GID=${FY_LOCAL_GID:-504}
ARG FY_LOCAL_GROUP=${FY_LOCAL_GROUP:-develop}
RUN groupadd --gid ${FY_LOCAL_GID} ${FY_LOCAL_GROUP}

#######################################################
ARG FY_USER=${FY_USER:-physical_suport}
ARG FY_UID=${FY_UID:-11048}
ARG FY_GID=${FY_GID:-11181}
ARG FY_HOME=${FY_HOME:-/public/home/${FY_USER}} 

RUN mkdir -p /public/home

RUN groupadd -g ${FY_GID} ${FY_USER}
RUN useradd  -u ${FY_UID} -g ${FY_GID} --groups ${FY_LOCAL_GROUP} -s /bin/bash  -d  ${FY_HOME} ${FY_USER} \
    && echo "%${FY_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers

USER ${FY_USER}

