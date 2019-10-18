ARG PKG_LABEL=fuyun_pkgs:latest

FROM ${PKG_LABEL}

ARG EB_ARGS="  --use-existing-modules  -r"

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

ARG PYTHON_VERSION=3.6.6
ARG GCC_VERSION=7.3.0
ARG JAVA_VERSION=1.8


RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb ${TOOLCHAIN}.eb ${EB_ARGS}  

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software=Python,${PYTHON_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=HDF5 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${EB_ARGS} &&\
    eb --software-name=netCDF --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-Fortran --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-C++4 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netcdf4-python --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}   &&\
    eb --software-name=libxml2 --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=PostgreSQL --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}   &&\   
    eb Boost-1.68.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS} 

USER ${FYDEV_USER}
COPY ./ebfiles/*.eb ./
COPY ./install_source/* ./

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
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
