# syntax=docker/dockerfile:experimental

FROM alpine:latest


RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
     mkdir -p /fuyun &&\
     rm -rf /tmp/cache/sources/sources && \
     ls /tmp/cache/sources && \
     cp -r /tmp/cache/sources /fuyun/sources

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
