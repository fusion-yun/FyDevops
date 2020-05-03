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

USER   ${FYDEV_USER}
ARG HOME_DIR=/home/${FYDEV_USER}
####################################################################
# install packages

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
ENV EASYBUILD_PREFIX=${FUYUN_DIR} 
ENV PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple 

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -r  --use-existing-modules --minimal-toolchain  --skip-test-cases\
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    SciPy-bundle-2019.10-foss-2019b-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -r  --use-existing-modules --minimal-toolchain  --skip-test-cases\
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    matplotlib-3.1.1-foss-2019b-Python-3.7.4.eb 
 
RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -r  --use-existing-modules --minimal-toolchain  --skip-test-cases \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    bokeh-1.4.0-foss-2019b-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -r  --use-existing-modules --minimal-toolchain  --skip-test-cases\
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    nodejs-12.16.1-GCCcore-8.3.0.eb

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -r  --use-existing-modules --minimal-toolchain  --skip-test-cases\
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    JupyterLab-2.1.1-foss-2019b-Python-3.7.4.eb

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -lr  --use-existing-modules --minimal-toolchain  --skip-test-cases\
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    h5py-2.10.0-foss-2019b-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb   -r --rebuild  --use-existing-modules --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --moduleclasses=fuyun  --skip-test-cases\
    FyLab-${FYLAB_VERSION}.eb  


RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \
    if ! [ -d /fuyun/sources/fonts/ ] ; then \    
    mkdir -p /fuyun/sources/fonts/ ;\
    cd /fuyun/sources/fonts/ ; \
    curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Regular.otf ; \
    curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Bold.otf ; \    
    fi && \
    mkdir -p ${HOME_DIR}/.local/share/fonts/ && \
    cp /fuyun/sources/fonts/* ${HOME_DIR}/.local/share/fonts/ && \
    source /etc/profile.d/modules.sh &&\    
    module load fontconfig &&\
    fc-cache -fv 

# eb  --info  --use-existing-modules  --minimal-toolchain --robot-paths=/workspaces/FyDevOps/ebfiles/:$EBROOTEASYBUILD/easybuild/easyconfigs  --moduleclasses=fuyun /workspaces/FyDevOps/ebfiles/FyLab-0.0.0.eb -Dr

LABEL Name          "fyLab"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FyLab : UI/UX for FuYun "
ARG BUILD_TAG=${BUILD_TAG:-dirty}
LABEL BUILD_TAG     ${BUILD_TAG}
USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}

USER root
RUN echo $'#!/bin/sh \n\
    source /etc/profile.d/modules.sh \n\
    module use /fuyun/modules/fuyun \n\
    module load FyLab \n\
    echo "EXEC: " $@ \n\
    $@' > /docker_entrypoint.sh && \
    chmod +x /docker_entrypoint.sh 

USER ${FYDEV_USER}

ENTRYPOINT [ "/docker_entrypoint.sh" ]