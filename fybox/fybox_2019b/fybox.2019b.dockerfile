# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=2019b

FROM fytoolchain:${BASE_VERSION}

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG FY_EB_VERSION=4.0.1
ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}

ARG EB_ARGS=" --use-existing-modules --info -l -r"

WORKDIR /home/${FYDEV_USER}

#-------------------------------------------------------------------------------
# libs:data

RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=Doxygen           --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=HDF5             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\
    eb --software-name=MDSplus          --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  



RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=netCDF           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
    eb --software-name=netCDF-Fortran   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\
    eb --software-name=netCDF-C++4      --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  


RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
    --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=netcdf4-python   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  




# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=PostgreSQL       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}   &&\
#     eb --software-name=libMemcached     --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  

# #-------------------------------------------------------------------------------
# # libs:dev
# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=Boost            --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=Blitz++          --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}   



    


# eb --software-name=SWIG                 --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS}
#-------------------------------------------------------------------------------
# libs :  dev 
# RUN --mount=type=cache,uid=1000,id=fy_eb_sources,target=/packages/sources,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=libxml2              --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
#     eb --softwa   re-name=libxslt              --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


RUN sudo yum install -y libXt libXext
