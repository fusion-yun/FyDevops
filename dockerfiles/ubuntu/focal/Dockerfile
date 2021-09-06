ARG OS_RELEASE=${OS_RELEASE:-focal}
FROM ubuntu:${OS_RELEASE} 

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"


ARG FY_USER="fuyun"
ARG FY_UID="1000"
ARG FY_GID="100"

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    build-essential libssl-dev libibverbs-dev tcl-dev python3 git \
    wget   ca-certificates    sudo  locales  fonts-liberation \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV HOME="/home/${FY_USER}"

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    echo "%${FYDEV_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers && \
    useradd -l -m -s /bin/bash -N -u "${FY_UID}"  -d /home/${FY_USER}  "${FY_USER}"    

USER ${FY_USER}
