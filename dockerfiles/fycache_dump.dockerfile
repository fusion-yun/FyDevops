# syntax=docker/dockerfile:experimental

FROM centos:8



ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}

USER root

RUN --mount=type=cache,uid=1000,id=fycache,target=/fuyun,sharing=shared \  
    --mount=type=bind,target=/tmp/eb,source=./ \
    # cp -r /tmp/eb/modules /fuyun/modules ; \
    # cp -r /tmp/eb/software /fuyun/software ; \
    # cp -r /tmp/eb/ebfiles_repo /fuyun/ebfiles_repo ; \
    # cp -r /tmp/eb/sources /fuyun/sources ; \
    ls -lhR /tmp/eb/modules ; \
    ls -lh /fuyun/modules/all/GCCcore


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
