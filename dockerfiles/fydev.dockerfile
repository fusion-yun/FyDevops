# syntax=docker/dockerfile:experimental
ARG FY_OS=centos
ARG FY_OS_VERSION=8
FROM fyscratch:${FY_OS}_${FY_OS_VERSION} as scratch_stage

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

# ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
# ENV FYDEV_USER_ID=${FYDEV_USER_ID}

# RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
#     usermod -a -G wheel  ${FYDEV_USER} ; \
#     echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

USER   ${FYDEV_USER}

################################################################################
# Bootstrap

RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \  
    sudo mkdir -p /fycache/sources ; \ 
    sudo mkdir -p /fycache/${FY_OS}_${FY_OS_VERSION} ; \
    sudo ln -sf /fycache/sources   /fycache/${FY_OS}_${FY_OS_VERSION}/sources ; \ 
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R /fycache ; \   
    sudo ln -sf /fycache/${FY_OS}_${FY_OS_VERSION}   ${FUYUN_DIR}  



# Install Lua
ARG FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.3}
ARG FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
ARG FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.2.1}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.3.8}

RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared  \    
    if ! [ -d ${FUYUN_DIR}/sources/bootstrap ] ; then \
    mkdir -p ${FUYUN_DIR}/sources/bootstrap ;\
    fi
RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared  \    
    if ! [ -d ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ] ; then    \      
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then  \
    curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz  ; \
    fi; \
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ]; then  \
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
    ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem ;  \
    fi


ENV LUA_DIR=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
ENV LUA_ROOT=${LUA_DIR}
ENV LUAROCKS_PREFIX=${LUA_DIR}
ENV LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
ENV LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
ENV PATH=${LUA_DIR}/bin:${PATH}

# Install lmod
RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \ 
    if ! [ -d ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION} ]; then \    
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  \
    curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  ; \
    fi ; \    
    export TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX); \
    tar xzf ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 ; \
    cd ${TMP_BUILD};\
    ./configure --prefix=${FUYUN_DIR}/software  --with-lua_include=${LUA_DIR}/include; make install ; \ 
    cd .. ; \
    rm -rf ${TMP_BUILD} ; \
    fi

RUN sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/profile        /etc/profile.d/00_lmod.sh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/cshrc          /etc/profile.d/00_lmod.csh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/zshrc          /etc/profile.d/00_lmod.zsh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  

# Install EasyBuild
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \    
    source  ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION}/init/profile ;\
    if ! [ -d ${FUYUN_DIR}/software/EasyBuild/${FY_EB_VERSION} ]; then \
    if ! [ -f ${FUYUN_DIR}/sources/bootstrap/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz  ]; then  \
    mkdir -p ${FUYUN_DIR}/sources/bootstrap/ ; \
    cd ${FUYUN_DIR}/sources/bootstrap/ ; \
    curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py ;\
    curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz ; \
    curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz ; \
    fi ; \  
    export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES  ; \
    export EASYBUILD_BOOTSTRAP_SOURCEPATH=${FUYUN_DIR}/sources/bootstrap/  ; \
    export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}  ; \
    /usr/bin/python3 ${FUYUN_DIR}/sources/bootstrap/bootstrap_eb.py ${FUYUN_DIR} ; \
    fi

ENV EASYBUILD_PREFIX=${FUYUN_DIR}
ENV MODULEPATH=${FUYUN_DIR}/modules/all:${MODULEPATH}

####################################################################
# install packages

ARG TOOLCHAIN_NAME=${TOOLCHAIN_NAME:-foss}
ARG TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION:-2019b}
ARG FYDEV_EBFILE=${FYDEV_EBFILE:-fydev-2019b-${TOOLCHAIN_VERSION}-${TOOLCHAIN_VERSION}.eb}
RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    # --mount=type=bind,target=/tmp/sources,source=build_src \
    sudo ln -sf /fycache/${FY_OS}_${FY_OS_VERSION}   ${FUYUN_DIR} ; \
    rm -rf ${FUYUN_DIR}/software/FyDev/${FYDEV_VERSION}-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION} ;\  
    rm -rf ${FUYUN_DIR}/modules/all/FyDev/${FYDEV_VERSION} ;\  
    rm -rf ${FUYUN_DIR}/modules/devel/FyDev/${FYDEV_VERSION} ;\  
    rm -rf ${FUYUN_DIR}/ebfiles_repo/FyDev/FyDev-${FYDEV_VERSION}-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb ;\  
    ls -lh ${FUYUN_DIR}/software/lmod/ ; \
    source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
    module avail ; \
    module load EasyBuild ; \    
    eb --show-config ; \
    eb --info -r \
    --use-existing-modules \
    --minimal-toolchain \
    --sourcepath=${FUYUN_DIR}/sources:/tmp/sources \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --toolchain=${TOOLCHAIN_NAME},${TOOLCHAIN_VERSION} \
    /tmp/ebfiles/${FYDEV_EBFILE}  

RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \      
    sudo rm ${FUYUN_DIR} ;\
    sudo mkdir -p ${FUYUN_DIR} ; \              
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R ${FUYUN_DIR}     ; \
    sudo rm -rf /fycache/${FY_OS}_${FY_OS_VERSION}/software/software ; \
    sudo rm -rf /fycache/${FY_OS}_${FY_OS_VERSION}/modules/modules ; \
    sudo rm -rf /fycache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo/ebfiles_repo ; \
    cp -r /fycache/${FY_OS}_${FY_OS_VERSION}/software ${FUYUN_DIR}/ ; \
    cp -r /fycache/${FY_OS}_${FY_OS_VERSION}/modules ${FUYUN_DIR}/ ; \
    cp -r /fycache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ${FUYUN_DIR}/ 





# FROM fybase:${FY_OS}_${FY_OS_VERSION} AS export_stage  

# ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
# ENV FUYUN_DIR ${FUYUN_DIR}

# COPY --from=scratch_stage /etc/profile.d/00-lmod*  /etc/profile.d/ 
# COPY --from=scratch_stage /etc/bash_completion.d/lmod_*  /etc/bash_completion.d/
# COPY --from=scratch_stage ${FUYUN_DIR}/modules  ${FUYUN_DIR}/modules 
# COPY --from=scratch_stage ${FUYUN_DIR}/software  ${FUYUN_DIR}/software 
# COPY --from=scratch_stage ${FUYUN_DIR}/ebfiles_repo  ${FUYUN_DIR}/ebfiles_repo 

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

# ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
# ENV FYDEV_USER_ID=${FYDEV_USER_ID}
# RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
#     usermod -a -G wheel  ${FYDEV_USER} ; \
#     echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers


ENV EASYBUILD_PREFIX=${FUYUN_DIR}
ENV PYTHONPATH=${FUYUN_DIR}/software/lmod/lmod/init/:${PYTHONPATH}
ENV MODULEPATH=${FUYUN_DIR}/modules/all${MODULEPATH}

LABEL Name          "fyDev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FuYun : EasyBuild ${FY_EB_VERSION} lmod ${FY_LMOD_VERSION} + conda , FUYUN_DIR=${FUYUN_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "

USER ${FYDEV_USER}
WORKDIR /home/${FYDEV_USER}

