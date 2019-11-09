# syntax=docker/dockerfile:experimental

ARG BASE_OS=centos7

FROM fyos:${BASE_OS} 


ARG FYDEV_USER=fydev 
ARG FYDEV_USER_ID=1000

ARG FY_LMOD_VERSION=8.1.18
ARG FY_EB_VERSION=4.0.1

LABEL Description   "fyBox bootstrap: lmod ${FY_LMOD_VERSION} + EasyBuild ${FY_EB_VERSION}, PKG_DIR=${PKG_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "
LABEL Name          "fyBootstrap"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "Create module envirnments "


################################################################################
# Add user for DevOps
# Add user for DevOps
# RUN groupadd -f ${FYDEV_GROUP} -g ${FYDEV_GROUP_ID}
RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER}  && \
    usermod -a -G wheel  ${FYDEV_USER} && \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

################################################################################
# Install lmod+easybuild
# Install lmod
RUN --mount=type=bind,target=/tmp/sources,source=sources \
    BUILD_DIR=$(mktemp -d -t build-lmod-XXXXXXXXXX)  && \
    mkdir -p ${BUILD_DIR}/lmod  && \
    tar xzf /tmp/sources/lmod-${FY_LMOD_VERSION}.tar.gz -C ${BUILD_DIR}/lmod --strip-components=1 && \
    cd ${BUILD_DIR}/lmod &&\
    ./configure  && make install && \  
    ls /usr/local &&\
    sudo ln -s /usr/local/lmod/lmod/init/profile     /etc/profile.d/lmod.sh && \
    sudo ln -s /usr/local/lmod/lmod/init/bash        /etc/profile.d/lmod.bash && \
    sudo ln -s /usr/local/lmod/lmod/init/zsh         /etc/profile.d/lmod.zsh && \
    sudo ln -s /usr/local/lmod/lmod/init/csh         /etc/profile.d/lmod.csh && \
    sudo ln -s /usr/local/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  && \
    rm -rf ${BUILD_DIR}
 
USER ${FYDEV_USER}
ARG PKG_DIR=/packages

RUN sudo mkdir -p ${PKG_DIR} &&\
    sudo chown ${FYDEV_USER}:${FYDEV_USER} ${PKG_DIR} 

RUN --mount=type=bind,target=/tmp/sources,source=sources \
    source /etc/profile.d/lmod.bash  &&\   
    EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES \
    EASYBUILD_BOOTSTRAP_SOURCEPATH=/tmp/sources \
    EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION} \
    python /tmp/sources/bootstrap_eb.py ${PKG_DIR}   
   


ENV FYDEV_USER=${FYDEV_USER}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}
ENV PKG_DIR=${PKG_DIR}
ENV EASYBUILD_PREFIX=${PKG_DIR}
ENV MODULEPATH="${PKG_DIR}/modules/all${MODULEPATH}"




ARG EB_ARGS=" --use-existing-modules --info -l -r"

#-------------------------------------------------------------------------------
# Java 
ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
ENV JAVA_VERSION=${JAVA_VERSION}

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=sources,source=sources  \
    --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} 



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
