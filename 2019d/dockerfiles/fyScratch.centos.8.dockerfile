ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

FROM fybase:${FY_OS}_${FY_OS_VERSION}

RUN sudo yum groupinstall -y "Development Tools" ; \    
    sudo yum install -y \    
    libXt \
    libXext \
    perl \
    pcre \
    tcl-devel \          
    openssl-devel   \    
    readline-devel ;\
    yum clean all -y -q


