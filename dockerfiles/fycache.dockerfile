# syntax=docker/dockerfile:experimental

FROM centos:8

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ARG FYDEV_USER=${FYDEV_USER:-fydev}

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_cache,sharing=shared \  
    mkdir -p ${FUYUN_DIR} ; \              
    cp -r /eb_cache/${FY_OS}_${FY_OS_VERSION}/software ${FUYUN_DIR}/software ;\
    cp -r /eb_cache/${FY_OS}_${FY_OS_VERSION}/modules ${FUYUN_DIR}/modules ;\
    cp -r /eb_cache/${FY_OS}_${FY_OS_VERSION}/ebfiles_repo ${FUYUN_DIR}/ebfiles_repo ;\
    cp -r /eb_cache/sources ${FUYUN_DIR}/sources  

RUN --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_cache,sharing=shared \                
    ls  -lh ${FUYUN_DIR}/software
