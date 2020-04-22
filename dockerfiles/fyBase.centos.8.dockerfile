ARG FY_OS=centos
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}
FROM ${FY_OS}:${FY_OS_VERSION} 

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}


RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  ;\
    yum install -y dnf-plugins-core ; \
    yum config-manager --set-enabled PowerTools ;\
    # mirror.aliyun.com
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.aliyun.com/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-AppStream.repo \
    /etc/yum.repos.d/CentOS-Base.repo \
    /etc/yum.repos.d/CentOS-Extras.repo \
    /etc/yum.repos.d/CentOS-PowerTools.repo \
    ; \
    #################################################
    yum -y --enablerepo=extras install epel-release ;\
    sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel.repo ; \
    yum update -y ; \
    yum install -y \      
    sudo which  Lmod \         
    # Development tools
    python3 perl  \
    autoconf automake binutils \
    bison flex gcc gcc-c++ gettext \
    elfutils libtool make patch pkgconfig \
    # ctags  indent patchutils \
    # Dependences
    openssl openssl-devel xmlto \  
    ;\
    yum clean all -y -q

RUN  alternatives --set python /usr/bin/python3 

# xmlto for git

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}

ENV PYTHONPATH=/usr/share/lmod/lmod/init/:${PYTHONPATH}

RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
    echo "%${FYDEV_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}