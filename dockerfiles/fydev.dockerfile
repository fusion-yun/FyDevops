# syntax=docker/dockerfile:experimental
ARG BASE_TAG=${BASE_TAG:-fybase:latest}
FROM ${BASE_TAG}

################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}
ENV FY_EB_VERSION=${FY_EB_VERSION}

ARG FYDEV_VERSION=${FYDEV_VERSION:-0.0.0}
ENV FYDEV_VERSION=${FYDEV_VERSION}
ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.0}
ENV FYLAB_VERSION=${FYLAB_VERSION}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ENV PYPI_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/pypi/web/

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

RUN sudo mkdir -p ${FUYUN_DIR}/ebfiles &&\
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR}   

ENV EASYBUILD_PREFIX=${FUYUN_DIR}


COPY --chown=fydev:fydev ./* ${FUYUN_DIR}/ebfiles/

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \        
    ls -lhR ${FUYUN_DIR}/ebfiles

ARG FY_EB_ARGS="--info -r  --skip-test-cases --use-existing-modules --minimal-toolchain \
--robot-paths=${FUYUN_DIR}/ebfiles:/opt/EasyBuild/software/EasyBuild/${FY_EB_VERSION}/easybuild/easyconfigs"

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} GCCcore-8.3.0.eb 

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} Tcl-8.6.9-GCCcore-8.3.0.eb     

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} Python-3.7.4-GCCcore-8.3.0.eb 
    

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} \
    Perl-5.30.0-GCCcore-8.3.0.eb  \   
    PCRE-8.43-GCCcore-8.3.0.eb  


RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} gompi-2019b.eb 


RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb ${FY_EB_ARGS} HDF5-1.10.5-gompi-2019b.eb

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} Boost-1.71.0-gompi-2019b.eb 


RUN --mount=type=cache,uid=1000,gid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS}   ${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb 

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\    
    module load EasyBuild && \   
    eb ${FY_EB_ARGS}   SciPy-bundle-2019.10-foss-2019b-Python-3.7.4.eb


RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/fuyun/sources,sharing=shared \            
    source /etc/profile.d/modules.sh &&\        
    module load EasyBuild/${FY_EB_VERSION} && \
    eb ${FY_EB_ARGS} --moduleclasses=fuyun  FyDev-${FYDEV_VERSION}.eb 
 

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
ENV MODULEPATH=${FUYUN_DIR}/modules/phys:${MODULEPATH}



LABEL Name          "FyDev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FyDev : Develop enverioment of FuYun  "
ARG BUILD_TAG=${BUILD_TAG:-dirty}
LABEL BUILD_TAG      ${BUILD_TAG}
USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
# RUN pip config set global.index-url https://mirrors.aliyun.com/simple ; \
#     pip config set install.trusted-host mirrors.aliyun.com 
