# syntax=docker/dockerfile:experimental
ARG IMAGE_TAG=${IMAGE_TAG:-latest}
FROM fybase:${IMAGE_TAG}

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}


################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}


ARG FYDEV_VERSION=${FYDEV_VERSION:-0.0.0}
ENV FYDEV_VERSION=${FYDEV_VERSION}
ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.0}
ENV FYLAB_VERSION=${FYLAB_VERSION}

# ####################################################################
# #  setup cache

# RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
# sudo mkdir -p /tmp/cache/sources ; \ 
# sudo mkdir -p /tmp/cache/trash ; \ 
# sudo mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION} ; \
# sudo chown ${FYDEV_USER}:${FYDEV_USER} -R /tmp/cache/${FY_OS}_${FY_OS_VERSION} ;\
# sudo mkdir -p ${FUYUN_DIR} ;\
# sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR} ;\
# mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION}/software ;\
# mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION}/modules ;\
# mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ;\
# ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}/software  ${FUYUN_DIR}/software ; \ 
# ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}/modules   ${FUYUN_DIR}/modules  ; \
# ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo   ${FUYUN_DIR}/ebfiles_repo ; \
# ln -sf /tmp/cache/sources   ${FUYUN_DIR}/sources  



################################################################################
# Bootstrap
# Install EasyBuild
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun,sharing=shared \        
    source /etc/profile.d/modules.sh ; \
    if ! [ -d ${FUYUN_DIR}/software/EasyBuild/${FY_EB_VERSION} ]; then \
    if ! [ -f ${FUYUN_DIR}/source/bootstrap/bootstrap_eb.py  ]; then  \    
    mkdir -p  ${FUYUN_DIR}/source/bootstrap/ ; \    
    curl -L https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py -o ${FUYUN_DIR}/source/bootstrap/bootstrap_eb.py ;\
    curl -L https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz -o ${FUYUN_DIR}/source/bootstrap/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz; \
    curl -L https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz -o ${FUYUN_DIR}/source/bootstrap/easybuild-framework-v${FY_EB_VERSION}.tar.gz ; \
    curl -L https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz -o ${FUYUN_DIR}/source/bootstrap/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz ; \
    fi ; \  
    export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES  ; \
    export EASYBUILD_BOOTSTRAP_SOURCEPATH=${FUYUN_DIR}/source/bootstrap/  ; \
    export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}  ; \
    /usr/bin/python3 ${FUYUN_DIR}/source/bootstrap/bootstrap_eb.py    ${FUYUN_DIR} ; \
    unset EASYBUILD_BOOTSTRAP_SKIP_STAGE0 ; \
    unset EASYBUILD_BOOTSTRAP_SOURCEPATH ; \
    unset EASYBUILD_BOOTSTRAP_FORCE_VERSION ; \    
    fi; \
    sudo ln -s  ${FY_EB_ROOT}/software/EasyBuild/${FY_EB_VERSION}/bin/eb_bash_completion.bash /etc/bash_completion.d/

####################################################################
# install packages
ENV EASYBUILD_PREFIX=${FUYUN_DIR}
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\    
    module use ${FUYUN_DIR}/modules/all ; \
    module avail ; \
    module load EasyBuild/${FY_EB_VERSION} ; \      
    eb --info -r  \
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    --moduleclasses=fuyun  \
    /tmp/ebfiles/FyDev-${FYDEV_VERSION}.eb 




RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    if ! [ -d ${FUYUN_DIR} ] ; then \
    sudo mkdir -p ${FUYUN_DIR}   ; \
    fi ; \
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR} ;\
    ################################
    cp -r /tmp/cache/modules ${FUYUN_DIR}/ ; \
    cp -r /tmp/cache/ebfiles_repo ${FUYUN_DIR}/ ; \
    cp -r /tmp/cache/software ${FUYUN_DIR}/ ; \
    cp -r /tmp/cache/sources ${FUYUN_DIR}/ 


ENV MODULEPATH=${FUYUN_DIR}/modules/base:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/compiler:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/data:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/devel:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/lang:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/lib:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/math:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/mpi:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/numlib:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/system:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/toolchain:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/tools:${MODULEPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/fuyun:${MODULEPATH}

LABEL Name          "FyDev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FuDev : Develop enverioment of FuYun  "

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
# RUN pip config set global.index-url https://mirrors.aliyun.com/simple ; \
#     pip config set install.trusted-host mirrors.aliyun.com 
