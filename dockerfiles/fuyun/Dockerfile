ARG BASE_OS=${BASE_OS:-fuyun:bare-centos7}
FROM ${BASE_OS}

LABEL Author="Salmon <yuzhi@ipp.ac.cn>"

USER root

COPY archive /tmp/archive

#######################################################
# Install  easybuild
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir /tmp/archive/easybuild-*.tar.gz   

#######################################################
# Install LMOD  
RUN TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)  \
    && cd $TMP_BUILD  \
    && tar xzf /tmp/archive/lmod-*.tar.gz  --strip-components=1  \
    && ./configure --prefix=/usr/local/  --with-lua_include=/usr/include/lua/ \
    && make install  \
    && ln -s /usr/local/lmod/lmod/init/profile        /etc/profile.d/z00_lmod.sh    \
    && ln -s /usr/local/lmod/lmod/init/cshrc          /etc/profile.d/z00_lmod.csh   \
    && echo 'source /usr/local/lmod/lmod/init/profile' >> /etc/bash.bashrc \
    && cd ..  \
    && rm -rf $TMP_BUILD 


#######################################################
# Clean up
RUN yum clean all -y -q  

########################################################
# Setup  fuyun
ARG FY_ROOT=${FY_ROOT:-/fuyun}

VOLUME ${FY_ROOT}

ENV FY_ROOT=${FY_ROOT} \
    EASYBUILD_PREFIX=${FY_ROOT} \
    MODULEPATH=${FY_ROOT}/modules/all

RUN groupadd -g "1000" "fuyun"  \
    && useradd -l -m -s /bin/bash -N -u "1000" -g "1000" --groups "fuyun" -d "/home/fuyun"  "fuyun"   \
    && echo "fuyun ALL=(ALL)   NOPASSWD: ALL" >>/etc/sudoers \
    && chown -R fuyun:fuyun ${FY_ROOT}  \
    && chmod -R 775 ${FY_ROOT}  

# USER fuyun 
# WORKDIR /home/fuyun
# SHELL [ "/bin/bash" ]


#######################################################
# set Label
# LABEL pytorch=2.1.0
# LABEL centos=7.6
# LABEL dtk=23.10.1
# LABEL python=3.8
# 
# && mkdir -p ${FY_ROOT} \
# && chmod -m 775 ${FY_ROOT}\

# ENV FY_ROOT=${FY_ROOT} EASYBUILD_PREFIX=${FY_ROOT}
# USER fuyun
# WORKDIR /home/fuyun
##################################################
# USAGE:
# docker build --build-arg="BASE_OS=image.sourcefind.cn:5000/dcu/admin/base/pytorch:2.1.0-centos7.6-dtk23.10.1-py38" -t fuyun:devel-pytorch-2.1.0-centos7.6-dtk23.10.1-py38 .
