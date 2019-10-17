
ARG OS_LABEL=fydev_os:latest

FROM ${OS_LABEL}

ENV container=docker

ENV FYDEV_USER=fydev

ENV PKG_DIR=/packages

ARG BUILD_DIR=/tmp/${FYDEV_USER}_build

ARG LMOD_VERSION=8.1.18

ARG EASYBUILD_VERSION=4.0.0

ENV EASYBUILD_PREFIX ${PKG_DIR}

LABEL Name          fydev_pkgs
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "OS independent module/packages.  "


############################
# Prepare directory for  packages 
USER root
RUN mkdir -m 755 -p ${PKG_DIR}
RUN chown  ${FYDEV_USER}.${FYDEV_USER}  -R ${PKG_DIR}
RUN chmod 755 ${PKG_DIR}

# RUN mkdir -m 755 -p ${BUILD_DIR}
# RUN chown  ${FYDEV_USER}.${FYDEV_USER}  -R ${BUILD_DIR}

############################
# Install lmod

USER ${FYDEV_USER}

RUN mkdir -m 755 -p ${BUILD_DIR}

RUN mkdir ${PKG_DIR}/sources

WORKDIR ${PKG_DIR}/sources

RUN curl -L https://github.com/TACC/Lmod/archive/${LMOD_VERSION}.tar.gz  -o lmod-${LMOD_VERSION}.tar.gz



WORKDIR ${BUILD_DIR}

RUN mkdir lmod-${LMOD_VERSION} && \
    tar xvf ${PKG_DIR}/sources/lmod-${LMOD_VERSION}.tar.gz -C lmod-${LMOD_VERSION}  --strip-components=1 && \
    cd  lmod-${LMOD_VERSION} && \
    ./configure --prefix=${PKG_DIR}/software/lmod/${LMOD_VERSION}/ && \
    make install && \
    cd .. && rm -rf lmond-${LMOD_VERSION}


USER root

RUN ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/profile     /etc/profile.d/lmod.sh && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/bash        /etc/profile.d/lmod.bash && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/zsh         /etc/profile.d/lmod.zsh && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/csh         /etc/profile.d/lmod.csh && \
    ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions


############################
# Install Easybuild
USER ${FYDEV_USER}


# NOTE (salmon 20191016): bootstrap_eb.py  can not pass stage 2 in docker building
WORKDIR ${PKG_DIR}/sources
# RUN curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/easybuild-framework-v${EASYBUILD_VERSION}/easybuild/scripts/bootstrap_eb.py
# RUN source /etc/profile.d/lmod.sh && python ${PKG_DIR}/source/easybuild/${EASYBUILD_VERSION}/bootstrap_eb.py ${EASYBUILD_PREFIX}

# Install from source 
# RUN curl -LO https://github.com/hpcugent/vsc-install/archive/0.12.7.tar.gz
RUN curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${EASYBUILD_VERSION}.tar.gz
RUN curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${EASYBUILD_VERSION}.tar.gz
RUN curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${EASYBUILD_VERSION}.tar.gz

# ENV EASYBUILD_BOOTSTRAP_SOURCEPATH ${PKG_DIR}/source
# RUN source  ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/bash  && python ${PKG_DIR}/source/bootstrap_eb.py ${EASYBUILD_PREFIX} 

WORKDIR ${BUILD_DIR}

RUN mkdir easybuild-framework && \
    tar xzvf ${PKG_DIR}/sources/easybuild-framework-v${EASYBUILD_VERSION}.tar.gz -C easybuild-framework  --strip-components=1 && \
    cd easybuild-framework && \
    source /etc/profile.d/lmod.sh && pip3 install --install-option "--prefix=${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}" . 

RUN mkdir easybuild-easyconfigs && \
    tar xzvf ${PKG_DIR}/sources/easybuild-easyconfigs-v${EASYBUILD_VERSION}.tar.gz -C easybuild-easyconfigs  --strip-components=1 && \
    cd easybuild-easyconfigs && \
    source /etc/profile.d/lmod.sh &&  pip3 install --install-option "--prefix=${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}"  . 

RUN mkdir easybuild-easyblocks && \
    tar xzvf ${PKG_DIR}/sources/easybuild-easyblocks-v${EASYBUILD_VERSION}.tar.gz -C easybuild-easyblocks   --strip-components=1 && \
    cd easybuild-easyblocks && \
    source /etc/profile.d/lmod.sh &&  pip3 install --install-option "--prefix=${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}"  . 

RUN rm -rf ${BUILD_DIR}

RUN mkdir -m 755 -p ${EASYBUILD_PREFIX}/modules/all/EasyBuild/ && \
    echo -e "\n\
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
    " > ${EASYBUILD_PREFIX}/modules/all/EasyBuild/${EASYBUILD_VERSION}.lua  

USER root 
RUN ln -s ${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}/bin/eb_bash_completion.bash /etc/bash_completion.d/eb_bash_completion.bash && \
    ln -s ${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}/bin/optcomplete.bash /etc/bash_completion.d/optcomplete.bash && \
    echo "complete -F _optcomplete eb" >> ${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}/bin/optcomplete.bash

ENV MODULEPATH ${PKG_DIR}/modules/all:${PKG_DIR}/software/lmod/${LMOD_VERSION}/modulefiles/Linux:${PKG_DIR}/software/lmod/${LMOD_VERSION}/modulefiles/Core:${PKG_DIR}/software/lmod/${LMOD_VERSION}/8.1.18/lmod/lmod/modulefiles/Core

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}

# update $MODULEPATH, and load the EasyBuild module
# RUN source /etc/profile.d/lmod.sh
# ENV MODULEPATH=${PKG_DIR}/modules/all
