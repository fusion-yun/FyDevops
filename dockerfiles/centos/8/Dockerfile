FROM centos:8

RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y dnf-plugins-core  \    
    && sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-Linux-AppStream.repo \
    /etc/yum.repos.d/CentOS-Linux-BaseOS.repo \
    /etc/yum.repos.d/CentOS-Linux-Extras.repo \
    /etc/yum.repos.d/CentOS-Linux-PowerTools.repo \
    /etc/yum.repos.d/CentOS-Linux-Plus.repo   \ 
    && yum update -y  \
    && yum install -y sudo wget  git gcc  python3 python3-pip perl tcl-devel  openssl-devel  \
    && yum clean all -y -q


# Update pip
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir --upgrade pip 
