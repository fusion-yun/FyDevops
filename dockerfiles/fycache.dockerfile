# syntax=docker/dockerfile:experimental

FROM fydev:20200421

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ARG FYDEV_USER=${FYDEV_USER:-fydev}

USER root

# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/fycache,sharing=shared \  
#     mkdir -p ${FUYUN_DIR} ; \                  
#     cp -r /fycache/${FY_OS}_${FY_OS_VERSION}/software ${FUYUN_DIR}/software ;\
#     cp -r /fycache/${FY_OS}_${FY_OS_VERSION}/modules ${FUYUN_DIR}/modules ;\
#     cp -r /fycache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ${FUYUN_DIR}/ebfiles_repo ;\
#     cp -r /fycache/sources ${FUYUN_DIR}/sources  
RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \  
    mkdir -p /fycache/${FY_OS}_${FY_OS_VERSION} ;\
    cp -rf ${FUYUN_DIR}/software /fycache/${FY_OS}_${FY_OS_VERSION}/software ;\
    cp -rf ${FUYUN_DIR}/modules /fycache/${FY_OS}_${FY_OS_VERSION}/modules ;\
    cp -rf ${FUYUN_DIR}/ebfiles_repo /fycache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ;\
    cp -rf ${FUYUN_DIR}/sources  /fycache/sources ; \
    chown  ${FYDEV_USER}:${FYDEV_USER} -R  /fycache/${FY_OS}_${FY_OS_VERSION}/;\
    ls -lh
# RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/fycache,sharing=shared \                
#     ls  -lh ${FUYUN_DIR}/software
