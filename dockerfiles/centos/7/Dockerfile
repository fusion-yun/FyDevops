FROM centos:7

ARG FY_USER="fuyun"
ARG FY_UID="1000"
ARG FY_GID="100"

RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y dnf-plugins-core  \    
    && sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-Base.repo \
    && yum update -y  \
    && yum install -y sudo wget  git gcc  python3 python3-pip perl tcl-devel  openssl-devel vim  \
    && yum clean all -y -q


# RUN useradd -u ${FY_UID}  -d /home/${FY_USER}  ${FY_USER}  \
#     && echo "%${FY_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers

# USER ${FY_USER}

