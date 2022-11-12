FROM centos:7

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"

USER root

RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y dnf-plugins-core  \    
    && sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-Base.repo \
    && yum update -y  \
    && yum groupinstall -y "Development Tools" \
    && yum install -y sudo wget python3 python3-pip perl tcl-devel openssl openssl-devel libibverbs-devel vim unzip \
    && yum clean all -y -q

#######################################################

ARG FY_LOCAL_GID=${FY_LOCAL_GID:-504}
ARG FY_LOCAL_GROUP=${FY_LOCAL_GROUP:-develop}

ARG FY_USER=${FY_USER:-fuyun}
ARG FY_GROUP=${FY_GROUP:-${FY_USER}}
ARG FY_UID=${FY_UID:-1000}
ARG FY_GID=${FY_GID:-1000}
ARG FY_HOME=${FY_HOME:-/home} 
ARG FY_PREFIX=${FY_ROOT:-/fuyun}

RUN echo "${FY_USER} ALL=(ALL)   NOPASSWD: ALL" >>/etc/sudoers \
    && groupadd -g "${FY_LOCAL_GID}" "${FY_LOCAL_GROUP}"  \
    && groupadd -g "${FY_GID}"       "${FY_GROUP}" \
    && mkdir -p ${FY_HOME} \
    && useradd  -l -m -s /bin/bash -N -u "${FY_UID}" -g "${FY_GID}" --groups "${FY_LOCAL_GROUP}" -d "${FY_HOME}/${FY_USER}" "${FY_USER}"  \
    && mkdir -p ${FY_PREFIX} -m 775 \
    && chown ${FY_USER}:${FY_GROUP} ${FY_PREFIX}

USER ${FY_USER}
ENV FY_ROOT=${FY_PREFIX}
ENV FY_SCRIPTS=${FY_PREFIX}/software/scripts
RUN echo "source  ${FY_PREFIX}/software/scripts/fy_profile.sh" >> ${FY_HOME}/${FY_USER}/.bashrc

