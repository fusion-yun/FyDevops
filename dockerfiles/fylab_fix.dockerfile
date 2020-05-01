# syntax=docker/dockerfile:experimental
ARG BASE_TAG=${BASE_TAG:-fydev:latest}

FROM fylab:3ce1a7d-dirty_fix AS stage0

RUN mv /home/fydev/fydev /fuyun/software && \
    mv /fuyun/software/modules /fuyun/modules && \
    mv /fuyun/software/ebfiles_repo /fuyun/ebfiles_repo  


FROM fybase:latest

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
# ####################################################################
# # install packages

# ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
# ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
# ENV EASYBUILD_PREFIX=${FUYUN_DIR} 
# ENV PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple 

# RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/,sharing=shared \        
#     --mount=type=bind,target=/tmp/ebfiles,source=./ \
#     source /etc/profile.d/modules.sh &&\    
#     module load EasyBuild && \   
#     rm -rf /fuyun/software/.locks/* &&\
#     eb   -lr  --use-existing-modules --minimal-toolchain  --skip-test-cases\
#     --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
#     HDF5-1.10.5-gompi-2019b.eb

# RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/,sharing=shared \        
#     --mount=type=bind,target=/tmp/ebfiles,source=./ \
#     source /etc/profile.d/modules.sh &&\    
#     module load EasyBuild && \   
#     eb   -lr  --use-existing-modules --minimal-toolchain  --skip-test-cases\
#     --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
#     h5py-2.10.0-foss-2019b-Python-3.7.4.eb


# RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/,sharing=shared \        
#     --mount=type=bind,target=/tmp/ebfiles,source=./ \
#     source /etc/profile.d/modules.sh &&\    
#     module load EasyBuild && \   
#     eb   -lr  --use-existing-modules --minimal-toolchain  --skip-test-cases\
#     --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
#     Java-13.0.1.eb --module-only --rebuild
    
# RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/,sharing=shared \        
#     --mount=type=bind,target=/tmp/ebfiles,source=./ \
#     source /etc/profile.d/modules.sh &&\    
#     module load EasyBuild && \   
#     eb   -lr  --use-existing-modules --minimal-toolchain  --skip-test-cases\
#     --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
#     Graphviz-2.42.2-foss-2019b-Python-3.7.4.eb
    
# RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/,sharing=shared \        
#     --mount=type=bind,target=/tmp/ebfiles,source=./ \
#     source /etc/profile.d/modules.sh &&\    
#     module load EasyBuild && \   
#     rm -rf /fuyun/software/.locks/* &&\
#     eb   -lr --use-existing-modules --minimal-toolchain --skip-test-cases\
#     --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
#     --moduleclasses=fuyun  \
#     FyLab-${FYLAB_VERSION}.eb  

COPY --from=stage0 /fuyun /fuyun



# RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache/,sharing=shared \         
#     sudo mkdir -p ${FUYUN_DIR} && \
#     sudo chown ${FYDEV_USER}:${FYDEV_USER} ${FUYUN_DIR} &&\
#     cp -r /tmp/cache/software ${FUYUN_DIR}}/software && \
#     cp -r /tmp/cache/ebfiles_repo ${FUYUN_DIR}/ebfiles_repo && \
#     cp -r /tmp/cache/modules ${FUYUN_DIR}/modules

# LABEL Name          "fyLab"
# LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
# LABEL Description   "FyLab : UI/UX for FuYun "
# ARG BUILD_TAG=${BUILD_TAG:-dirty}
# LABEL BUILD_TAG     ${BUILD_TAG}
# USER ${FYDEV_USER}
# WORKDIR /home/${FYDEV_USER}
