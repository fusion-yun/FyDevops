ARG BASE_VERSION=latest

FROM fytoolchain:${BASE_VERSION}

ARG PKG_DIR=${PKG_DIR:-/packages}
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}


#-------------------------------------------------------------------------------
# libs :  dev 
RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software-name=CMake                --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=Ninja                --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libxml2              --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=libxslt              --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  

#libs: data
RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software-name=PostgreSQL       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}   &&\
    eb --software-name=libMemcached     --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  





#-------------------------------------------------------------------------------
# TOOLCHAIN : Compiler + MPI
ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2018b}

RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS} 


#-------------------------------------------------------------------------------
# libs:data


RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software-name=HDF5             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} &&\
    eb --software-name=MDSplus          --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  

    # eb --software-name=netCDF           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
    # eb --software-name=netCDF-Fortran   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\
    # eb --software-name=netCDF-C++4      --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
    # eb --software-name=netcdf4-python   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\



#-------------------------------------------------------------------------------
# libs: dev
RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software-name=Boost            --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} 
    
    # &&\
    # eb --software-name=Blitz++          --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}   

#-------------------------------------------------------------------------------
# libs: sci
# RUN  --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
#     eb --software-name=OpenBLAS         --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\
#     eb --software-name=ScaLAPACK        --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS} 
# # eb --software-name=FFTW             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${_EB_ARGS}  &&\

#-------------------------------------------------------------------------------
# libs: python-dep
#

# RUN source /etc/profile.d/lmod.bash  && module load Python &&\ 
#     pip install future matplotlib  numpy scipy pandas jupyter jupyterlab dask ipyparallel