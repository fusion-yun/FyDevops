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
    eb   -lr  --use-existing-modules --minimal-toolchain  --skip-test-cases\
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    HDF5-1.10.5-gompi-2019b.eb

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


LABEL Name          "fyLab"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FyLab : UI/UX for FuYun "
ARG BUILD_TAG=${BUILD_TAG:-dirty}
LABEL BUILD_TAG     ${BUILD_TAG}
USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
