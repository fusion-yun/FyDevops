# syntax=docker/dockerfile:experimental

ARG BASE_OS=${BASE_OS:-centos7}
FROM fybootstrap:${BASE_OS}


# Java 
ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
ARG PKG_DIR=${PKG_DIR:-/packages}
ARG EASYBUILD_PREFIX=${EASYBUILD_PREFIX:-${PKG_DIR}}
ARG EB_ARGS=" --use-existing-modules --info -l -r"


RUN --mount=type=bind,target=sources,source=toolchain_system/sources  --mount=type=bind,target=ebfiles,source=toolchain_system/ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} 


ENV JAVA_VERSION=${JAVA_VERSION}