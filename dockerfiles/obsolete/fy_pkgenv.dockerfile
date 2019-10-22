
ARG OS_LABEL=fy_os:centos7

FROM ${OS_LABEL}

ENV container=docker

LABEL Name          fydev_base
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   " create user 'fydev' ; Add lmod + EasyBuild ; "

# Add user for DevOps
ARG FYDEV_USER=fydev 
ARG FYDEV_USER_ID=1000
ARG FYDEV_GROUP=${FYDEV_USER}
ARG FYDEV_GROUP_ID=${FYDEV_USER}

ENV FYDEV_USER=${FYDEV_USER}
ENV FYDEV_GROUP=${FYDEV_GROUP}

RUN groupadd -f ${FYDEV_GROUP} -g ${FYDEV_GROUP_ID}
RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} 
RUN usermod -a -G ${FYDEV_GROUP}  ${FYDEV_USER} && echo '%'+${FYDEV_GROUP} +' ALL=(ALL)    NOPASSWD: ALL'>>/etc/sudoers

ENV PKG_DIR=/packages

ARG LMOD_VERSION=8.1.18

ARG EASYBUILD_VERSION=4.0.1

 
ENV EB_ARGS="  --use-existing-modules  -r"


ARG BUILD_DIR=/tmp/

############################
# Prepare directory for  packages 
RUN mkdir -m 755 -p ${PKG_DIR} && \
    mkdir -m 755 -p ${BUILD_DIR}  


############################
# Install lmod
# Download sources
RUN mkdir -m 755 -p ${PKG_DIR}/sources/l/lmod/ &&\
    curl -L https://github.com/TACC/Lmod/archive/${LMOD_VERSION}.tar.gz  -o ${PKG_DIR}/sources/l/lmod/lmod-${LMOD_VERSION}.tar.gz &&\
    mkdir ${BUILD_DIR}/lmod-${LMOD_VERSION} && \
    tar xvf ${PKG_DIR}/sources/l/lmod/lmod-${LMOD_VERSION}.tar.gz -C ${BUILD_DIR}/lmod-${LMOD_VERSION}  --strip-components=1 && \
    cd  ${BUILD_DIR}/lmod-${LMOD_VERSION} && \
    ./configure --prefix=${PKG_DIR}/software/lmod/${LMOD_VERSION}/ && \
    make install && \
    cd ${BUILD_DIR} && rm -rf ${BUILD_DIR}/lmod-${LMOD_VERSION} && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/profile     /etc/profile.d/lmod.sh && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/bash        /etc/profile.d/lmod.bash && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/zsh         /etc/profile.d/lmod.zsh && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/csh         /etc/profile.d/lmod.csh && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions


############################
# Install Easybuild
# Download sources
RUN mkdir -p ${PKG_DIR}/sources/e/easybuild/ && \
    mkdir -p ${BUILD_DIR}/easybuild-framework && \
    tar xzvf ${PKG_DIR}/sources/easybuild-framework-v${EASYBUILD_VERSION}.tar.gz -C  ${BUILD_DIR}/easybuild-framework  --strip-components=1 && \
    cd  ${BUILD_DIR}/easybuild-framework && \
    source /etc/profile.d/lmod.sh && pip3 install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${EASYBUILD_VERSION}" . && \
    cd .. && rm -rf ${BUILD_DIR}/easybuild-framework  && \
    mkdir  ${BUILD_DIR}/easybuild-easyconfigs && \
    tar xzvf ${PKG_DIR}/sources/easybuild-easyconfigs-v${EASYBUILD_VERSION}.tar.gz -C  ${BUILD_DIR}/easybuild-easyconfigs  --strip-components=1 && \
    cd  ${BUILD_DIR}/easybuild-easyconfigs && \
    source /etc/profile.d/lmod.sh &&  pip3 install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${EASYBUILD_VERSION}"  . && \
    cd .. && rm -rf ${BUILD_DIR}/easybuild-easyconfigs  && \
    mkdir -p ${BUILD_DIR}/easybuild-easyblocks && \
    tar xzvf ${PKG_DIR}/sources/easybuild-easyblocks-v${EASYBUILD_VERSION}.tar.gz -C  ${BUILD_DIR}/easybuild-easyblocks   --strip-components=1 && \
    cd  ${BUILD_DIR}/easybuild-easyblocks && \
    source /etc/profile.d/lmod.sh &&  pip3 install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${EASYBUILD_VERSION}"  .  && \
    cd .. && rm -rf ${BUILD_DIR}/easybuild-easyblocks   && \
    ln -s ${PKG_DIR}/software/EasyBuild/${EASYBUILD_VERSION}/bin/eb_bash_completion.bash /etc/bash_completion.d/eb_bash_completion.bash && \
    ln -s ${PKG_DIR}/software/EasyBuild/${EASYBUILD_VERSION}/bin/optcomplete.bash /etc/bash_completion.d/optcomplete.bash && \
    echo "complete -F _optcomplete eb" >> ${PKG_DIR}/software/EasyBuild/${EASYBUILD_VERSION}/bin/optcomplete.bash && \
    mkdir -m 755 -p ${EASYBUILD_PREFIX}/modules/all/EasyBuild/ && \
    cat > ${EASYBUILD_PREFIX}/modules/all/EasyBuild/${EASYBUILD_VERSION}.lua  <<" EOF  \n\
    help([==[   \n\
    \n\
    Description   \n\
    ===========   \n\
    EasyBuild is a software build and installation framework   \n\
    written in Python that allows you to install software in a structured,   \n\
    repeatable and robust way.   \n\
    \n\
    \n\
    More information   \n\
    ================   \n\
    - Homepage: http://easybuilders.github.com/easybuild/   \n\
    ]==])   \n\
    \n\
    whatis([==[Description: EasyBuild is a software build and installation framework   \n\
    written in Python that allows you to install software in a structured,   \n\
    repeatable and robust way.]==])   \n\
    whatis([==[Homepage: http://easybuilders.github.com/easybuild/]==])   \n\
    \n\
    local root = \"${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}\"   \n\
    \n\
    conflict(\"EasyBuild\")   \n\
    \n\
    prepend_path(\"PATH\", pathJoin(root, \"bin\"))   \n\
    setenv(\"EBROOTEASYBUILD\", root)   \n\
    setenv(\"EBVERSIONEASYBUILD\", \"${EASYBUILD_VERSION}\")   \n\
    setenv(\"EBDEVELEASYBUILD\", pathJoin(root, \"easybuild/EasyBuild-${EASYBUILD_VERSION}-easybuild-devel\"))   \n\
    \n\
    prepend_path(\"PYTHONPATH\", pathJoin(root, \"lib/python"`python3 -c "import sys;print(f'{sys.version_info.major}.{sys.version_info.minor}')"`"/site-packages\"))   \n\
    -- Built with EasyBuild version ${EASYBUILD_VERSION}   \n\
    \n\
    EOF"

USER root 


ENV MODULEPATH ${PKG_DIR}/modules/all:${PKG_DIR}/software/lmod/${LMOD_VERSION}/modulefiles/Linux:${PKG_DIR}/software/lmod/${LMOD_VERSION}/modulefiles/Core:${PKG_DIR}/software/lmod/${LMOD_VERSION}/8.1.18/lmod/lmod/modulefiles/Core




RUN chown  ${FYDEV_USER}.${FYDEV_GROUP}  -R ${PKG_DIR} &&\
    rm -rf ${BUILD_DIR}

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}

# update $MODULEPATH, and load the EasyBuild module
# RUN source /etc/profile.d/lmod.sh
# ENV MODULEPATH=${PKG_DIR}/modules/all
