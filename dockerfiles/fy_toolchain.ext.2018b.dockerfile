###############################################
# for software not in EasyBuild release
#
ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}
ARG OS_LABEL=centos7

FROM fy_toolchain:${TOOLCHAIN_NAME}_${TOOLCHAIN_VERSION}_${OS_LABEL}


USER ${FYDEV_USER}
COPY ./ebfiles/*.eb ./
COPY ./install_source/* ./

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb Boost-1.68.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}  &&\
    eb Blitz++-1.0.2-GCCcore-${GCC_VERSION}.eb ${EB_ARGS}    &&\   
    eb libMemcached-1.0.18-GCCcore-${GCC_VERSION}.eb ${EB_ARGS}   

###############################################
# Java 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\   
    eb Java-1.8.0_231.eb ${EB_ARGS} &&\  
    eb Java-1.8.eb ${EB_ARGS} &&\  
    eb Saxon-HE-9.9.1.5-Java-${JAVA_VERSION}.eb


RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb MDSplus-7.84.8-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb ${EB_ARGS}

RUN rm -rf *