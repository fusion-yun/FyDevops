
ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}
FROM ${FY_OS}:${FY_OS_VERSION}
####################################################################
# Install Lua
ARG FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.3}
ARG FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
ARG FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.2.1}
ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.3.8}
RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared  \              
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
    rm -rf ${TMP_BUILD} 
