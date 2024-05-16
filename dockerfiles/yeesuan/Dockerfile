ARG BASE_OS=${BASE_OS:-centos:7.6.1810}
FROM ${BASE_OS}

LABEL Author="Salmon <yuzhi@ipp.ac.cn>"

RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  \
    && yum update -y  \
    && yum install -y sudo   

########################################################
# Setup  fuyun
ARG FY_ROOT=${FY_ROOT:-/fuyun}

ARG FY_UID=1000
ARG FY_GID=1000
ARG FY_USER=fuyun
ARG FY_GROUP=fuyun
ARG FY_HOME=/home

RUN  mkdir -p ${FY_HOME} \
    && groupadd -g ${FY_GID} "${FY_GROUP}"  \
    && useradd -l -m -s /bin/bash -N -u "${FY_UID}" -g "${FY_GID}" --groups "${FY_GROUP}" -d "${FY_HOME}/${FY_USER}"  "${FY_USER}"   \
    && echo "${FY_USER} ALL=(ALL)   NOPASSWD: ALL" >>/etc/sudoers \
    && mkdir -p ${FY_ROOT} \
    && chown -R ${FY_USER}:${FY_GROUP} ${FY_ROOT}  \
    && chmod -R 775 ${FY_ROOT}  

VOLUME ${FY_ROOT}

ENV FY_ROOT=${FY_ROOT} \
    EASYBUILD_PREFIX=${FY_ROOT} \
    MODULEPATH=${FY_ROOT}/modules/all

USER ${FY_USER} 

RUN echo ". ${FY_ROOT}/scripts/profile" >> ${FY_HOME}/${FY_USER}/.bashrc

WORKDIR ${FY_HOME}/${FY_USER}

SHELL [ "/bin/bash" ]
# COPY archive /tmp/archive

# #######################################################
# # Install  easybuild
# RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir /tmp/archive/easybuild-*.tar.gz   

# #######################################################
# # Install LMOD  
# RUN TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)  \
#     && cd $TMP_BUILD  \
#     && tar xzf /tmp/archive/lmod-*.tar.gz  --strip-components=1  \
#     && ./configure --prefix=/usr/local/  --with-lua_include=/usr/include/lua/ \
#     && make install  \
#     && ln -s /usr/local/lmod/lmod/init/profile        /etc/profile.d/z00_lmod.sh    \
#     && ln -s /usr/local/lmod/lmod/init/cshrc          /etc/profile.d/z00_lmod.csh   \
#     && echo 'source /usr/local/lmod/lmod/init/profile' >> /etc/bash.bashrc \
#     && cd ..  \
#     && rm -rf $TMP_BUILD 



# 


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
