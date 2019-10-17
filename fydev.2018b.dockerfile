ARG PKG_LABEL=fuyun_pkgs:latest

FROM ${PKG_LABEL}

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb foss-2018b.eb  -rl

# # RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
# #     eb netcdf4-python-1.4.3-foss-2018b-Python-3.6.6.eb   netCDF-Fortran-4.4.4-foss-2018b.eb    netCDF-C++4-4.3.0-foss-2018b.eb  netCDF-4.6.1-foss-2018b.eb   -lr

ARG EB_ARGS="  --use-existing-modules  -r"

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

ARG PYTHON_VERSION=3.6.6
ARG GCC_VERSION=7.3.0


RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb ${TOOLCHAIN}.eb ${EB_ARGS}  &&\
    eb --software=Python,${PYTHON_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=HDF5 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${EB_ARGS} &&\
    eb --software-name=netCDF --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-Fortran --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-C++4 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netcdf4-python --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}   &&\
    eb --software-name=libxml2 --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=PostgreSQL --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} 


RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\   
    eb Boost-1.68.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS} &&\   
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}  



# WORKDIR /home/${FYDEV_USER}
# USER ${FYDEV_USER}
# RUN mkdir -p ebfiles
COPY ./ebfiles ./ebfiles

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb ./ebfiles ${EB_ARGS}  &&\  
    rm -rf ebfiles




###############################################
# Java 
# ARG JAVA_VERSION=1.8
# COPY ./java_deps ./java_deps

# RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\   
#     eb ./java_deps ${EB_ARGS}  &&\
#     rm -rf java_deps
