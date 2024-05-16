ARG BASE_OS_VERSION=${BASE_OS_VERSION:-focal}
FROM ubuntu:${BASE_OS_VERSION}

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"

USER root

#######################################################
# Install basic tools
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update --yes  \
    && apt-get install --yes --no-install-recommends \
    build-essential sudo wget unzip curl git file vim\
    libssl-dev libibverbs-dev \
    perl tcl tcl-dev python3 python3-pip python-is-python3 \
    ca-certificates  locales bc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*  \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
    && locale-gen
# bc for lua
# Update pip
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir --upgrade pip 


#######################################################
# Build:
# docker build  --build-arg BASE_OS_VERSION=focal -t ubuntu:2204-fuyun-bare .