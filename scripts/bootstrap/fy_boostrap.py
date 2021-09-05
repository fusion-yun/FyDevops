#!/user/bin/env python 
###########################
# 
###########################
"""
    Bootstrap script for FuYun 

    stage1 : Install  lmod and EasyBuild
    stage2 : (to be continue)
    stage3 :
        
    Create by salmon (yuzhi@ipp.ac.cn)  2020.04.21

"""


if sys.version_info.major < 3 
    raise RuntimeError(f"Require Python version >3 ")

import urllib
import pathlib

def try_download( uri, source_dir="/tmp"):
    o=urllib.parse.urlsplit(uri)
    target=pathlib.Path(source_dir)/


#################################################################################################
# Install Lua
def install_lua(prefix,source_dir="/tmp"):
    FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.3}
    FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
    FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.2.1}

    if ! [ -d ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ]; then
        if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then
            mkdir -p ${FUYUN_DIR}/sources/bootstrap
            curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz
        fi

        mkdir -p ${TMP_BUILD}/lua
        tar xzf ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1
        cd ${TMP_BUILD}/lua
        make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux all
        make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux test
        make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux install
        cd ../..
        rm -rf ${TMP_BUILD}
    fi
    if ! [ -d ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ]; then

        if ! [ -f ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ]; then
            curl -L https://github.com/luarocks/luarocks/archive/v${FY_LUAROCKS_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz
        fi
        TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX)
        mkdir -p ${TMP_BUILD}/luarocks
        tar xzf ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1
        cd ${TMP_BUILD}/luarocks
        ./configure --prefix=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} --with-lua=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
        make
        make install
        cd ../..
        rm -rf ${TMP_BUILD}
        ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luaposix
        ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem
    fi

    LUA_DIR=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
    LUA_ROOT=${LUA_DIR}
    LUAROCKS_PREFIX=${LUA_DIR}
    LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
    LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
    PATH=${LUA_DIR}/bin:${PATH}

def install_lmod(prefix,FY_LMOD_VERSION="8.3.8"):
    FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.3.8}

    #################################################################################################
    # Install lmod

    if ! [ -d ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION} ]; then
        if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then
            mkdir -p ${FUYUN_DIR}/sources/bootstrap
            curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz
        fi
        TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX)
        tar xzf ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1
        cd ${TMP_BUILD}
        ./configure --prefix=${FUYUN_DIR}/software --with-lua_include=${LUA_DIR}/include
        make install
        cd ..
        rm -rf ${TMP_BUILD}
    fi

#################################################################################################
# Install EasyBuild

def install_easybuild(preifx,FY_EB_VERSION="4.2.0"):
    if ! [ -d ${FUYUN_DIR}/software/EasyBuild/${FY_EB_VERSION} ]; then
        if ! [ -f ${FUYUN_DIR}/sources/bootstrap/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz ]; then
            mkdir -p ${FUYUN_DIR}/sources/bootstrap/
            cd ${FUYUN_DIR}/sources/bootstrap/
            curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py
            curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz
            curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz
            curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz
        fi
        source ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile
        EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES \
            EASYBUILD_BOOTSTRAP_SOURCEPATH=${FUYUN_DIR}/sources/bootstrap/ \
            EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION} \
            /usr/bin/python3 ${FUYUN_DIR}/sources/bootstrap/bootstrap_eb.py ${FUYUN_DIR}
    fi

export EASYBUILD_PREFIX=${FUYUN_DIR}
export MODULEPATH=${FUYUN_DIR}/modules/all:${MODULEPATH}

# sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/profile /etc/profile.d/00_lmod.sh
# sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/cshrc /etc/profile.d/00_lmod.csh
# sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/zshrc /etc/profile.d/00_lmod.zsh
# sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/lmod_bash_completions /etc/bash_completion.d/lmod_bash_completions

# display_usage() {
#     echo -e "\nUsage:\n $0 [arguments] \n"
# }

# show_result() {
#     echo "Done"
# }
# # if less than two arguments supplied, display usage
# if [ $# -le 1 ]; then
#     display_usage
#     exit 1
# fi

# if [[ $USER == "root" ]]; then
#     echo "This script should not be run as root!"
#     display_usage
#     exit 1
# fi

# for arg in "$@"; do
#     index=$(echo $arg | cut -f1 -d=)
#     val=$(echo $arg | cut -f2 -d=)
#     case $index in
#     --help | -h)
#         display_usage
#         exit 0
#         ;;

#     *)
#         echo "index=" ${index}
#         echo "val=" ${val}

#         exit 1
#         ;;
#     esac
# done
# exit 0
