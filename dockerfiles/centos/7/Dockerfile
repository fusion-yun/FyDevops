ARG BASE_OS_VERSION=${BASE_OS_VERSION:-7.6.1810}
FROM centos:${BASE_OS_VERSION}

LABEL Author="Salmon <yuzhi@ipp.ac.cn>"

USER root

#######################################################
# Install basic tools
RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y  epel-release \
    && yum update -y  \
    && yum groupinstall -y "Development Tools" \
    && yum install -y sudo wget unzip \
    perl tcl tcl-devel python3 python3-pip \
    openssl11 openssl11-devel libibverbs-devel   
     

# Clean up
RUN yum clean all -y -q   

# Update pip
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir --upgrade pip 

#######################################################
# Build:
# docker build  --build-arg BASE_OS_VERSION=7.6.1810  -t centos:7.6-fuyun-bare  .