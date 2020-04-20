ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

FROM ${FY_OS}:${FY_OS_VERSION}


RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  ;\
    # mirror.ustc.edu.cn
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-Base.repo \
    /etc/yum.repos.d/CentOS-Extras.repo \
    /etc/yum.repos.d/CentOS-AppStream.repo ;\
    #################################################
    yum -y --enablerepo=extras install epel-release ;\
    sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel.repo ; \
    yum update -y ; \
    yum install -y \    
    sudo \
    openssl \
    xmlto \    
    tcl \ 
    python3 \
    which \
    libXt \
    libXext \
    perl \
    pcre \
    tcl-devel \          
    openssl-devel   \    
    readline-devel ;\
    sudo yum groupinstall -y "Development Tools" ; \    
    yum clean all -y -q



