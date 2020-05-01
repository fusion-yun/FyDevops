#!/bin/bash
# create FyDev docker image
# usage:
#
FY_OS=centos
FY_OS_VERSION=8
TOOLCHAIN_NAME=foss
TOOLCHAIN_VERSION=2019b
DOCKER_IMAGE_NAME=fydev
BUILD_TAG=$(git describe --dirty --always --tags)
FYDEV_VERSION=0.0.0
FYLAB_VERSION=0.0.0

echo "======= Build FyBase ["  $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "
EB_BOOTSTRAP_DIR=../../eb_boostrap
if [ -d ${EB_BOOTSTRAP_DIR} ]; then
     cp ../ebfiles/easybuild* ${EB_BOOTSTRAP_DIR}/
else
     EB_BOOTSTRAP_DIR=../ebfiles
fi
docker build --progress=plain --rm \
     --build-arg FY_OS=${FY_OS} \
     --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     --build-arg BUILD_TAG=${BUILD_TAG} \
     -t fybase:${BUILD_TAG} \
     -f ../dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile \
     ${EB_BOOTSTRAP_DIR}
 

docker tag fybase:${BUILD_TAG} fybase:latest

echo "=======  Build FyDev [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "

docker build --progress=plain --rm \
     --build-arg BASE_TAG=fybase:${BUILD_TAG} \
     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
     --build-arg FYDEV_VERSION=${FYDEV_VERSION} \
     --build-arg BUILD_TAG=${BUILD_TAG} \
     -t fydev:${BUILD_TAG} \
     -f ../dockerfiles/fydev.dockerfile \
     ../ebfiles

# docker tag fydev:${BUILD_TAG} fydev:latest

echo "=======  Build FyLab  [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "
docker build --progress=plain --rm \
    --build-arg BASE_TAG=fydev:${BUILD_TAG} \
    --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
    --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
    --build-arg FYLAB_VERSION=${FYLAB_VERSION} \
    --build-arg BUILD_TAG=${BUILD_TAG} \
    -t fylab:${BUILD_TAG} \
    -f ../dockerfiles/fylab.dockerfile \
    ../ebfiles

docker tag fylab:${BUILD_TAG} fylab:latest


# echo "=======  Build FyLab  [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "

# docker build --progress=plain --rm \
#     --build-arg BASE_TAG=fybase:latest \
#     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
#     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
#     --build-arg FYLAB_VERSION=${FYLAB_VERSION} \
#     --build-arg BUILD_TAG=${BUILD_TAG} \
#     -t fylab:${BUILD_TAG}_fix \
#     -f ../dockerfiles/fylab_fix.dockerfile \
#     ../ebfiles

# docker tag fylab:${BUILD_TAG}_fix fylab:latest



echo "======= Done [" ${BUILD_TAG} "]============ "

#docker run --rm -it --mount source=/home/salmon/workspace,target=/workspaces,type=bind fydev:latest
