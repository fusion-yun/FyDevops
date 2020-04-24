#!/bin/bash
# create FyDev docker image
# usage:
#
FY_OS=centos
FY_OS_VERSION=8
TOOLCHAIN_NAME=foss
TOOLCHAIN_VERSION=2019b
DOCKER_IMAGE_NAME=fydev
IMAGE_TAG=$(date +"%Y%m%d")
FYDEV_VERSION=0.0.0
FYLAB_VERSION=0.0.0

echo "======= Build FyBase [" $(date) "] ============ " 

docker build  --progress=plain --rm \
     --build-arg FY_OS=${FY_OS} \
     --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     -t fybase:${IMAGE_TAG} \
     - < ../dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile 
     
docker tag fybase:${IMAGE_TAG} fybase:latest


echo "=======  Build FyDev" $(date +"%Y%m%d") " [" $(date) "] ============ "
docker build --progress=plain  --rm \
     --build-arg FY_OS=${FY_OS}  \
     --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
     --build-arg FYDEV_VERSION=${FYDEV_VERSION} \
     --build-arg IMAGE_TAG=${IMAGE_TAG} \
     -t fydev:${IMAGE_TAG} \
     -f ../dockerfiles/fydev.dockerfile \
     ../ebfiles
     
docker tag fydev:${IMAGE_TAG} fydev:latest

echo "=======  Build FyLab" $(date +"%Y%m%d") " [" $(date) "] ============ "
docker build --progress=plain  --rm \
     --build-arg IMAGE_TAG=${IMAGE_TAG} \
     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
     --build-arg FYLAB_VERSION=${FYLAB_VERSION} \
     -t fylab:${IMAGE_TAG} \
     -f ../dockerfiles/fylab.dockerfile \
     ../ebfiles

docker tag fylab:${IMAGE_TAG} fylab:latest



# echo "=======  Build FyBox" $(date +"%Y%m%d") " [" $(date) "] ============ "
# docker build --progress=plain  --rm \
#      --build-arg IMAGE_TAG=${IMAGE_TAG} \
#      -t fybox:${IMAGE_TAG} \
#      - < ../dockerfiles/fybox.dockerfile

echo "======= Done [" $(date) "]============ "  
# ./create_images.sh > /tmp/build_fydev_$(date +"%Y%m%d").log 2>&1 &
