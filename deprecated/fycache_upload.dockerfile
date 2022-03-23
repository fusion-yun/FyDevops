# syntax=docker/dockerfile:experimental

# FROM fydev:latest
# RUN --mount=type=cache,uid=1000,gid=1000,id=fydev_pre,target=/tmp/prebuild,sharing=shared \      
#     cp -rf /fuyun/modules      /tmp/prebuild/ && \    
#     cp -rf /fuyun/software     /tmp/prebuild/ && \    
#     cp -rf /fuyun/ebfiles_repo /tmp/prebuild/  && \
#     rm -rf /tmp/prebuild/modules/fuyun && \
#     rm -rf  /tmp/prebuild/modules/all/FyDev && \
#     rm -rf  /tmp/prebuild/software/FyDev 
          


FROM fylab:latest
RUN --mount=type=cache,uid=1000,gid=1000,id=fylab_pre,target=/tmp/prebuild,sharing=shared \      
    cp -rf /fuyun/modules      /tmp/prebuild/ && \    
    cp -rf /fuyun/software     /tmp/prebuild/ && \    
    cp -rf /fuyun/ebfiles_repo /tmp/prebuild/ 
  


# FROM fysources:0.0.1
# RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/tmp/sources,sharing=shared \      
#     cp -rf /fuyun/sources/*      /tmp/sources/ && \  

# FROM alpine:latest
# RUN --mount=type=cache,uid=1000,gid=1000,id=fysources,target=/tmp/sources,sharing=shared \      
#     --mount=type=bind,target=/tmp/pre_src,source=./ \
#     cp -rf /tmp/pre_src/*      /tmp/sources/  


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
