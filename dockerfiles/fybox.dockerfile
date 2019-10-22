# syntax=docker/dockerfile:experimental

ARG BASE_OS=centos7

FROM fy_os:${BASE_OS}


ARG PKG_DIR=/packages

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}
ARG LMOD_VERSION=8.1.18
ARG EB_VERSION=4.0.1
ARG PYTHON_VERSION=3.6.6
ARG GCC_VERSION=7.3.0
ARG EB_ARGS="  --use-existing-modules  -r"

LABEL Description   "Toolchain foss-${TOOLCHAIN_VERSION}"
LABEL Name          "fybox"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "Create envirnments and install packages "




################################################################################
# Add user for DevOps
# Add user for DevOps
# RUN groupadd -f ${FYDEV_GROUP} -g ${FYDEV_GROUP_ID}
ARG FYDEV_USER=fydev 
ARG FYDEV_USER_ID=1000
ENV FYDEV_USER=${FYDEV_USER}

RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER}  && \
    usermod -a -G wheel  ${FYDEV_USER} && \
    mkdir -m755 -p ${PKG_DIR}  && \
    chown  ${FYDEV_USER}.${FYDEV_GROUP}  -R ${PKG_DIR}   && \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

################################################################################
# Install lmod+easybuild
USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}/

# Install lmod
RUN --mount=type=bind,target=install_sources,source=install_sources \
    mkdir lmod_build && cd lmod_build &&\
    tar xzf ../install_sources/lmod-${LMOD_VERSION}.tar.gz  --strip-components=1 && \
    ./configure --prefix=${PKG_DIR}/software/lmod/${LMOD_VERSION}/ && \
    make install && \  
    cd .. && rm -rf lmod_build && \
    sudo ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/profile     /etc/profile.d/lmod.sh && \
    sudo ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/bash        /etc/profile.d/lmod.bash && \
    sudo ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/zsh         /etc/profile.d/lmod.zsh && \
    sudo ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/csh         /etc/profile.d/lmod.csh && \
    sudo ln -s ${PKG_DIR}/software/lmod/${LMOD_VERSION}/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions && \
    source /etc/profile.d/lmod.sh && \
    pip install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${EB_VERSION}" install_sources/easybuild-framework-v${EB_VERSION}.tar.gz && \
    pip install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${EB_VERSION}" install_sources/easybuild-easyconfigs-v${EB_VERSION}.tar.gz && \
    pip install --install-option "--prefix=${PKG_DIR}/software/EasyBuild/${EB_VERSION}" install_sources/easybuild-easyblocks-v${EB_VERSION}.tar.gz && \
    mkdir -p ${PKG_DIR}/modules/all/EasyBuild/ && \
    export PY_SHORTVER=`python -c "import sys;print(str(sys.version_info.major)+'.'+str(sys.version_info.minor))"` && \
    echo -e \
    \
"   \n\
help([==[   \n\
\n\
Description   \n\
===========   \n\
EasyBuild is a software build and installation framework   \n\
written in Python that allows you to install software in a structured,   \n\
repeatable and robust way.   \n\
\n\
\n\
More information   \n\
================   \n\
- Homepage: http://easybuilders.github.com/easybuild/   \n\
]==])   \n\
\n\
whatis([==[Description: EasyBuild is a software build and installation framework   \n\
written in Python that allows you to install software in a structured,   \n\
repeatable and robust way.]==])   \n\
whatis([==[Homepage: http://easybuilders.github.com/easybuild/]==])   \n\
\n\
local root = \"${PKG_DIR}/software/EasyBuild/${EB_VERSION}\"   \n\
\n\
conflict(\"EasyBuild\")   \n\
\n\
prepend_path(\"PATH\", pathJoin(root, \"bin\"))   \n\
setenv(\"EASYBUILD_PREFIX\", \"${PKG_DIR}\")   \n\    
setenv(\"EBROOTEASYBUILD\", root)   \n\
setenv(\"EBVERSIONEASYBUILD\", \"${EB_VERSION}\")   \n\
setenv(\"EBDEVELEASYBUILD\", pathJoin(root, \"easybuild/EasyBuild-${EB_VERSION}-easybuild-devel\"))   \n\
\n\
prepend_path(\"PYTHONPATH\", pathJoin(root, \"lib/python${PY_SHORTVER}/site-packages\"))   \n\
-- Built with EasyBuild version ${EB_VERSION}   \n\
\n\
" > ${PKG_DIR}/modules/all/EasyBuild/${EB_VERSION}.lua

ENV  MODULEPATH="${PKG_DIR}/modules/all${MODULEPATH}"

################################################################################
# INSTALL packages

RUN source /etc/profile.d/lmod.sh  && module load EasyBuild/${EB_VERSION} && eb --show-config >> eb_confg.log

RUN source /etc/profile.d/lmod.sh  && module load EasyBuild/${EB_VERSION}   &&\
    eb ${TOOLCHAIN}.eb ${EB_ARGS}  
 
RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EB_VERSION} &&\
    eb --software=Python,${PYTHON_VERSION} --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=Boost --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --try-amend=versionsuffix=-Python-${PYTHON_VERSION} ${EB_ARGS} &&\
    eb --software-name=SWIG --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --try-amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS} &&\
    eb --software-name=PostgreSQL --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS} &&\
    eb --software-name=HDF5 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  --hide-deps=Szip  ${EB_ARGS} &&\
    eb --software-name=netCDF --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-Fortran --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netCDF-C++4 --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} ${EB_ARGS}  &&\
    eb --software-name=netcdf4-python --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} --try-amend=versionsuffix=-Python-${PYTHON_VERSION} ${EB_ARGS}  

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EB_VERSION} &&\
    eb --software-name=CMake --toolchain=GCCcore,${GCC_VERSION}  ${EB_ARGS}   &&\
    eb --software-name=Perl --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=OpenSSL --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libgcrypt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxml2 --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS} &&\
    eb --software-name=libxslt --toolchain=GCCcore,${GCC_VERSION} ${EB_ARGS}  

# ###############################################
# # Java 
# # RUN eb h5py-2.8.0-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}-Python-${PYTHON_VERSION}.eb ${EB_ARGS}    
# ARG JAVA_VERSION=1.8
# RUN --mount=type=bind,target=install_sources,source=install_sources \
#     --mount=type=bind,target=ebfilse  --mount=type=bind,target=sources \
#     source /etc/profile.d/lmod.bash  && module load EasyBuild &&\   
#     eb java/Java-1.8.0_231.eb ${EB_ARGS} &&\  
#     eb java/Java-1.8.eb ${EB_ARGS} &&\  
#     eb java/Saxon-HE-9.9.1.5-Java-1.8.0_231.eb  ${EB_ARGS}


# RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EB_VERSION} &&\   
#     eb ext_libs ${EB_ARGS}     


# RUN source /etc/profile.d/lmod.bash  && module load Python  &&\   
#     pip install --upgrade pip &&\
#     pip install pytest pylint &&\   
#     pip install jupyterhub jupyterlab jupyter bokeh matplotlib dask ipyparallel  networkx   