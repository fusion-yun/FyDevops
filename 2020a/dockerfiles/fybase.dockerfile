# syntax=docker/dockerfile:experimental
ARG OS_TAG=centos_8
FROM fyos:${OS_TAG}  

ARG OS_TAG=${OS_TAG:-centos8}
ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR ${FUYUN_DIR}

################################################################################
# Add user for DevOps
# Add user for DevOps

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}


RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
    usermod -a -G wheel  ${FYDEV_USER} ; \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

USER   ${FYDEV_USER}

################################################################################
# Bootstrap
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \        
    sudo mkdir -p /eb_repos/sources     ; \        
    sudo mkdir -p ${FUYUN_DIR} ; \
    sudo ln -sf /eb_repos/sources   ${FUYUN_DIR}/  ; \    
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R /eb_repos/sources ; \        
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR} ; \        
    ls -lh ${FUYUN_DIR}

ARG CONDA_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/anaconda
ARG CONDA_DIR=${FUYUN_DIR}/software/conda
ARG PIP_MIRROR=https://mirrors.aliyun.com/pypi/simple/

RUN  --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \       
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/miniconda3.sh ]; then  \    
    # install conda with China mirror
    mkdir -p  ${FUYUN_DIR}/sources/bootstrap/ ; \
    curl -L ${CONDA_MIRROR}/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ${FUYUN_DIR}/sources/bootstrap/miniconda3.sh  ;\
    fi  ; \    
    /usr/bin/bash ${FUYUN_DIR}/sources/bootstrap/miniconda3.sh  -b -p ${CONDA_DIR} ; \
    ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/main ; \
    ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/free ; \
    ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/r ; \
    ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/pro ; \
    ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/cloud/conda-forge ; \
    ${CONDA_DIR}/bin/conda config --remove channels defaults ; \
    ${CONDA_DIR}/bin/conda config --set show_channel_urls yes ; \
    ${CONDA_DIR}/bin/conda update -n base -c defaults conda  ; \
    ${CONDA_DIR}/bin/conda clean --all ; \
    ##############################################################################
    # add pip mirror
    ${CONDA_DIR}/bin/pip config set global.index-url ${PIP_MIRROR}} ; \
    ${CONDA_DIR}/bin/pip install --upgrade pip ;


ENV PATH=${CONDA_DIR}/bin:${PATH}


# Install Lua
ARG FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.3}
ARG FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
ARG FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.2.1}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.3.8}


RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared  \              
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then  \
    curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz  ; \
    curl -L https://github.com/luarocks/luarocks/archive/v${FY_LUAROCKS_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ; \
    fi ; \        
    export TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX); \
    mkdir -p ${TMP_BUILD}/lua ;\
    tar xzf ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1 ; \
    cd ${TMP_BUILD}/lua ;\
    make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux all; \ 
    make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux test; \ 
    make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux install; \ 
    cd .. ;\
    mkdir -p ${TMP_BUILD}/luarocks ;\
    tar xzf ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1 ; \
    cd ${TMP_BUILD}/luarocks ;\
    ./configure --prefix=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} --with-lua=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ; \
    make ; \
    make install ;\
    cd ../.. ; \
    rm -rf ${TMP_BUILD} ; \       
    ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luaposix ; \
    ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem 

ENV LUA_DIR=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
ENV LUA_ROOT=${LUA_DIR}
ENV LUAROCKS_PREFIX=${LUA_DIR}
ENV LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
ENV LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
ENV PATH=${LUA_DIR}/bin:${PATH}

# Install lmod
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \        
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  \
    curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  ; \
    fi ; \    
    export TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX); \
    tar xzf ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 ; \
    cd ${TMP_BUILD};\
    ./configure --prefix=${FUYUN_DIR}/software  --with-lua_include=${LUA_DIR}/include; make install ; \ 
    cd .. ;\
    rm -rf ${TMP_BUILD} ; \    
    sudo ln -sf ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile        /etc/profile.d/00_lmod.sh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/cshrc          /etc/profile.d/00_lmod.csh 

# Install EasyBuild
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \    
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/bootstrap_eb.py ]; then  \
    mkdir -p ${FUYUN_DIR}/sources/bootstrap/ ; \
    cd ${FUYUN_DIR}/sources/bootstrap/ ; \
    curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py ;\
    # curl -LO https://files.pythonhosted.org/packages/48/aa/f05d350c358338d0e843835660e3993cc5eb28401f32c0c5b8bc9a9458d5/vsc-base-2.8.4.tar.gz  ; \
    # curl -LO https://files.pythonhosted.org/packages/18/59/3274a58af6af84a87f7655735b452c06c769586ee73954f5ee15d303aa29/vsc-install-0.11.3.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz ; \
    fi ; \  
    source /etc/profile.d/00_lmod.sh ;\
    export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES  ; \
    export EASYBUILD_BOOTSTRAP_SOURCEPATH=${FUYUN_DIR}/sources/bootstrap/  ; \
    export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}  ; \
    ${CONDA_DIR}/bin/python ${FUYUN_DIR}/sources/bootstrap/bootstrap_eb.py ${FUYUN_DIR} 



ENV EASYBUILD_PREFIX=${FUYUN_DIR}
ENV MODULEPATH="${FUYUN_DIR}/modules/all:${MODULEPATH}"



LABEL Name          "fyBase"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "fyBase: EasyBuild ${FY_EB_VERSION} lmod ${FY_LMOD_VERSION} + conda , FUYUN_DIR=${FUYUN_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "
WORKDIR /home/${FYDEV_USER}
SHELL ["/bin/bash","-c"]
