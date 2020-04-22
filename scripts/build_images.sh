#!/bin/bash
# create FyDev docker image
# usage:
#
FY_OS=centos
FY_OS_VERSION=8
TOOLCHAIN_NAME=foss
TOOLCHAIN_VERSION=2019b
DOCKER_IMAGE_NAME=fydev
FYDEV_TAG=$(date +"%Y%m%d")

FYDEV_EBFILE=fydev-2019b-${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}.eb 

echo "======= Build FyBase [" $(date) "] ============ " 

docker build  --progress=plain --rm \
     --build-arg FY_OS=${FY_OS} --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     -t fybase:${FY_OS}_${FY_OS_VERSION} \
     - < ../dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile 


echo "=======  Build FyDev" $(date +"%Y%m%d") " [" $(date) "] ============ "
docker build --progress=plain  --rm \
     --build-arg FY_OS=${FY_OS}  \
     --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
     --build-arg FYDEV_EBFILE=${FYDEV_EBFILE} \
     -t fydev:${FYDEV_TAG} \
     -f ../dockerfiles/fydev.dockerfile \
     ../


echo "=======  Build FyBox" $(date +"%Y%m%d") " [" $(date) "] ============ "
docker build --progress=plain  --rm \
     --build-arg FYDEV_TAG=${FYDEV_TAG} \
     -t fybox:${FYDEV_TAG} \
     - < ../dockerfiles/fybox.dockerfile

echo "======= Done [" $(date) "]============ "  
# ./create_images.sh > /tmp/build_fydev_$(date +"%Y%m%d").log 2>&1 &
