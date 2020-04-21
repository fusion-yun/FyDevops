# syntax=docker/dockerfile:experimental

FROM centos:8



ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}

USER root

RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \  
    mkdir -p ${FUYUN_DIR} ; \                  
    cp -r /fycache/centos_8  ${FUYUN_DIR} ;\
    rm -f ${FUYUN_DIR}/sources ; \
    cp -r /fycache/sources ${FUYUN_DIR}/sources  


# RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \  
#     mkdir -p /fycache/${FY_OS}_${FY_OS_VERSION} ;\
#     cp -rf ${FUYUN_DIR}/software /fycache/${FY_OS}_${FY_OS_VERSION}/software ;\
#     cp -rf ${FUYUN_DIR}/modules /fycache/${FY_OS}_${FY_OS_VERSION}/modules ;\
#     cp -rf ${FUYUN_DIR}/ebfiles_repo /fycache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ;\
#     cp -rf ${FUYUN_DIR}/sources  /fycache/sources ; \
#     chown  ${FYDEV_USER}:${FYDEV_USER} -R  /fycache/${FY_OS}_${FY_OS_VERSION}/;\
#     ls -lh
# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/fycache,sharing=shared \                
#     ls  -lh ${FUYUN_DIR}/software
