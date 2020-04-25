# syntax=docker/dockerfile:experimental
ARG IMAGE_TAG=${IMAGE_TAG:-latest}

# For release
# FROM fydev:${IMAGE_TAG}

# For debug
FROM fybase:${IMAGE_TAG}

################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.0}
ENV FYLAB_VERSION=${FYLAB_VERSION}

USER   ${FYDEV_USER}
####################################################################
# install packages

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

################################################################################
# For release
# RUN sudo mkdir -p  ${FUYUN_DIR} ;\
#     sudo chown ${FYDEV_USER}:${FYDEV_USER} ${FUYUN_DIR}
# RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \  
# -------------------------
# For debug
RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun,sharing=shared \  
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\    
    module load EasyBuild ; \   
    export EASYBUILD_PREFIX=${FUYUN_DIR} ;\
    eb --show-config ;\    
    eb --info -lr \
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    --moduleclasses=fuyun \
    /tmp/ebfiles/FyLab-${FYLAB_VERSION}.eb ; \
    module avail  
# eb  --info  --use-existing-modules  --minimal-toolchain --robot-paths=/workspaces/FyDevOps/ebfiles/:$EBROOTEASYBUILD/easybuild/easyconfigs  --moduleclasses=fuyun /workspaces/FyDevOps/ebfiles/FyLab-0.0.0.eb -Dr
ENV MODULEPATH=${FUYUN_DIR}/modules/vis:${MODULEPATH}

LABEL Name          "fyLab"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FuLab : UI/UX of FuYun "

# USER ${FYDEV_USER}
# WORKDIR /home/${FYDEV_USER}
