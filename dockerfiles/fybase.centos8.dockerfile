# syntax=docker/dockerfile:experimental
ARG BASE_TAG=${BASE_TAG:-centos:8}
FROM ${BASE_TAG} 


RUN echo "exclude=*.i386 *.i686" >> /etc/yum.conf  ;\
    yum install -y dnf-plugins-core ; \
    yum config-manager --set-enabled PowerTools ;\
    # mirror.aliyun.com
    sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.aliyun.com/centos|g' \
    -i.bak \
    /etc/yum.repos.d/CentOS-AppStream.repo \
    /etc/yum.repos.d/CentOS-Base.repo \
    /etc/yum.repos.d/CentOS-Extras.repo \
    /etc/yum.repos.d/CentOS-PowerTools.repo \
    ; \
    #################################################
    yum -y --enablerepo=extras install epel-release ;\
    sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.bak \
    /etc/yum.repos.d/epel.repo \
    /etc/yum.repos.d/epel-modular.repo ; \
    yum update -y ; \
    yum install -y \      
    sudo which  Lmod \         
    # Development tools    
    autoconf automake make help2man \
    m4 binutils bison flex diffutils\    
    gettext elfutils libtool \
    patch pkgconfig bzip2 \
    git openssh-clients \
    # ctags  indent patchutils \
    # For git
    asciidoc xmlto \  
    # Language
    gcc gcc-c++ python3 perl  \        
    # Python,Perl,PostgreSQL,CMake,cURL
    openssl openssl-devel \
    ;\
    yum clean all -y -q

RUN  alternatives --set python /usr/bin/python3 ; \
    alternatives --set pip /usr/bin/pip3 ; \
    # for easybuild --dep-graph 
    pip3 install python-graph-core python-graph-dot  

# xmlto for git

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}



ENV PYTHONPATH=/usr/share/lmod/lmod/init/:${PYTHONPATH}

RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
    echo "%${FYDEV_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers

USER ${FYDEV_USER}


################################################################################
# Bootstrap
# Install EasyBuild
ARG FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

# --mount=type=cache,uid=1000,id=fycache,target=/fuyun,sharing=shared \        
#     --mount=type=bind,target=/tmp/ebfiles,source=./ \
ARG FY_EB_PREFIX=${FY_EB_PREFIX:-/opt/EasyBuild}

RUN sudo mkdir -p /opt/EasyBuild ; \
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R /opt/EasyBuild


RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \ 
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh && \    
    if ! [ -f  /tmp/cache/bootstrap/bootstrap_eb.py  ]; then \
    sudo chown ${FYDEV_USER}:${FYDEV_USER} /tmp/cache && \
    mkdir -p /tmp/cache/bootstrap &&\
    cd  /tmp/cache/bootstrap  &&\
    curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  &&\
    curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz  && \
    curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz   && \
    curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz   ; \    
    fi ; \   
    export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES  && \
    export EASYBUILD_BOOTSTRAP_SOURCEPATH=/tmp/cache/bootstrap   && \
    export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}  && \
    /usr/bin/python3 /tmp/cache/bootstrap/bootstrap_eb.py  /opt/EasyBuild && \
    unset EASYBUILD_BOOTSTRAP_SKIP_STAGE0 && \
    unset EASYBUILD_BOOTSTRAP_SOURCEPATH && \
    unset EASYBUILD_BOOTSTRAP_FORCE_VERSION && \  
    if [ -f /tmp/ebfiles/easybuild-${FY_EB_VERSION}.patch ]; then \
    PY_VER=$(python -c "import sys ;print('python%d.%d'%(sys.version_info.major,sys.version_info.minor))") && \
    cd /opt/EasyBuild/software/EasyBuild/${FY_EB_VERSION}/lib/${PY_VER}/site-packages &&\
    patch -s -p0 < /tmp/ebfiles/easybuild-${FY_EB_VERSION}.patch ;\        
    fi ; \
    sudo ln -s  /opt/EasyBuild/software/EasyBuild/${FY_EB_VERSION}/bin/eb_bash_completion.bash /etc/bash_completion.d/ 

ENV MODULEPATH=/opt/EasyBuild/modules/all:${MODULEPATH}

ARG BUILD_TAG=${BUILD_TAG:-dirty}

