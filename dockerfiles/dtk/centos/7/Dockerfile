FROM image.sourcefind.cn:5000/dcu/admin/base/vscode-dtk:22.10-centos7.6-py37-latest

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"

USER root

RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum install -y dnf-plugins-core  \    
    && yum update -y  \
    && yum groupinstall -y "Development Tools" \
    && yum install -y sudo wget perl tcl-devel openssl openssl-devel libibverbs-devel vim unzip \
    lua-devel lua-posix lua-filesystem\
    && yum clean all -y -q



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

#######################################################
# Install Easybuild
RUN pip install --no-cache-dir --upgrade pip \
    && pip install easybuild \
    && rm -rf /root/.cache/pip

#######################################################
# Setup user
RUN echo "fuyun ALL=(ALL)   NOPASSWD: ALL" >>/etc/sudoers \
    && groupadd -g "1000" "fuyun"  \
    && useradd -l -m -s /bin/bash -N -u "1000" -g "1000" --groups "fuyun" -d "/home/fuyun"  "fuyun"  \
    && mkdir -p /fuyun -m 775 \
    && chown fuyun:fuyun /fuyun

USER fuyun