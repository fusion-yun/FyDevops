# syntax=docker/dockerfile:experimental
ARG BASE_TAG=${BASE_TAG:-fydev:latest}

FROM ${BASE_TAG}

################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.0}
ENV FYLAB_VERSION=${FYLAB_VERSION}

ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}
ENV FY_EB_VERSION=${FY_EB_VERSION}

####################################################################

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
ENV PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple 

ENV EASYBUILD_PREFIX=${FUYUN_DIR}

COPY --chown=fydev:fydev ./ebfiles ${FUYUN_DIR}/ebfiles

RUN --mount=type=cache,uid=1000,gid=1000,id=fylab_pre,target=/tmp/prebuild,sharing=shared \
    if [ -d /tmp/prebuild/modules ]; then cp -rf /tmp/prebuild/* ${FUYUN_DIR}/; fi   

USER   ${FYDEV_USER}

ARG FY_EB_ARGS="  --info -r  --skip-test-cases --use-existing-modules --minimal-toolchain \
    --robot-paths=${FUYUN_DIR}/ebfiles:${FUYUN_DIR}/software/EasyBuild/${FY_EB_VERSION}/easybuild/easyconfigs"


RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb ${FY_EB_ARGS} matplotlib-3.1.1-foss-2019b-Python-3.7.4.eb 
 
RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb ${FY_EB_ARGS} bokeh-1.4.0-foss-2019b-Python-3.7.4.eb

RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb ${FY_EB_ARGS}   nodejs-12.16.1-GCCcore-8.3.0.eb

RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb  ${FY_EB_ARGS}  JupyterLab-2.1.1-foss-2019b-Python-3.7.4.eb

RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb  ${FY_EB_ARGS}  h5py-2.10.0-foss-2019b-Python-3.7.4.eb

COPY --chown=${FYDEV_USER}:${FYDEV_USER} packages/FyLab-${FYDEV_VERSION}.eb ${FUYUN_DIR}/ebfiles/

RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   ${FY_EB_ARGS}   --moduleclasses=fuyun FyLab-${FYLAB_VERSION}.eb  


RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \
    if ! [ -d /fuyun/sources/fonts/ ] ; then \    
    mkdir -p /fuyun/sources/fonts/ ;\
    cd /fuyun/sources/fonts/ ; \
    curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Regular.otf ; \
    curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Bold.otf ; \    
    fi && \
    mkdir -p /home/${FYDEV_USER}/.local/share/fonts/ && \
    cp /fuyun/sources/fonts/* /home/${FYDEV_USER}/.local/share/fonts/ && \
    source /etc/profile.d/modules.sh &&\    
    module load fontconfig &&\
    fc-cache -fv 


ARG BUILD_TAG=${BUILD_TAG:-dirty}
LABEL Name          "fyLab"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FyLab(${BUILD_TAG}) : UI/UX for FuYun "


USER root
RUN echo $'#!/bin/sh \n\
    source /etc/profile.d/modules.sh \n\
    module use /fuyun/modules/fuyun \n\
    module load FyLab \n\
    echo "EXEC: " $@ \n\
    $@' > /docker_entrypoint.sh && \
    chmod +x /docker_entrypoint.sh 

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}

ENTRYPOINT [ "/docker_entrypoint.sh" ]