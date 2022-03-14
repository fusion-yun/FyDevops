#!/bin/bash
FUYUN_DIR=${FUYUN_DIR:-/fuyun}
export PYTHON_EXE=/public/home/liuxj/liuxj_share/software/anaconda3/bin/python
export EASYBUILD_PREFIX=${FUYUN_DIR}
export PYTHONPATH=${FUYUN_DIR}/software/lmod/lmod/init/:${PYTHONPATH}
export MODULEPATH=${FUYUN_DIR}/modules/all${MODULEPATH}
###############################################################################

echo "===================== Install Lua ========================="
FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.4}
FY_LUA_VERSION=${FY_LUA_VERSION:-5.4.2}
FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.5.0}
FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.4.19}

mkdir -p ${FUYUN_DIR}/sources/bootstrap
 
if ! [ -d ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ] ; then         
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then  
        curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz   
    fi 
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ]; then  
        curl -L https://github.com/luarocks/luarocks/archive/v${FY_LUAROCKS_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz 
    fi        
    export TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX)
    mkdir -p ${TMP_BUILD}/lua
    tar xzf ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1 
    cd ${TMP_BUILD}/lua
    make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux all
    make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux test
    make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux install
    cd ..
    mkdir -p ${TMP_BUILD}/luarocks
    tar xzf ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1 
    cd ${TMP_BUILD}/luarocks
    ./configure --prefix=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} --with-lua=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} 
    make 
    make install
    cd ../../ 
    echo ${TMP_BUILD}
    rm -rf ${TMP_BUILD}     
    ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luaposix 
    ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem 
fi

export LUA_DIR=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
export LUA_ROOT=${LUA_DIR}
export LUAROCKS_PREFIX=${LUA_DIR}
export LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
export LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
export PATH=${LUA_DIR}/bin:${PATH}

echo "============ Install lmod ==================="
if ! [ -d ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION} ]; then     
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  
        curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  
    fi 
    TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)
    tar xzf ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 
    cd ${TMP_BUILD}
    ./configure --prefix=${FUYUN_DIR}/software  --with-lua_include=${LUA_DIR}/include; make install 
    cd .. 
    rm -rf ${TMP_BUILD}  
fi
    # sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/profile        /etc/profile.d/00_lmod.sh ; 
    # sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/cshrc          /etc/profile.d/00_lmod.csh ; 
    # sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/zshrc          /etc/profile.d/00_lmod.zsh ; 
    # sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  
export LMOD_PATH=${FUYUN_DIR}/software/lmod/lmod/
export PYTHONPATH=${LMOD_PATH}/init/:${PYTHONPATH}


echo "================ EasyBuild ======================="
source ${LMOD_PATH}/init/bash
FY_EB_VERSION=4.4.1
FY_EB_PREFIX=${FUYUN_DIR}

if ! [ -f ${FUYUN_DIR}/sources/bootstrap/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz   ]; then 
    cd ${FUYUN_DIR}/sources/bootstrap     
    curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  
    curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz   
    curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz    
    curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz       
fi     
export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES   
export EASYBUILD_BOOTSTRAP_SOURCEPATH=${FUYUN_DIR}/sources/bootstrap    
export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}   
$PYTHON_EXE ${FUYUN_DIR}/sources/bootstrap/bootstrap_eb.py  ${FY_EB_PREFIX}  
unset EASYBUILD_BOOTSTRAP_SKIP_STAGE0  
unset EASYBUILD_BOOTSTRAP_SOURCEPATH  
unset EASYBUILD_BOOTSTRAP_FORCE_VERSION    

# if [ -f ${FUYUN_DIR}/bootstrap/easybuild-${FY_EB_VERSION}.patch ]; then 
#     PY_VER=$(python -c "import sys ;print('python%d.%d'%(sys.version_info.major,sys.version_info.minor))")  
#     cd ${FY_EB_PREFIX}/software/EasyBuild/${FY_EB_VERSION}/lib/${PY_VER}/site-packages 
#     patch -s -p0 < ${FUYUN_DIR}/bootstrap/easybuild-${FY_EB_VERSION}.patch      
# fi 