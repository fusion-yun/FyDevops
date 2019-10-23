# syntax=docker/dockerfile:experimental
ARG BASE_IMAGE=fybox:2018b

FROM ${BASE_IMAGE}

ENV PKG_DIR=/packages

ARG FY_EB_VERSION=4.0.1

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

################################################################################
# INSTALL packages

ARG EB_ARGS=" --robot-paths=ebfiles:${PKG_DIR}/software/EasyBuild/${FY_EB_VERSION}/easybuild/easyconfigs --sourcepath=${PKG_DIR}/sources/:install_sources --use-existing-modules  -r"

ARG GCC_VERSION=7.3.0

# Java 
ARG JAVA_VERSION=13.0.1

RUN --mount=type=bind,target=install_sources,source=install_sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${EB_ARGS} 

# other 
RUN --mount=type=bind,target=install_sources,source=install_sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=libMemcached --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}  &&\
    eb --software-name=Blitz++ --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}  

RUN --mount=type=bind,target=install_sources,source=install_sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\ 
    eb --software-name=MDSplus --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --try-amend=versionsuffix=-Java-${JAVA_VERSION}   ${EB_ARGS}  

# RUN source /etc/profile.d/lmod.bash  && module load Python  &&\   
#     pip install --upgrade pip &&\
#     pip install pytest pylint &&\   
#     pip install jupyterhub jupyterlab jupyter bokeh matplotlib dask ipyparallel  networkx   