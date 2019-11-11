# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=centos7

FROM fysystem:${BASE_VERSION}


# Base binutils,glibc


ENV PKG_DIR=${PKG_DIR:-/packages}


################################################################################
# INSTALL packages

ARG EB_ARGS=" --use-existing-modules --info -l -r"

#-------------------------------------------------------------------------------
# GCCcore 
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-7.3.0} 

RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software-name=CMake            --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=OpenSSL          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libgcrypt        --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libxml2          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libxslt          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  



RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    # eb --software-name=PostgreSQL       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\ 
    eb --software-name=libMemcached     --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\ 
    eb --software-name=MDSplus          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} 
# #-------------------------------------------------------------------------------
# # TOOLCHAIN : Compiler + MPI
# ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
# ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2018b}

# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS} 


# #-------------------------------------------------------------------------------
# # libs:data
# RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=HDF5             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${_EB_ARGS} &&\
#     eb --software-name=netCDF           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=netCDF-Fortran   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=netCDF-C++4      --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\ 
#     eb --software-name=netcdf4-python   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}

# #-------------------------------------------------------------------------------
# # libs: dev
# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=Boost            --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
#     eb --software-name=Blitz++          --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}   

# #-------------------------------------------------------------------------------
# # libs: sci
# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=OpenBLAS         --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=ScaLAPACK        --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS} 
# # eb --software-name=FFTW             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\

# #-------------------------------------------------------------------------------
# # Python : 
# ARG PYTHON_VERSION=${PYTHON_VERSION:-3.6.6}

# RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software=Python,${PYTHON_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${_EB_ARGS}  &&\    
#     eb --software-name=SWIG                 --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${_EB_ARGS} 


# #-------------------------------------------------------------------------------
# # libs: python-dep
# #
# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=Ninja                --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}

# RUN source /etc/profile.d/lmod.bash  && module load Python &&\ 
#     pip install future matplotlib  numpy scipy pandas jupyter jupyterlab dask ipyparallel

#-------------------------------------------------------------------------------
# libs: java-dep   

ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}





LABEL Description   "Toolchain ${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION} gcccore:${GCCCORE_VERSION}"
LABEL Name          "fybox"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "toolchain only include compiler and MPI, i.e gompi,iompi,pompi,gimpi. BLACS,FFWW ScaLAPACK are included in mathlib  "


ENV GCCCORE_VERSION=${GCCCORE_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}
ENV JAVA_VERSION=${JAVA_VERSION}