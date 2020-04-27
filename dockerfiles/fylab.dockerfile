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
####################################################################
# install packages

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}


ENV EASYBUILD_PREFIX=${FUYUN_DIR} 

################################################################################
# For release

RUN --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\    
    module avail ; \
    module load EasyBuild ; \   
    eb   -r  --use-existing-modules --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    JupyterLab-2.1.1-foss-2019b-Python-3.7.4.eb


# RUN --mount=type=bind,target=/tmp/ebfiles,source=./ \
#     source /etc/profile.d/modules.sh ;\    
#     module load EasyBuild ; \   
#     export PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple ;\
#     eb   -r --rebuild  --use-existing-modules --minimal-toolchain \
#     --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
#     --moduleclasses=fuyun \
#     FyLab-${FYLAB_VERSION}.eb  

# eb  --info  --use-existing-modules  --minimal-toolchain --robot-paths=/workspaces/FyDevOps/ebfiles/:$EBROOTEASYBUILD/easybuild/easyconfigs  --moduleclasses=fuyun /workspaces/FyDevOps/ebfiles/FyLab-0.0.0.eb -Dr

LABEL Name          "fyLab"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FuLab : UI/UX of FuYun "

# USER ${FYDEV_USER}
# WORKDIR /home/${FYDEV_USER}
