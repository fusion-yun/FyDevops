ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}
FROM ${FY_OS}:${FY_OS_VERSION} AS FY_BASEOS

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}


RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  ;\
    # mirror.aliyun.com
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.aliyun.com/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-Base.repo \
    /etc/yum.repos.d/CentOS-Extras.repo \
    /etc/yum.repos.d/CentOS-AppStream.repo ;\
    #################################################
    yum -y --enablerepo=extras install epel-release ;\
    sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel.repo ; \
    yum update -y ; \
    yum install -y \
    sudo \
    openssl \
    xmlto \    
    tcl \ 
    python2 \
    python3 \
    which ;\
    yum clean all -y -q

# xmlto for git

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}

RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
    usermod -a -G wheel  ${FYDEV_USER} ; \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}