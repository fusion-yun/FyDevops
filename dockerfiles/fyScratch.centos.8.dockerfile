ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

FROM fybase:${FY_OS}_${FY_OS_VERSION}

USER root
RUN yum install -y \    
    # sudo \
    # openssl \
    # xmlto \    
    # tcl \ 
    # python3 \
    # which \
    libXt \
    libXext \
    perl \
    pcre \
    tcl-devel \          
    openssl-devel   \    
    readline-devel ;\
    yum groupinstall -y "Development Tools" ; \    
    yum clean all -y -q 




# ARG FYDEV_USER=${FYDEV_USER:-fydev}
# ENV FYDEV_USER=${FYDEV_USER}

# ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
# ENV FYDEV_USER_ID=${FYDEV_USER_ID}

# RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
#     usermod -a -G wheel  ${FYDEV_USER} ; \
#     echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

USER ${FYDEV_USER}
# WORKDIR /home/${FYDEV_USER}