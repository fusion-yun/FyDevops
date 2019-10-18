FROM fy${TOOLCHAIN_VERSION}:latest

ARG EB_ARGS="  --use-existing-modules  -r"

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

ARG PYTHON_VERSION=3.6.6
ARG GCC_VERSION=7.3.0
ARG JAVA_VERSION=1.8


###############################################
# Java 
COPY ./ebfiles/MDSplus-7.84.8-foss-2018b.eb ./

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb MDSplus-7.84.8-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb ${EB_ARGS}