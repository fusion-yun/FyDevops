# syntax=docker/dockerfile:experimental
ARG BASE_OS=centos7

FROM fyos:${BASE_OS}  

ARG BASE_OS=${BASE_OS:-centos7}
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}

ARG PKG_DIR=${PKG_DIR:-/packages}
ENV PKG_DIR=${PKG_DIR}

################################################################################

# RUN sudo mkdir -p ${PKG_DIR} &&\
#     sudo mkdir -p ${PKG_DIR}/build &&\
#     sudo chown -R ${FYDEV_USER}:${FYDEV_USER} ${PKG_DIR} 

USER   ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
SHELL ["/bin/bash","-c"]
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    sudo mkdir -p /eb_repos/${BASE_OS} &&\
    sudo chown ${FYDEV_USER}:${FYDEV_USER} /eb_repos/${BASE_OS} &&\
    sudo ln -sf /eb_repos/${BASE_OS} ${PKG_DIR}  &&\
    sudo ln -sf /eb_repos/sources    ${PKG_DIR}/sources  
################################################################################
# Bootstrap


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    mkdir -p  ${PKG_DIR}/sources/bootstrap    

# Install Lua
ARG FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.3}
ARG FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
ARG FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.2.1}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.2.3}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    if ! [ -d ${PKG_DIR}/software/lua/${FY_LUA_VERSION} ]; then  \    
    if ! [ -f ${PKG_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then  \
    curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${PKG_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz  ; \
    curl -L https://github.com/luarocks/luarocks/archive/v${FY_LUAROCKS_VERSION}.tar.gz -o ${PKG_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ; \
    fi ; \    
    export TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX); \
    mkdir -p ${TMP_BUILD}/lua ;\
    tar xzf ${PKG_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1 ; \
    cd ${TMP_BUILD}/lua ;\
    make INSTALL_TOP=${PKG_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux all; \ 
    make INSTALL_TOP=${PKG_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux test; \ 
    make INSTALL_TOP=${PKG_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux install; \ 
    cd .. ;\
    mkdir -p ${TMP_BUILD}/luarocks ;\
    tar xzf ${PKG_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1 ; \
    cd ${TMP_BUILD}/luarocks ;\
    ./configure --prefix=${PKG_DIR}/software/lua/${FY_LUA_VERSION} --with-lua=${PKG_DIR}/software/lua/${FY_LUA_VERSION} ; \
    make ;\
    make install ;\
    cd ../..;\
    rm -rf ${TMP_BUILD} ; \   
    fi  &&\
    ${PKG_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luaposix ;\
    ${PKG_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem 

ENV LUA_ROOT=${PKG_DIR}/software/lua/${FY_LUA_VERSION}
ENV LUAROCKS_PREFIX=${LUA_ROOT}
ENV LUA_PATH="${LUA_ROOT}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_ROOT}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
ENV LUA_CPATH="${LUA_ROOT}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
ENV PATH=${LUA_ROOT}/bin:${PATH}

# Install lmod
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    if ! [ -d ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION} ]; then  \
    if ! [ -f ${PKG_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  \
    curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${PKG_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  ; \
    fi ; \    
    export TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX); \
    tar xzf ${PKG_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 ; \
    cd ${TMP_BUILD};\
    echo ${LUA_PATH} &&\
    echo ${LUA_CPATH} &&\
    ./configure --prefix=${PKG_DIR}/software  --with-lua_include=${LUA_ROOT}/include; make install ; \ 
    cd .. ;\
    rm -rf ${TMP_BUILD} ; \
    fi   && \
    sudo ln -sf ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile        /etc/profile.d/00_lmod.sh && \
    sudo ln -sf ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/cshrc          /etc/profile.d/00_lmod.csh 

# Install EasyBuild
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.0.1}
SHELL ["/bin/bash","-c"]
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    if ! [ -d ${PKG_DIR}/software/EasyBuild/${FY_EB_VERSION} ]; then  \
    if ! [ -f ${PKG_DIR}/sources/bootstrap/bootstrap_eb.py ]; then  \
    curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py ;\
    curl -LO https://files.pythonhosted.org/packages/48/aa/f05d350c358338d0e843835660e3993cc5eb28401f32c0c5b8bc9a9458d5/vsc-base-2.8.4.tar.gz  ; \
    curl -LO https://files.pythonhosted.org/packages/18/59/3274a58af6af84a87f7655735b452c06c769586ee73954f5ee15d303aa29/vsc-install-0.11.3.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz ; \
    fi ; \  
    source /etc/profile.d/00_lmod.sh ;\
    export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES  ; \
    export EASYBUILD_BOOTSTRAP_SOURCEPATH=${PKG_DIR}/sources/bootstrap/  ; \
    export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}  ; \
    python ${PKG_DIR}/sources/bootstrap/bootstrap_eb.py ${PKG_DIR} ;\
    fi  


ENV EASYBUILD_PREFIX=${PKG_DIR}
ENV MODULEPATH="${PKG_DIR}/modules/all${MODULEPATH}"

ARG EB_ARGS=${EB_ARGS:-" --use-existing-modules --info -l -r"}

#-------------------------------------------------------------------------------
# GCCcore 
ARG GCCCORE_VERSION=${GCCCORE_VERSION:-8.3.0} 
ENV GCCCORE_VERSION=${GCCCORE_VERSION} 

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS}

#-------------------------------------------------------------------------------
# gompi :  compiler + MPI 

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-gompi}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}

ENV TOOLCHAIN_NAME=${TOOLCHAIN_NAME}
ENV TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION}


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}   ${EB_ARGS} 

#-------------------------------------------------------------------------------
# Python : 

ARG PYTHON_VERSION=${PYTHON_VERSION:-3.7.4}
ENV PYTHON_VERSION=${PYTHON_VERSION}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb --software=Python,${PYTHON_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}   

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     --mount=type=bind,target=ebfiles,source=ebfiles \
#     source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
#     eb --software-name=SWIG    --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${EB_ARGS}


# # -------------------------------------------------------------------------------
# # Perl : 
# ARG PERL_VERSION=${PERL_VERSION:-5.30.0}
# ENV PERL_VERSION=${PERL_VERSION}

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
#     source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
#     eb --software=Perl,${PERL_VERSION}  --toolchain=GCCcore,${GCCCORE_VERSION} ${EB_ARGS}  

#-------------------------------------------------------------------------------
# Java 

ARG JAVA_VERSION=${JAVA_VERSION:-13.0.1}
ENV JAVA_VERSION=${JAVA_VERSION}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  &&\
    eb --software-name=ant --amend=versionsuffix=-Java-${JAVA_VERSION} ${_EB_ARGS}  &&\
    eb --software-name=SaxonHE --amend=versionsuffix=-Java-${JAVA_VERSION}  ${_EB_ARGS} 



RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \
    eb --software-name=pkg-config   --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\
    eb --software-name=CMake        --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS} &&\        
    eb --software-name=Doxygen      --toolchain=GCCcore,${GCCCORE_VERSION}  ${EB_ARGS}  

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} && \    
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb /tmp/ebfiles/Ninja-1.9.0-GCCcore-8.3.0-withfortran.eb ${_EB_ARGS} 



#-------------------------------------------------------------------------------
# libs:data
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=HDF5             --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  &&\
    eb --software-name=MDSplus          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=HDF5             --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=PostgreSQL       --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}   &&\
    eb --software-name=libMemcached     --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  




RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=netCDF           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\ 
    eb --software-name=netCDF-Fortran   --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  &&\
    eb --software-name=netCDF-C++4      --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS}  


