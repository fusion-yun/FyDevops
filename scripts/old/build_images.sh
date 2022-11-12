#!/bin/bash
# create FyDev docker image
# usage:
#

TOOLCHAIN_NAME=foss
TOOLCHAIN_VERSION=2019b

BUILD_TAG=$(git describe --dirty --always --tags)
FYDEV_VERSION=0.0.1
FYLAB_VERSION=0.0.1

# echo "======= Build FyBase ["  $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "&& \
# docker  buildx build  --progress=plain --rm \
#      --build-arg BASE_TAG=centos:8 \
#      -t fybase:${BUILD_TAG} \
#      -f ../dockerfiles/fybase.centos8.dockerfile \
#      ../ && \
# docker tag fybase:${BUILD_TAG} fybase:latest  

# echo "=======  Build FyDev [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ " && \
# docker  buildx build  --progress=plain --rm \
#      --build-arg BASE_TAG=fybase:${BUILD_TAG} \
#      --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
#      --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
#      --build-arg FYDEV_VERSION=${FYDEV_VERSION} \
#      --build-arg BUILD_TAG=${BUILD_TAG} \
#      -t fydev:${BUILD_TAG} \
#      -f ../dockerfiles/fydev.dockerfile \
#      ../ && \
# docker tag fydev:${BUILD_TAG} fydev:latest # 


echo "=======  Build FyLab  [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ " && \
docker buildx build --progress=plain --rm \
    --build-arg BASE_TAG=fybase:latest  \
    --build-arg PREV_STAGE=fylab:latest \
    --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
    --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
    --build-arg FYLAB_VERSION=${FYLAB_VERSION} \
    --build-arg BUILD_TAG=${BUILD_TAG} \
    -t fylab:${BUILD_TAG} \
    -f ../dockerfiles/fylab.dockerfile \
    ../ && \
docker tag fylab:${BUILD_TAG} fylab:latest && \
echo "======= Done [" ${BUILD_TAG} "]============ "

