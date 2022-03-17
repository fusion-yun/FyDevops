ARG OS_RELEASE=${OS_RELEASE:-focal}
FROM ubuntu:${OS_RELEASE} 

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"

ARG FY_USER="fuyun"

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update --yes  \
    && apt-get install --yes --no-install-recommends \
    build-essential libssl-dev libibverbs-dev tcl-dev python3 python3-pip python-is-python3 \
    unzip curl git file openssh-client rsync\
    wget ca-certificates  sudo  locales vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*  \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
    && locale-gen


#######################################################

ARG FY_REPO_GID=${FY_REPO_GID:-504}
ARG FY_REPO_GROUP=${FY_REPO_GROUP:-develop}
RUN groupadd --gid ${FY_REPO_GID} ${FY_REPO_GROUP}

#######################################################

ENV HOME="/home/${FY_USER}"

ARG FY_UID=${FY_UID:-"1000"}
ARG FY_GID=${FY_GID:-"1000"}


RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers  \
    && sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers  \
    && echo "${FY_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers  \
    && groupadd -g "${FY_GID}" "${FY_USER}"  \
    && useradd -l -m -s /bin/bash -N -u "${FY_UID}" -g "${FY_GID}" --groups "${FY_REPO_GROUP}" -d /home/${FY_USER}  "${FY_USER}"    

USER ${FY_USER}