#-------------------------------------------------------------------------------
# libs:build tools
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=Boost            --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} && \
    eb --software-name=Blitz++          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} && \
    eb --software-name=libxslt          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS} && \
    eb --software-name=libxml2          --toolchain=GCCcore,${GCCCORE_VERSION}  ${_EB_ARGS}  


#-------------------------------------------------------------------------------
# libs:math libs
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=OpenBLAS            --toolchain=GCC,${GCCCORE_VERSION}  ${_EB_ARGS} && \
    eb --software-name=ScaLAPACK           --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} && \
    eb --software-name=FFTW                --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION}  ${_EB_ARGS} 

#-------------------------------------------------------------------------------
# libs:python libs

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software-name=SWIG            --toolchain=GCCcore,${GCCCORE_VERSION} --amend=versionsuffix=-Python-${PYTHON_VERSION}  ${_EB_ARGS} 

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    source ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile  && module load EasyBuild/${FY_EB_VERSION} &&\
    export _EB_ARGS=" --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  ${EB_ARGS}"  &&\
    eb --software=foss,${TOOLCHAIN_VERSION}  ${EB_ARGS}

# -------------------------------------------------------------------------------

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
    sudo rm  ${PKG_DIR} &&\
    sudo mkdir  ${PKG_DIR} &&\
    sudo chown -R ${FYDEV_USER}:${FYDEV_USER} ${PKG_DIR} &&\
    cp -rf /eb_repos/${BASE_OS}/software           ${PKG_DIR}/ &&\
    cp -rf /eb_repos/${BASE_OS}/modules            ${PKG_DIR}/ &&\ 
    cp -rf /eb_repos/${BASE_OS}/ebfiles_repo       ${PKG_DIR}/ 

# &&\
# sudo ln -sf ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions   && \
# sudo ln -sf ${PKG_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile.fish   /etc/fish/conf.d/z00_lmod.fish && \


LABEL Description   "fyBox: lmod ${FY_LMOD_VERSION} + EasyBuild ${FY_EB_VERSION}, PKG_DIR=${PKG_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "
LABEL Name          "fyBox"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "Create module envirnments "

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}
