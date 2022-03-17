#!/bin/bash
echo "exclude=*.i386 *.i686" >>/etc/yum.conf
yum install -y dnf-plugins-core
yum config-manager --set-enabled PowerTools
# mirror.aliyun.com
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.aliyun.com/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-AppStream.repo \
    /etc/yum.repos.d/CentOS-Base.repo \
    /etc/yum.repos.d/CentOS-Extras.repo \
    /etc/yum.repos.d/CentOS-PowerTools.repo

#################################################
yum -y --enablerepo=extras install epel-release
sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel.repo \
    /etc/yum.repos.d/epel-modular.repo
yum update -y
yum install -y
