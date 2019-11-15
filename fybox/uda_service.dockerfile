from imas:latest as DEV

RUN --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    --mount=type=bind,target=/tmp/sources,source=sources \
    --mount=type=ssh \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \    
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:/tmp/sources --use-existing-modules  -l --info  -r "  &&\
    eb --software-name=UDA --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}
