# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=latest

FROM fybox_base:${BASE_VERSION}

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

LABEL Description   "Toolchain ${TOOLCHAIN}"
LABEL Name          "fybox_toolchain"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "toolchain and packages "

################################################################################
# INSTALL packages

ENV FY_EB_VERSION=4.0.1
ENV PKG_DIR=/packages

ARG GCC_VERSION=7.3.0 

ARG EB_ARGS=" --use-existing-modules --info -l -r"

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb ${TOOLCHAIN}.eb ${EB_ARGS}  

ARG PYTHON_VERSION=3.6.6

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=Python,${PYTHON_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\    
    eb --software-name=SWIG --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --try-amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS} 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software-name=OpenSSL --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libgcrypt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxml2 --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxslt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS}   &&\
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}    

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software-name=Boost --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --try-amend=versionsuffix=-Python-${PYTHON_VERSION} ${EB_ARGS} 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software-name=PostgreSQL --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} &&\
    eb --software-name=HDF5 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${EB_ARGS} &&\
    eb --software-name=netCDF --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-Fortran --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-C++4 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}    &&\
    eb --software-name=netcdf4-python --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --try-amend=versionsuffix=-Python-${PYTHON_VERSION} ${EB_ARGS}   


###########################################
# Unoffical packages
#
# Java 
ARG JAVA_VERSION=13.0.1

RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources --use-existing-modules  -r"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libMemcached --toolchain=GCCcore,${GCC_VERSION}  ${_EB_ARGS}  &&\
    eb --software-name=Blitz++ --toolchain=GCCcore,${GCC_VERSION}  ${_EB_ARGS}   &&\
    eb --software-name=Ninja --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}    ${_EB_ARGS}  &&\
    eb --software-name=MDSplus --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --try-amend=versionsuffix=-Java-${JAVA_VERSION}   ${_EB_ARGS}  





 