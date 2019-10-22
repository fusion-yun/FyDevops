ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

ARG PYTHON_VERSION=3.6.6
ARG GCC_VERSION=7.3.0

FROM fybox:${TOOLCHAIN_VERSION}

LABEL Description   "For packages that easyBuild can not install."

ARG EB_ARGS="  --use-existing-modules  -r"

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb ${TOOLCHAIN}.eb ${EB_ARGS}  

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software=Python,${PYTHON_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=Perl --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}   &&\
    eb --software-name=OpenSSL --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libgcrypt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxml2 --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxslt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb SWIG-3.0.12-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}  &&\
    eb Boost-1.68.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}  

###############################################
# Python modules
RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=PostgreSQL --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} &&\
    eb --software-name=HDF5 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${EB_ARGS} &&\
    eb --software-name=netCDF --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-Fortran --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-C++4 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netcdf4-python --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  

###############################################
# Java 
    # eb h5py-2.8.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}    
ARG JAVA_VERSION=1.8
RUN --mount=type=bind,target=ebfilse  --mount=type=bind,target=sources \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\   
    eb java/Java-1.8.0_231.eb ${EB_ARGS} &&\  
    eb java/Java-1.8.eb ${EB_ARGS} &&\  
    eb java/Saxon-HE-9.9.1.5-Java-1.8.0_231.eb  ${EB_ARGS}


RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb ext_libs ${EB_ARGS}     


RUN source /etc/profile.d/lmod.bash  && module load Python  &&\   
    pip install --upgrade pip &&\
    pip install pytest pylint &&\   
    pip install jupyterhub jupyterlab jupyter bokeh matplotlib dask ipyparallel  networkx   