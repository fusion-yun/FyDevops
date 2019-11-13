# syntax=docker/dockerfile:experimental
FROM fybox:latest

LABEL Description   "IMAS (${IMAS_VERSION}) + UDA(${UDA_VERSION})"
LABEL Name          "IMAS"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "IMAS + UDA"



ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

ARG UDA_VERSION=2.2.6
ARG IMAS_VERSION=3.24.0_4.2.0

ARG PKG_DIR=${PKG_DIR}
ARG FY_EB_VERSION=${FY_EB_VERSION}

ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/packages,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=Python       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libxml2      --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libMemcached --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=MDSplus      --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=PostgreSQL   --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} &&\
    eb --software-name=SWIG         --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} &&\
    eb --software-name=HDF5         --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=netCDF       --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=Boost        --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} 

ARG FYDEV_USER=${FYDEV_USER:-fydev}
WORKDIR /home/${FYDEV_USER}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/packages,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    --mount=type=bind,target=/tmp/sources,source=sources \
    --mount=type=ssh \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:/tmp/sources --use-existing-modules  -l --info  -r "  &&\
    eb --software-name=UDA --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/packages,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    --mount=type=bind,target=/tmp/sources,source=sources \
    --mount=type=ssh \
    source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:/tmp/sources --use-existing-modules  -l --info  -r "  &&\
    eb --software-name=IMAS --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS} 


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/packages/cache,sharing=shared \
    cp -rf /packages/cache/software/UDA             ${PKG_DIR}/                 &&\
    cp -rf /packages/cache/modules/all/UDA          ${PKG_DIR}/modules/all/     &&\
    cp -rf /packages/cache/modules/data/UDA         ${PKG_DIR}/modules/data/    &&\
    cp -rf /packages/cache/ebfiles_repo/UDA         ${PKG_DIR}/                 &&\
    cp -rf /packages/cache/software/IMAS            ${PKG_DIR}/                 &&\
    cp -rf /packages/cache/modules/all/IMAS         ${PKG_DIR}/modules/all/     &&\
    cp -rf /packages/cache/modules/data/IMAS        ${PKG_DIR}/modules/data/    &&\
    cp -rf /packages/cache/ebfiles_repo/IMAS        ${PKG_DIR}/ 

# RUN source /etc/profile.d/lmod.bash  && module load Python &&\
#     pip install future matplotlib
####
# build command:
# docker build --progress=plain --ssh=default --rm -f "dockerfiles/imas.dockerfile" -t imas:3_24_0_ual_4_2_0 .
