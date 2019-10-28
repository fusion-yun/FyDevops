# syntax=docker/dockerfile:experimental

ARG BASE_OS=centos7

FROM fybox_os:${BASE_OS}


ARG PKG_DIR=/packages

ARG FY_LMOD_VERSION=8.1.18
ARG FY_EB_VERSION=4.0.1

LABEL Description   "fyBox base: lmod ${FY_LMOD_VERSION} + EasyBuild ${FY_EB_VERSION}, PKG_DIR=${PKG_DIR}"
LABEL Name          "fybox_base"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "Create module envirnments "

################################################################################
# Add user for DevOps
# Add user for DevOps
# RUN groupadd -f ${FYDEV_GROUP} -g ${FYDEV_GROUP_ID}
ARG FYDEV_USER=fydev 
ARG FYDEV_USER_ID=1000
ENV FYDEV_USER=${FYDEV_USER}

RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER}  && \
    usermod -a -G wheel  ${FYDEV_USER} && \
    mkdir -m755 -p ${PKG_DIR}  && \
    chown  ${FYDEV_USER}.${FYDEV_GROUP}  -R ${PKG_DIR}   && \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

################################################################################
# Install lmod+easybuild
USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}/

# Install lmod
RUN --mount=type=bind,target=sources,source=bootstrap_sources \
    BUILD_DIR=$(mktemp -d -t build-lmod-XXXXXXXXXX)  && \
    tar xzf sources/lmod-${FY_LMOD_VERSION}.tar.gz -C ${BUILD_DIR} --strip-components=1 && \
    cd ${BUILD_DIR} &&\
    ./configure --prefix=${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/ && \
    make install && \  
    rm -rf ${BUILD_DIR} && \
    sudo ln -s ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/lmod/lmod/init/profile     /etc/profile.d/lmod.sh && \
    sudo ln -s ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/lmod/lmod/init/bash        /etc/profile.d/lmod.bash && \
    sudo ln -s ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/lmod/lmod/init/zsh         /etc/profile.d/lmod.zsh && \
    sudo ln -s ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/lmod/lmod/init/csh         /etc/profile.d/lmod.csh && \
    sudo ln -s ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions && \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/lmod/lmod/init/profile  && \
    cd ~ &&\
    EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES \
    EASYBUILD_BOOTSTRAP_SOURCEPATH=~/sources \
    EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION} \
    python sources/bootstrap_eb.py ${PKG_DIR}

ENV EASYBUILD_PREFIX=${PKG_DIR}
ENV MODULEPATH="${PKG_DIR}/modules/all${MODULEPATH}"


# Java 
ARG JAVA_VERSION=13.0.1

RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} 


ENV FY_PKG_DIR=${PKG_DIR}
ENV FY_JAVA_VERSION=${JAVA_VERSION}

# pip install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${FY_EB_VERSION}" install_sources/easybuild-framework-v${FY_EB_VERSION}.tar.gz && \
# pip install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${FY_EB_VERSION}" install_sources/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz && \
# pip install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${FY_EB_VERSION}" install_sources/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz && \
# mkdir -p ${PKG_DIR}/modules/all/EasyBuild/ && \
# export PY_SHORTVER=`python -c "import sys;print(str(sys.version_info.major)+'.'+str(sys.version_info.minor))"` && \
# echo -e \
# \
# "   \n\
# help([==[   \n\
# \n\
# Description   \n\
# ===========   \n\
# EasyBuild is a software build and installation framework   \n\
# written in Python that allows you to install software in a structured,   \n\
# repeatable and robust way.   \n\
# \n\
# \n\
# More information   \n\
# ================   \n\
# - Homepage: http://easybuilders.github.com/easybuild/   \n\
# ]==])   \n\
# \n\
# whatis([==[Description: EasyBuild is a software build and installation framework   \n\
# written in Python that allows you to install software in a structured,   \n\
# repeatable and robust way.]==])   \n\
# whatis([==[Homepage: http://easybuilders.github.com/easybuild/]==])   \n\
# \n\
# local root = \"${PKG_DIR}/software/EasyBuild/${FY_EB_VERSION}\"   \n\
# \n\
# conflict(\"EasyBuild\")   \n\
# \n\
# prepend_path(\"PATH\", pathJoin(root, \"bin\"))   \n\
# setenv(\"EASYBUILD_PREFIX\", \"${PKG_DIR}\")   \n\    
# setenv(\"EBROOTEASYBUILD\", root)   \n\
# setenv(\"EBVERSIONEASYBUILD\", \"${FY_EB_VERSION}\")   \n\
# setenv(\"EBDEVELEASYBUILD\", pathJoin(root, \"easybuild/EasyBuild-${FY_EB_VERSION}-easybuild-devel\"))   \n\
# \n\
# prepend_path(\"PYTHONPATH\", pathJoin(root, \"lib/python${PY_SHORTVER}/site-packages\"))   \n\
# -- Built with EasyBuild version ${FY_EB_VERSION}   \n\
# \n\
# " > ${PKG_DIR}/modules/all/EasyBuild/${FY_EB_VERSION}.lua
