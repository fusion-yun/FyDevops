# syntax=docker/dockerfile:experimental
ARG IMAGE_TAG=${IMAGE_TAG:-latest}
FROM fydev:${IMAGE_TAG}

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}


################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.0}
ENV FYLAB_VERSION=${FYLAB_VERSION}

USER   ${FYDEV_USER}


ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

####################################################################
# install packages

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

ARG EB_ARGS="--info -r \
    --use-existing-modules \
    --minimal-toolchain \
    --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    --moduleclasses=fuyun" 

##############################################################################
# only for cache, not necessary
RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_SOURCEPATH=/tmp/cache/sources  ; \     
    module load EasyBuild ; \   
    eb ${EB_ARGS}  --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    SciPy-bundle-2019.10-foss-2019b-Python-3.7.4.eb  

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_SOURCEPATH=/tmp/cache/sources  ; \     
    module load EasyBuild ; \   
    eb ${EB_ARGS} --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    Graphviz-2.42.2-foss-2019b-Python-3.7.4.eb  

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_SOURCEPATH=/tmp/cache/sources  ; \     
    module load EasyBuild ; \   
    eb ${EB_ARGS} --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    PyYAML-5.1.2-GCCcore-8.3.0-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_SOURCEPATH=/tmp/cache/sources  ; \     
    module load EasyBuild ; \   
    eb ${EB_ARGS} JupyterLab-1.2.5-foss-2019b-Python-3.7.4.eb   

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_SOURCEPATH=/tmp/cache/sources  ; \     
    module load EasyBuild ; \   
    eb ${EB_ARGS} matplotlib-3.1.1-foss-2019b-Python-3.7.4.eb   

##############################################################################

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    export EASYBUILD_SOURCEPATH=/tmp/cache/sources  ; \ 
    module load EasyBuild ; \   
    module avail  ; \  
    eb --info -r \
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    --moduleclasses=fuyun \
    /tmp/ebfiles/FyLab-${FYLAB_VERSION}.eb ; \
    module avail  




# ENV MODULEPATH=${FUYUN_DIR}/modules/base:${FUYUN_DIR}/modules/compiler:${FUYUN_DIR}/modules/data:${FUYUN_DIR}/modules/devel:${FUYUN_DIR}/modules/lang:${FUYUN_DIR}/modules/lib:${FUYUN_DIR}/modules/math:${FUYUN_DIR}/modules/mpi:${FUYUN_DIR}/modules/numlib:${FUYUN_DIR}/modules/system:${FUYUN_DIR}/modules/toolchain:${FUYUN_DIR}/modules/tools:${MODULEPATH}
# # RUN sudo rm -rf /tmp/cache


# LABEL Name          "fyDev"
# LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
# LABEL Description   "FuYun : FUYUN_DIR=${FUYUN_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "

# USER ${FYDEV_USER}
# WORKDIR /home/${FYDEV_USER}
