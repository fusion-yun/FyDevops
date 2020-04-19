# syntax=docker/dockerfile:experimental
ARG FY_OS=centos
ARG FY_OS_VERSION=centos
ARG FY_SCRATCH=fyeb:centos_8

FROM ${FY_SCRATCH} as scratch_stage

USER ${FYDEV_USER}

FROM fybase:${FY_OS}_${FY_OS_VERSION} AS export-stage


ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

ENV FYDEV_USER fydev
ENV FYDEV_USER_ID 1000

RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER} ; \
    usermod -a -G wheel  ${FYDEV_USER} ; \
    echo '%wheel ALL=(ALL)    NOPASSWD: ALL' >>/etc/sudoers

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR ${FUYUN_DIR}

USER ${FYDEV_USER}

WORKDIR ${FUYUN_DIR}
COPY --from=scratch_stage ${FUYUN_DIR}/software ./software
COPY --from=scratch_stage ${FUYUN_DIR}/modules ./modules
COPY --from=scratch_stage /home/${FYDEV_USER}/.* /home/${FYDEV_USER}/

RUN sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/profile        /etc/profile.d/00_lmod.sh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/cshrc          /etc/profile.d/00_lmod.csh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/zshrc          /etc/profile.d/00_lmod.zsh ; \
    sudo ln -sf ${FUYUN_DIR}/software/lmod/lmod/init/lmod_bash_completions  /etc/bash_completion.d/lmod_bash_completions  

ENV EASYBUILD_PREFIX=${FUYUN_DIR}
ENV FY_LUA_VERSION=${FY_LUA_VERSION:-5.3.5}
ENV LUA_DIR=${FUYUN_DIR}/software/lua/${FY_LUA_VERSION}
ENV LUA_ROOT=${LUA_DIR}
# ENV LUAROCKS_PREFIX=${LUA_DIR}
# ENV LUA_PATH="${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?.lua;${LUA_DIR}/share/lua/${FY_LUA_SHORTVERSION}/?/init.lua;"
# ENV LUA_CPATH="${LUA_DIR}/lib/lua/${FY_LUA_SHORTVERSION}/?.so;${LUAROCKS_PREFIX}/lib/lua/${FY_LUA_SHORTVERSION}/?.so"

ENV PYTHONPATH=${FUYUN_DIR}/software/lmod/lmod/init/:${PYTHONPATH}
ENV PATH=${FUYUN_DIR}/software/conda/bin:${LUA_DIR}/bin:${PATH}
ENV MODULEPATH="${FUYUN_DIR}/modules/all:${MODULEPATH}"

LABEL Name          "fyDev"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "FuYun : EasyBuild ${FY_EB_VERSION} lmod ${FY_LMOD_VERSION} + conda , FUYUN_DIR=${FUYUN_DIR} FYDEV_USER=${FYDEV_USER}:${FYDEV_USER_ID} "

USER ${FYDEV_USER}
# WORKDIR /home/${FYDEV_USER}
