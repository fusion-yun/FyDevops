# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=centos7

FROM fysystem:${BASE_VERSION}

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

LABEL Description   "Toolchain ${TOOLCHAIN}"
LABEL Name          "fybox"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "toolchain and packages "

################################################################################
# INSTALL packages

ENV PKG_DIR=${PKG_DIR:-/packages}

ARG EB_ARGS=" --use-existing-modules --info -l -r"

RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb ${TOOLCHAIN}.eb ${_EB_ARGS}  


ARG GCC_VERSION=${GCC_VERSION:-7.3.0}

# RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=OpenSSL --try-toolchain=GCCcore,${GCC_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=libgcrypt --try-toolchain=GCCcore,${GCC_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=libxml2 --try-toolchain=GCCcore,${GCC_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=libxslt --try-toolchain=GCCcore,${GCC_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=CMake --try-toolchain=GCCcore,${GCC_VERSION}  ${_EB_ARGS}    


# ARG PYTHON_VERSION=${PYTHON_VERSION:-3.6.6}

# RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software=Python,${PYTHON_VERSION} --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\    
#     eb --software-name=SWIG --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${_EB_ARGS} 


# RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=PostgreSQL --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS} &&\
#     eb --software-name=HDF5 --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${_EB_ARGS} &&\
#     eb --software-name=netCDF --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=netCDF-Fortran --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=netCDF-C++4 --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}     

# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=Boost --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=netcdf4-python --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION} ${_EB_ARGS}   


# ###########################################
# # Unoffical packages
# #

# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=libMemcached --try-toolchain=GCCcore,${GCC_VERSION}  ${_EB_ARGS}  &&\
#     eb --software-name=Blitz++ --try-toolchain=GCCcore,${GCC_VERSION}  ${_EB_ARGS}   &&\
#     eb --software-name=Ninja --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}    ${_EB_ARGS}   


# ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}

# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --try-software-name=MDSplus --try-toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --amend=versionsuffix=-Java-${JAVA_VERSION}   ${_EB_ARGS}  



# ############################################
# # Python libs
# RUN source /etc/profile.d/lmod.bash  && module load Python &&\ 
#     pip install future matplotlib  numpy scipy pandas jupyter jupyterlab dask ipyparallel

ENV GCC_VERSION=${GCC_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}
ENV JAVA_VERSION=${JAVA_VERSION}