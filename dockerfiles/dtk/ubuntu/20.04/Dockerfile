FROM image.sourcefind.cn:5000/dcu/admin/base/vscode-dtk:23.04.1-ubuntu20.04-latest

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

#######################################################
# Install LMOD
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.7.37}
 
RUN TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX) \
    && cd $TMP_BUILD  \
    && wget https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz \
    && tar xzf ${FY_LMOD_VERSION}.tar.gz  --strip-components=1  \
    && ./configure --prefix=/opt/  --with-lua_include=/usr/include/lua5.2/ \
    && make install  \
    && ln -s /opt/lmod/lmod/init/profile        /etc/profile.d/z00_lmod.sh    \
    && ln -s /opt/lmod/lmod/init/cshrc          /etc/profile.d/z00_lmod.csh   \
    && echo 'source /opt/lmod/lmod/init/profile' >> /etc/bash.bashrc    \
    && cd ..  \
    && rm -rf $TMP_BUILD 

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

