
ARG PYTHON_VERSION=3.6.6
ARG JAVA_VERSION=1.8.0_92
ARG GCC_VERSION=7.3.0

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

ARG EB_ARGS=" --use-existing-modules -rl"

ARG PKG_LABEL=fy2018b:latest

FROM ${PKG_LABEL}




COPY ebfiles/* ./

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb libMemcached-1.0.18-GCCcore-${GCC_VERSION}.eb ${EB_ARGS}   &&\
    eb Blitz++-0.10-GCCcore-${GCC_VERSION}.eb ${EB_ARGS} &&\
    eb MDSplus-7.46.1-${TOOLCHAIN}.eb ${EB_ARGS}   

    # eb --software=Java,${JAVA_VERSION} ${EB_ARGS} &&\
    # eb ant-1.10.6-Java-${JAVA_VERSION}.eb  ${EB_ARGS}   &&\
# RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     eb --software=binutils,2.28 --try-toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS} &&\
#     eb --software-name=libMemcached --try-toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS} &&\
#     eb --software-name=Blitz++ --try-toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
