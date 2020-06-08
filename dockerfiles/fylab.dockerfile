# syntax=docker/dockerfile:experimental
ARG BASE_TAG=${BASE_TAG:-fybase:latest}
ARG PREV_STAGE=${PREV_STAGE:-fydev:latest}
FROM ${PREV_STAGE} as prev_stage


FROM ${BASE_TAG} AS build_stage

################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}
ENV FY_EB_VERSION=${FY_EB_VERSION}

####################################################################
ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.1}
ENV FYLAB_VERSION=${FYLAB_VERSION}


ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
ENV PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple 

ENV EASYBUILD_PREFIX=${FUYUN_DIR}

USER   ${FYDEV_USER}

COPY --chown=${FYDEV_USER}:${FYDEV_USER} easybuild /tmp/easybuild
COPY --chown=${FYDEV_USER}:${FYDEV_USER} sources/ /tmp/ebsources

# reuse previous result 
COPY --chown=${FYDEV_USER}:${FYDEV_USER} --from=prev_stage /fuyun/modules         /fuyun/modules
COPY --chown=${FYDEV_USER}:${FYDEV_USER} --from=prev_stage /fuyun/software        /fuyun/software
COPY --chown=${FYDEV_USER}:${FYDEV_USER} --from=prev_stage /fuyun/ebfiles_repo    /fuyun/ebfiles_repo


ARG FY_EB_ARGS="  --info -lr  --skip-test-cases --use-existing-modules --minimal-toolchain \
    --robot-paths=/tmp/easybuild/easyconfigs:${EASYBUILD_PREFIX}/software/EasyBuild/${FY_EB_VERSION}/easybuild/easyconfigs \
    --sourcepath=$EASYBUILD_PREFIX/sources:/tmp/ebsources "


RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \   
    eb ${FY_EB_ARGS} matplotlib-3.1.1-foss-2019b-Python-3.7.4.eb 

RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \   
    eb ${FY_EB_ARGS} bokeh-1.4.0-foss-2019b-Python-3.7.4.eb

RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \   
    eb ${FY_EB_ARGS}   nodejs-12.16.1-GCCcore-8.3.0.eb


RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \   
    eb  ${FY_EB_ARGS}  h5py-2.10.0-foss-2019b-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \   
    eb  ${FY_EB_ARGS} JupyterLab-2.1.1-foss-2019b-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \   
    eb   ${FY_EB_ARGS}   --moduleclasses=fuyun  FyLab-${FYLAB_VERSION}.eb  


# RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/fuyun/sources,sharing=shared \
#     if ! [ -d /fuyun/sources/fonts/ ] ; then \    
#     mkdir -p /fuyun/sources/fonts/ ;\
#     cd /fuyun/sources/fonts/ ; \
#     curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Regular.otf ; \
#     curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Bold.otf ; \    
#     fi && \
#     mkdir -p /home/${FYDEV_USER}/.local/share/fonts/ && \
#     cp /fuyun/sources/fonts/* /home/${FYDEV_USER}/.local/share/fonts/ && \
#     source /etc/profile.d/modules.sh &&\    
#     module load fontconfig &&\
#     fc-cache -fv 

FROM fybase:latest AS release_stage

COPY --chown=${FYDEV_USER}:${FYDEV_USER} --from=build_stage /fuyun/modules         /fuyun/modules
COPY --chown=${FYDEV_USER}:${FYDEV_USER} --from=build_stage /fuyun/software        /fuyun/software
COPY --chown=${FYDEV_USER}:${FYDEV_USER} --from=build_stage /fuyun/ebfiles_repo    /fuyun/ebfiles_repo


ARG BUILD_TAG=${BUILD_TAG:-dirty}
LABEL Name          "fyLab"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FyLab-${BUILD_TAG} : UI/UX for FuYun "


USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}

# USER root
# RUN echo $'#!/bin/sh \n\
#     source /etc/profile.d/modules.sh \n\
#     module use /fuyun/modules/fuyun \n\
#     module load FyLab \n\
#     echo "EXEC: " $@ \n\
#     $@' > /docker_entrypoint.sh && \
#     chmod +x /docker_entrypoint.sh 
# ENTRYPOINT [ "/docker_entrypoint.sh" ]