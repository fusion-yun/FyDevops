#!/bin/bash
FY_ROOT=${FY_ROOT:-/gpfs/fuyun}

###############################################################################

echo "===================== Install Lua ========================="
FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.4}
FY_LUA_VERSION=${FY_LUA_VERSION:-5.4.2}
FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.5.0}
FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.4.19}

mkdir -p ${FY_ROOT}/sources/bootstrap
 
if ! [ -d ${FY_ROOT}/software/lua/${FY_LUA_VERSION} ] ; then         
    if ! [ -f ${FY_ROOT}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then  
        curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${FY_ROOT}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz   
    fi 
    if ! [ -f ${FY_ROOT}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ]; then  
        curl -L https://github.com/luarocks/luarocks/archive/v${FY_LUAROCKS_VERSION}.tar.gz -o ${FY_ROOT}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz 
    fi        
    export TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX)
    mkdir -p ${TMP_BUILD}/lua
    tar xzf ${FY_ROOT}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1 
    cd ${TMP_BUILD}/lua
    make INSTALL_TOP=${FY_ROOT}/software/lua/${FY_LUA_VERSION} PLAT=linux all
    make INSTALL_TOP=${FY_ROOT}/software/lua/${FY_LUA_VERSION} PLAT=linux test
    make INSTALL_TOP=${FY_ROOT}/software/lua/${FY_LUA_VERSION} PLAT=linux install
    cd ..
    mkdir -p ${TMP_BUILD}/luarocks
    tar xzf ${FY_ROOT}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1 
    cd ${TMP_BUILD}/luarocks
    ./configure --prefix=${FY_ROOT}/software/lua/${FY_LUA_VERSION} --with-lua=${FY_ROOT}/software/lua/${FY_LUA_VERSION} 
    make 
    make install
    cd ../../ 
    echo ${TMP_BUILD}
    rm -rf ${TMP_BUILD}     
    ${FY_ROOT}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luaposix 
    ${FY_ROOT}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem 
fi

export LUA_DIR=${FY_ROOT}/software/lua/${FY_LUA_VERSION}
export LUA_ROOT=${LUA_DIR}
export LUAROCKS_PREFIX=${LUA_DIR}
export LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
export LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
export PATH=${LUA_DIR}/bin:${PATH}

echo "============ Install lmod ==================="
if ! [ -d ${FY_ROOT}/software/lmod/${FY_LMOD_VERSION} ]; then     
    if ! [ -f ${FY_ROOT}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  
        curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${FY_ROOT}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  
    fi 
    TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)
    tar xzf ${FY_ROOT}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 
    cd ${TMP_BUILD}
    ./configure --prefix=${FY_ROOT}/software  --with-lua_include=${LUA_DIR}/include; make install 
    cd .. 
    rm -rf ${TMP_BUILD}  
fi
    # sudo ln -sf ${FY_ROOT}/software/lmod/lmod/init/profile        /etc/profile.d/00_lmod.sh ; 
    # sudo ln -sf ${FY_ROOT}/software/lmod/lmod/init/cshrc          /etc/profile.d/00_lmod.csh ; 
    # sudo ln -sf ${FY_ROOT}/software/lmod/lmod/init/zshrc          /etc/profile.d/00_lmod.zsh ; 
    # sudo ln -sf ${FY_ROOT}/software/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  
export LMOD_PATH=${FY_ROOT}/software/lmod/lmod/




# echo "================ EasyBuild ======================="
# export EASYBUILD_PREFIX=${FY_ROOT}
# export PYTHON_EXE=/usr/bin/python
# # export PYTHONPATH=${FY_ROOT}/software/lmod/lmod/init/:${PYTHONPATH}
# export MODULEPATH=${FY_ROOT}/modules/all:${MODULEPATH}
# # export PYTHONPATH=${LMOD_PATH}/init/:${PYTHONPATH}
# echo ${PYTHON_EXE} 
# echo ${PYTHONPATH}
# source ${LMOD_PATH}/init/bash
# FY_EB_VERSION=4.5.3
# FY_EB_PREFIX=${FY_ROOT}

# if ! [ -f ${FY_ROOT}/sources/bootstrap/easybuild-easyconfigs-${FY_EB_VERSION}.tar.gz   ]; then 
#     cd ${FY_ROOT}/sources/bootstrap     
#     curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  
#     curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-${FY_EB_VERSION}.tar.gz   
#     curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-${FY_EB_VERSION}.tar.gz    
#     curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-${FY_EB_VERSION}.tar.gz       
# fi     
# export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES   
# export EASYBUILD_BOOTSTRAP_SOURCEPATH=${FY_ROOT}/sources/bootstrap    
# export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}   
# # ${PYTHON_EXE} 
# python ${FY_ROOT}/sources/bootstrap/bootstrap_eb.py  ${FY_EB_PREFIX}  
# unset EASYBUILD_BOOTSTRAP_SKIP_STAGE0  
# unset EASYBUILD_BOOTSTRAP_SOURCEPATH  
# unset EASYBUILD_BOOTSTRAP_FORCE_VERSION    

# if [ -f ${FY_ROOT}/bootstrap/easybuild-${FY_EB_VERSION}.patch ]; then 
#     PY_VER=$(python -c "import sys ;print('python%d.%d'%(sys.version_info.major,sys.version_info.minor))")  
#     cd ${FY_EB_PREFIX}/software/EasyBuild/${FY_EB_VERSION}/lib/${PY_VER}/site-packages 
#     patch -s -p0 < ${FY_ROOT}/bootstrap/easybuild-${FY_EB_VERSION}.patch      
# fi 
