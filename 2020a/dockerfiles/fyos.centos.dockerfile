ARG OS_VERSION="8"
FROM centos:${OS_VERSION}

ARG OS_VERSION=${OS_VERSION:-8}


LABEL Name         fyOS_centos_${OS_VERSION}
LABEL Author       "salmon <yuzhi@ipp.ac.cn>"
LABEL Description  "Bare CentOS + denpendences for EasyBuild and lmod"

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
    && echo  http://mirrors.aliyun.com/repo/Centos-${OS_VERSION}.repo \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-${OS_VERSION}.repo \
    && sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo \
    && echo "exclude=*.i386 *.i686" >> /etc/yum.conf   

############################
# base development tools
RUN yum -y --enablerepo=extras install epel-release \
    &&  yum update -y \
    &&  yum groupinstall -y "Development Tools"  \
    # Requirement for lmod and easybuild
    # TODO (salmon 20191015): include packages for IB,GPU...
    &&  yum install -y \
        sudo \
        which \       
        openssl \
        openssl-devel \
        libXt \
        libXext \
        perl \
        pcre \
        tcl \
        tcl-devel\
    &&  yum clean all -y -q

# SHELL [ "/bin/bash","-c" ]