# syntax=docker/dockerfile:experimental
ARG BASE_TAG=${BASE_TAG:-fabse:latest}
FROM ${BASE_TAG}

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

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ENV PYPI_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

RUN sudo mkdir -p ${FUYUN_DIR} &&\
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR}   

ENV EASYBUILD_PREFIX=${FUYUN_DIR}

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r  --skip-test-cases \
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    GCCcore-8.3.0.eb 

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r  --skip-test-cases \
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    Tcl-8.6.9-GCCcore-8.3.0.eb     

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r  --skip-test-cases \
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    Python-3.7.4-GCCcore-8.3.0.eb 

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r   --skip-test-cases\
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    Perl-5.30.0-GCCcore-8.3.0.eb  \   
    PCRE-8.43-GCCcore-8.3.0.eb  



RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r   --skip-test-cases\
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    gompi-2019b.eb 

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r   --skip-test-cases\
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    Boost-1.71.0-gompi-2019b.eb 



RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r   --skip-test-cases\
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    ${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb 

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
    module avail && \
    module load EasyBuild/${FY_EB_VERSION} && \
    eb --info -r   --skip-test-cases\
    --use-existing-modules \
    --minimal-toolchain \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    --moduleclasses=fuyun  \
    FyDev-${FYDEV_VERSION}.eb 

# RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
#     if ! [ -d ${FUYUN_DIR} ] ; then \
#     sudo mkdir -p ${FUYUN_DIR}   && \
#     fi && \
#     sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR} &&\   
#     ########################################
#     cp -r /tmp/cache/ebfiles_repo ${FUYUN_DIR}/ && \
#     cp -r /tmp/cache/modules ${FUYUN_DIR}/ && \
#     cp -r /tmp/cache/software ${FUYUN_DIR}/ && \
#     cp -r /tmp/cache/sources ${FUYUN_DIR}/ 


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
ENV MODULEPATH=${FUYUN_DIR}/modules/vis:${MODULEPATH}



LABEL Name          "FyDev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FyDev : Develop enverioment of FuYun  "
ARG BUILD_TAG=${BUILD_TAG:-dirty}
LABEL BUILD_TAG      ${BUILD_TAG}
USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
# RUN pip config set global.index-url https://mirrors.aliyun.com/simple ; \
#     pip config set install.trusted-host mirrors.aliyun.com 
