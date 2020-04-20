#!/bin/bash
# create FyDev docker image
# usage:
#
FY_OS=centos
FY_OS_VERSION=8
TOOLCHAIN_NAME=foss
TOOLCHAIN_VERSION=2019b
DOCKER_IMAGE_NAME=fydev

echo "======= Build FyBase [" $(date) "] ============ " 

docker build  --rm \
     --build-arg FY_OS=${FY_OS} --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     -t fybase:${FY_OS}_${FY_OS_VERSION} \
     - < ../dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile 


echo "======= Build FyScratch [" $(date) "] ============ "  
docker build  --rm \
     --build-arg FY_OS=${FY_OS} --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     -t fyscratch:${FY_OS}_${FY_OS_VERSION} \
     - < ../dockerfiles/fyScratch.${FY_OS}.${FY_OS_VERSION}.dockerfile 
      

# echo "=======  Build FyEasyBuild [" $(date) "] ============ ">> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1

# docker build  --rm \
#      --build-arg FY_OS=${FY_OS}  --build-arg  FY_OS_VERSION=${FY_OS_VERSION} \
#      -t fyeb:${FY_OS}_${FY_OS_VERSION} \
#      - < dockerfiles/fyEasyBuild.dockerfile \
#      >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1  

# echo "=======  Build packages [" $(date) "] ============ ">> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1
# docker build --progress=plain  --rm \
#      --build-arg FY_OS=${FY_OS}  \
#      --build-arg  FY_OS_VERSION=${FY_OS_VERSION} \
#      -t fypkgs:${FY_OS}_${FY_OS_VERSION} \
#      - < dockerfiles/fypkgs.dockerfile \
#      >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1     


echo "=======  Build FyDev" ${FY_VERSION}_$(date +"%Y%m%d") " [" $(date) "] ============ "
docker build --progress=plain  --rm \
     --build-arg FY_OS=${FY_OS}  \
     --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
     -t ${DOCKER_IMAGE_NAME}:${FY_VERSION}_$(date +"%Y%m%d") \
     -f ../dockerfiles/fydev.dockerfile \
     ../


echo "======= Done [" $(date) "]============ "  
# ./create_images.sh > /tmp/build_fydev_$(date +"%Y%m%d").log 2>&1 &
