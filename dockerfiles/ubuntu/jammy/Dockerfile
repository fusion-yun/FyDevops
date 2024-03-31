FROM ubuntu:jammy

LABEL maintainer="Salmon <yuzhi@ipp.ac.cn>"

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update --yes  \
    && apt-get install --yes --no-install-recommends \
    build-essential libssl-dev libibverbs-dev tcl-dev python3 python3-pip python-is-python3 \
    lua5.3 liblua5.3-dev  lua-posix lua-posix-dev \
    unzip curl git file openssh-client rsync   \
    wget ca-certificates  sudo  locales vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*  \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
    && locale-gen


#######################################################

ARG FY_LOCAL_GID=${FY_LOCAL_GID:-504}
ARG FY_LOCAL_GROUP=${FY_LOCAL_GROUP:-develop}

ARG FY_USER=${FY_USER:-fuyun}
ARG FY_GROUP=${FY_GROUP:-fuyun}
ARG FY_UID=${FY_UID:-1100}
ARG FY_GID=${FY_GID:-1100}
ARG FY_HOME=${FY_HOME:-/home/fuyun}

ENV FY_ROOT ${FY_ROOT:-/fuyun}

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su \
    && sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers  \
    && sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers  \
    && echo "${FY_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers  \
    && groupadd -g ${FY_LOCAL_GID} ${FY_LOCAL_GROUP} \
    && groupadd -g "${FY_GID}" "${FY_GROUP}"  \
    && useradd -l -m -s /bin/bash -N -u "${FY_UID}" -g "${FY_GID}" --groups "${FY_LOCAL_GROUP}" -d "${FY_HOME}"  "${FY_USER}"  \
    && mkdir -p ${FY_ROOT} -m 775 \
    && chown ${FY_USER}:${FY_GROUP} ${FY_ROOT}  

#######################################################
USER ${FY_USER} 

ENV EASYBUILD_PREFIX=${FY_ROOT}
# ln -s ${FY_ROOT}/software/lmod/lmod/init/bash /etc/profile.d/100-lmod.sh 

# RUN TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)  \
#     && mkdir -p ${TMP_BUILD}  \
#     && cd ${TMP_BUILD}       \
#     && curl -L https://github.com/TACC/Lmod/archive/8.5.12.tar.gz -o lmod.tar.gz \
#     && tar xzf lmod.tar.gz --strip-components=1                             \
#     && ./configure --prefix=${FY_ROOT}/software/; make install                                                   \
#     && cd ..                                                                                                     \
#     && rm -rf ${TMP_BUILD}                                                                                       \
#     && pip  install --prefix ${FY_ROOT}/software/EasyBuild/ easybuild



