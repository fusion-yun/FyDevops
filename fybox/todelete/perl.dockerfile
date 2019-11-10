
# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=fybase:201910

FROM ${BASE_VERSION}

ARG PKG_DIR=${PKG_DIR:-/packages}

# -------------------------------------------------------------------------------
# Perl : 
ARG PERL_VERSION=${PERL_VERSION:-5.30.0}
ENV PERL_VERSION=${PERL_VERSION}
RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Perl,${PERL_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${_EB_ARGS}  
