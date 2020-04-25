# syntax=docker/dockerfile:experimental

FROM centos:8



ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}

USER root

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    # # mv /tmp/cache/centos_8/software/Miniconda3 /tmp/cache ;\
    # rm -rf /tmp/cache/centos_8/modules/all/FyDev/2019b-foss-2019b.lua ;\
    # rm -rf /tmp/cache/centos_8/modules/devel/FyDev/2019b-foss-2019b.lua ;\
    # rm -rf /tmp/cache/centos_8/ebfiles_repo/FyDev/FyDev-2019b-foss-2019b.eb
    mkdir -p /fycache ; \                  
    cp -r /tmp/cache/centos_8/ebfiles_repo  /fycache/ebfiles_repo ;\
    cp -r /tmp/cache/centos_8/modules  /fycache/modules ;\
    cp -r /tmp/cache/centos_8/software  /fycache/software ;\
    cp -r /tmp/cache/sources  /fycache/sources ;\
    ls -lh /fycache/software



    # RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    #     mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION} ;\
    #     cp -rf ${FUYUN_DIR}/software /tmp/cache/${FY_OS}_${FY_OS_VERSION}/software ;\
    #     cp -rf ${FUYUN_DIR}/modules /tmp/cache/${FY_OS}_${FY_OS_VERSION}/modules ;\
    #     cp -rf ${FUYUN_DIR}/ebfiles_repo /tmp/cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ;\
    #     cp -rf ${FUYUN_DIR}/sources  /tmp/cache/sources ; \
    #     chown  ${FYDEV_USER}:${FYDEV_USER} -R  /tmp/cache/${FY_OS}_${FY_OS_VERSION}/;\
    #     ls -lh
    # RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/tmp/cache,sharing=shared \                
    #     ls  -lh ${FUYUN_DIR}/software
