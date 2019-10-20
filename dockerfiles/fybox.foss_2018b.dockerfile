ARG PKG_LABEL=fy_pkgenv:centos7

FROM ${PKG_LABEL}

LABEL Description   "Toolchain foss-2018b"


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
    eb --software-name=netcdf4-python --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=PostgreSQL --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb SWIG-3.0.12-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}  &&\
    eb Boost-1.68.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}  

########################################
# GCCcore
RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=libxml2 --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxslt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}  

##############################
# RUN sudo yum install -y openssl
###############################

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb --software-name=OpenSSL --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libgcrypt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} 


###############################################
# Java 
RUN cd java && source /etc/profile.d/lmod.bash  && module load EasyBuild &&\   
    eb ebfiles/java_toolchain/Java-1.8.0_231.eb ${EB_ARGS} &&\  
    eb ebfiles/java_toolchain/Java-1.8.eb ${EB_ARGS} &&\  
    eb ebfiles/java_toolchain/Saxon-HE-9.9.1.5-Java-${JAVA_VERSION}.eb &&\
    cd ..

###############################################
# Extral libraries 

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb ebfiles/ext_libs ${EB_ARGS}     


###############################################
# Python modules
RUN source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    eb h5py-2.8.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}    

RUN source /etc/profile.d/lmod.bash  && module load Python  &&\   
    pip install --upgrade pip &&\
    pip install pytest pylint &&\   
    pip install jupyterhub jupyterlab jupyter bokeh matplotlib dask ipyparallel  networkx   