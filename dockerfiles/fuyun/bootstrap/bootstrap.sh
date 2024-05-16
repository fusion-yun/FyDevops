#!/bin/bash
INSTALL_SRC=`pwd`

INSTALL_PREFIX=$1  # 使用第一个命令行参数作为安装前缀

mkdir -p ${INSTALL_PREFIX}

echo "===================== Bootstrap  ========================="
echo "* Install FuYun software stack in ${INSTALL_PREFIX}"

FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.4}
FY_LUA_VERSION=${FY_LUA_VERSION:-5.4.2}
FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.11.0}
FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.7.37}

echo "* Install Lua ${FY_LUA_VERSION} from ${INSTALL_SRC}"

# if ! [ -f ${INSTALL_SRC}/lua-${FY_LUA_VERSION}.tar.gz ]; then  
#     curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${INSTALL_SRC}/lua-${FY_LUA_VERSION}.tar.gz   
# fi 
# if ! [ -f ${INSTALL_SRC}/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ]; then  
#     curl -L https://luarocks.github.io/luarocks/releases/luarocks-${FY_LUAROCKS_VERSION}.tar.gz
# fi        

export TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX)
mkdir -p ${TMP_BUILD}/lua
tar xzf ${INSTALL_SRC}/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1
cd ${TMP_BUILD}/lua
make INSTALL_TOP=${INSTALL_PREFIX} PLAT=linux all
make INSTALL_TOP=${INSTALL_PREFIX} PLAT=linux test
make INSTALL_TOP=${INSTALL_PREFIX} PLAT=linux install
cd ..
mkdir -p ${TMP_BUILD}/luarocks
tar xzf ${INSTALL_SRC}/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1
cd ${TMP_BUILD}/luarocks
./configure --prefix=${INSTALL_PREFIX} --with-lua=${INSTALL_PREFIX}
make 
make install
cd ../../
echo ${TMP_BUILD}
rm -rf ${TMP_BUILD}
${INSTALL_PREFIX}/bin/luarocks install luaposix 
${INSTALL_PREFIX}/bin/luarocks install luafilesystem 


export LUA_DIR=${INSTALL_PREFIX}
export LUA_ROOT=${LUA_DIR}
export LUAROCKS_PREFIX=${LUA_DIR}
export LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
export LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
export PATH=${LUA_DIR}/bin:${PATH}


echo "* Install Lmod ${FY_LMOD_VERSION}"
# if ! [ -f ${INSTALL_SRC}/Lmod-${FY_LMOD_VERSION}.tar.gz ]; then  
#     curl -L https://github.com/TACC/Lmod/archive/refs/tags/${FY_LMOD_VERSION}.tar.gz -o ${INSTALL_SRC}/Lmod-${FY_LMOD_VERSION}.tar.gz  
# fi 
TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)
tar xzf ${INSTALL_SRC}/Lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 
cd ${TMP_BUILD}
./configure --prefix=${INSTALL_PREFIX}  --with-lua_include=${LUA_DIR}/include; make install 
cd .. 
rm -rf ${TMP_BUILD}  

PYTHON_EXEC=${PYTHON_EXEC:-python3}

FY_EB_VERSION=${FY_EB_VERSION:-4.9.0}

echo "* Install Easybuild ${FY_EB_VERSION}"

# if ! [ -f ${INSTALL_SRC}/easybuild-easyconfigs-${FY_EB_VERSION}.tar.gz   ]; then 
#     cd ${INSTALL_SRC}/
#     curl -LO https://github.com/easybuilders/easybuild/archive/refs/tags/easybuild-${FY_EB_VERSION}.tar.gz  
#     curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/refs/tags/easybuild-${FY_EB_VERSION}.tar.gz
#     curl -LO https://github.com/easybuilders/easybuild-framework/archive/refs/tags/easybuild-${FY_EB_VERSION}.tar.gz
#     curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/refs/tags/easybuild-${FY_EB_VERSION}.tar.gz
# fi     

pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --default-timeout=100 --no-cache-dir  --prefix=${INSTALL_PREFIX} ${INSTALL_SRC}/easybuild-*-${FY_EB_VERSION}.tar.gz  

echo "* Write profile to ${INSTALL_PREFIX}/etc/fy_profile"

mkdir -p ${INSTALL_PREFIX}/etc

PYTHON_SHORT_VERSION=$(${PYTHON_EXEC} -c "import platform; print(platform.python_version())" | cut -d. -f1,2)

echo "#!/bin/sh 
. ${INSTALL_PREFIX}/lmod/lmod/init/profile
export PYTHONPATH=${INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/site-packages:$PYTHONPATH
export PATH=${INSTALL_PREFIX}/bin:$PATH
export MODULEPATH=${FY_ROOT}/modules/all
export EASYBUILD_PREFIX=${FY_ROOT}
export EASYBUILD_BUILDPATH=/tmp/eb_build
export EASYBUILD_ROBOT_PATHS=${FY_ROOT}/easyconfigs:${INSTALL_PREFIX}/easybuild/easyconfigs
" >> ${INSTALL_PREFIX}/etc/fy_profile


echo "#!/bin/bash 
    . ${INSTALL_PREFIX}/etc/fy_profile 
    exec \$@ 
    " >> ${INSTALL_PREFIX}/bin/fy_run  
    
chmod +x  ${INSTALL_PREFIX}/bin/fy_run