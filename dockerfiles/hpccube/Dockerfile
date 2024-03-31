FROM image.sourcefind.cn:5000/dcu/admin/base/vscode-pytorch:1.13.1-ubuntu20.04-dtk23.04.1-latest

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"

USER root

ENV DEBIAN_FRONTEND noninteractive

#####################################################
# Install EasyBuild
RUN apt-get update --yes  \
    && apt-get upgrade --yes  \
    && apt-get install --yes --no-install-recommends \
    build-essential bc libssl-dev libibverbs-dev \
    unzip curl git file openssh-client rsync\
    wget ca-certificates  sudo  locales vim \
    lua5.2 lua-posix lua-filesystem tcl-dev  liblua5.2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*  \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
    && locale-gen \
    && pip install --no-cache-dir --upgrade pip \
    && pip install easybuild \
    && rm -rf /root/.cache/pip


######################################################
# Add user fuyun
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers  \
    && sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers  \
    && echo "fuyun ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers  \
    && groupadd -g "1000" "fuyun"  \
    && useradd -l -m -s /bin/bash -N -u "1000" -g "1000" --groups "fuyun" -d "/home/fuyun"  "fuyun"  \
    && mkdir -p /fuyun -m 775 \
    && chown fuyun:fuyun /fuyun


USER fuyun
WORKDIR /home/fuyun
ENV FY_ROOT /fuyun
ENV EASYBUILD_PREFIX /fuyun

#######################################################
# Install LMOD
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.7.37}

RUN mkdir -p /fuyun/sources/l/lmod/ \
    && cd /fuyun/sources/l/lmod/  \
    && wget https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz  

RUN TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX) \
    && tar xzf /fuyun/sources/l/lmod/${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1  \
    && cd $TMP_BUILD  \
    && ./configure --prefix=/fuyun/software  --with-lua_include=/usr/include/lua5.2/; make install  \
    && cd ..  \
    && rm -rf $TMP_BUILD  

RUN /bin/bash