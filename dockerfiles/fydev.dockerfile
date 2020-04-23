# syntax=docker/dockerfile:experimental
ARG FY_OS=centos
ARG FY_OS_VERSION=8
FROM fybase:${FY_OS}_${FY_OS_VERSION} 


ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}


################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FYDEV_VERSION=${FYDEV_VERSION:-0.0.0}
ENV FYDEV_VERSION=${FYDEV_VERSION}

USER   ${FYDEV_USER}


ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

RUN sudo mkdir -p ${FUYUN_DIR} ;\
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR}

####################################################################
# install packages

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    sudo mkdir -p /tmp/cache/sources ; \ 
    sudo mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION} ; \
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R /tmp/cache/${FY_OS}_${FY_OS_VERSION} ;\
    sudo mkdir ${FUYUN_DIR} ;\
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR} ;\
    mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION}/software ;\
    mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION}/modules ;\
    mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ;\
    ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}/software  ${FUYUN_DIR}/software ; \ 
    ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}/modules   ${FUYUN_DIR}/modules  ; \
    ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo   ${FUYUN_DIR}/ebfiles_repo 

ENV EASYBUILD_PREFIX=${FUYUN_DIR}
ENV EASYBUILD_BUILDPATH=/tmp/eb_build
ENV EASYBUILD_SOURCEPATH=/tmp/cache/sources 

####################################################################
# install packages

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    module avail ; \
    module load EasyBuild ; \    
    eb --show-config ;\   
    eb --rebuild Java-13.eb --info -lr 
    # eb --info -lr  --rebuild \
    # --use-existing-modules \
    # --minimal-toolchain \
    # --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    # --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    # /tmp/ebfiles/FyDev-${FYDEV_VERSION}.eb 



ENV MODULEPATH=${FUYUN_DIR}/modules/all:${MODULEPATH}
# RUN sudo rm -rf /tmp/cache

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    source /etc/profile.d/modules.sh ;\
    ###############################
    rm ${FUYUN_DIR}/software ;\
    rm ${FUYUN_DIR}/modules ;\
    rm ${FUYUN_DIR}/ebfiles_repo ;\
    ################################
    cp -r /tmp/cache/${FY_OS}_${FY_OS_VERSION}/modules ${FUYUN_DIR}/ ; \
    cp -r /tmp/cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ${FUYUN_DIR}/ ; \
    cp -r /tmp/cache/${FY_OS}_${FY_OS_VERSION}/software ${FUYUN_DIR}/ 


LABEL Name          "fyDev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FuYun : FUYUN_DIR=${FUYUN_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
