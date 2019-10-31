# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=201910

FROM fybase:${BASE_VERSION}

ARG PKG_DIR=${PKG_DIR:-/packages}



ARG EB_ARGS=" --use-existing-modules -l -r "

#-------------------------------------------------------------------------------
# GCCcore 
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 

RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  

#-------------------------------------------------------------------------------
# gompi :  compiler + MPI 
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}        ${_EB_ARGS} 

#-------------------------------------------------------------------------------
# Python : 
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}

RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Python,${PYTHON_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${_EB_ARGS}  &&\    
    eb --software-name=SWIG                 --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${_EB_ARGS} 

# -------------------------------------------------------------------------------
# Perl : 
ARG PERL_VERSION=${PERL_VERSION:-5.30.0}

RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Perl,${PERL_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${_EB_ARGS}  

#-------------------------------------------------------------------------------
# libs: java-dep   

ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}



LABEL Description   "Toolchain ${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION} gcccore:${GCCCORE_VERSION}"
LABEL Name          "fybox"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "toolchain only include compiler and MPI, i.e gompi,iompi,pompi,gimpi. BLACS,FFWW ScaLAPACK are not included. "

ENV TOOLCHAIN_NAME=${TOOLCHAIN_NAME}
ENV TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION}
ENV PKG_DIR=${PKG_DIR}

ENV JAVA_VERSION=${JAVA_VERSION}
ENV GCCCORE_VERSION=${GCCCORE_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}
ENV PERL_VERSION=${PERL_VERSION}