LABEL BUILD_TAG=${BUILD_TAG}

WORKDIR /home/${FYDEV_USER}






# ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
# ENV FYDEV_USER_ID=${FYDEV_USER_ID}
# RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
#     usermod -a -G wheel  ${FYDEV_USER} ; \
#     echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers


# ENV EASYBUILD_PREFIX=${FUYUN_DIR}
# ENV PYTHONPATH=${FUYUN_DIR}/software/lmod/lmod/init/:${PYTHONPATH}
# ENV MODULEPATH=${FUYUN_DIR}/modules/all${MODULEPATH}
################################################################################
# # Install Lua
# ARG FY_LUA_SHORTVERSION=${FY_LUA_SHORTVERSION:-5.3}
# ARG FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
# ARG FY_LUAROCKS_VERSION=${FY_LUAROCKS_VERSION:-3.2.1}
# ARG FY_LMOD_VERSION=${FY_LMOD_VERSION:-8.3.8}
# RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared  \    
#     if ! [ -d ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ] ; then    \      
#     if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz ]; then  \
#     curl -L https://www.lua.org/ftp/lua-${FY_LUA_VERSION}.tar.gz  -o ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz  ; \
#     fi; \
#     if ! [ -f ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ]; then  \
#     curl -L https://github.com/luarocks/luarocks/archive/v${FY_LUAROCKS_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz ; \
#     fi ; \        
#     export TMP_BUILD=$(mktemp -d -t tmp_build_lua_XXXXXXX); \
#     mkdir -p ${TMP_BUILD}/lua ;\
#     tar xzf ${FUYUN_DIR}/sources/bootstrap/lua-${FY_LUA_VERSION}.tar.gz -C ${TMP_BUILD}/lua --strip-components=1 ; \
#     cd ${TMP_BUILD}/lua ;\
#     make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux all; \ 
#     make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux test; \ 
#     make INSTALL_TOP=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} PLAT=linux install; \ 
#     cd .. ;\
#     mkdir -p ${TMP_BUILD}/luarocks ;\
#     tar xzf ${FUYUN_DIR}/sources/bootstrap/luarocks-${FY_LUAROCKS_VERSION}.tar.gz -C ${TMP_BUILD}/luarocks --strip-components=1 ; \
#     cd ${TMP_BUILD}/luarocks ;\
#     ./configure --prefix=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} --with-lua=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION} ; \
#     make ; \
#     make install ;\
#     cd ../.. ; \
#     rm -rf ${TMP_BUILD} ; \       
#     ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luaposix ; \
#     ${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}/bin/luarocks install luafilesystem ;  \
#     fi
# ENV LUA_DIR=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
# ENV LUA_ROOT=${LUA_DIR}
# ENV LUAROCKS_PREFIX=${LUA_DIR}
# ENV LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
# ENV LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"
# ENV PATH=${LUA_DIR}/bin:${PATH}
# # Install lmod
# RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \ 
#     if ! [ -d ${FUYUN_DIR}/software/lmod/${FY_LMOD_VERSION} ]; then \    
#     if ! [ -f ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz ]; then  \
#     curl -L https://github.com/TACC/Lmod/archive/${FY_LMOD_VERSION}.tar.gz -o ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz  ; \
#     fi ; \    
#     export TMP_BUILD=$(mktemp -d -t tmp_build_lmod_XXXXXXX); \
#     tar xzf ${FUYUN_DIR}/sources/bootstrap/lmod-${FY_LMOD_VERSION}.tar.gz -C ${TMP_BUILD} --strip-components=1 ; \
#     cd ${TMP_BUILD};\
#     ./configure --prefix=${FUYUN_DIR}/software  --with-lua_include=${LUA_DIR}/include; make install ; \ 
#     cd .. ; \
#     rm -rf ${TMP_BUILD} ; \
#     fi
# RUN sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/profile        /etc/profile.d/00_lmod.sh ; \
#     sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/cshrc          /etc/profile.d/00_lmod.csh ; \
#     sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/zshrc          /etc/profile.d/00_lmod.zsh ; \
#     sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  
# ENV PYTHONPATH=${FUYUN_DIR}/software/lmod/lmod/init/:${PYTHONPATH}
