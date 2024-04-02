ARG BASE_OS=${BASE_OS:-centos:7.6}
FROM ${BASE_OS}

LABEL Author="Salmon <yuzhi@ipp.ac.cn>"

USER root

#######################################################
# Install basic tools
RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y  epel-release \
    && yum update -y  \
    && yum groupinstall -y "Development Tools" \
    && yum install -y sudo wget openssh openssh-server  \
    perl tcl tcl-devel python3 python3-pip \
    lua-devel lua-posix lua-filesystem \
    openssl11 openssl11-devel libibverbs-devel bzip2-devel libffi-devel \
    vim unzip 

#######################################################
# Update pip
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir --upgrade pip 

#######################################################
# Clean up
RUN yum clean all -y -q   