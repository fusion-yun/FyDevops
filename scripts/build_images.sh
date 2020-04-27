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

# echo "======= Build FyBase [" $(date) "] ============ " 
# docker build  --progress=plain --rm \
#      --build-arg FY_OS=${FY_OS} \
#      --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
#      -t fybase:${IMAGE_TAG} \
<<<<<<< HEAD
#      -f ../dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile   \
#      ../ebfiles

=======
#      - < ../dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile   
#
>>>>>>> bb7e8fb14018a8cdad8046b7b08248e8a85affdf
# docker tag fybase:${IMAGE_TAG} fybase:latest


echo "=======  Build FyDev" $(date +"%Y%m%d") " [" $(date) "] ============ "
docker build --progress=plain  --rm \
     --build-arg FY_OS=${FY_OS}  \
     --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
     --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
     --build-arg FYDEV_VERSION=${FYDEV_VERSION} \
<<<<<<< HEAD
     --build-arg BASE_TAG=fybase:latest \
=======
     --build-arg IMAGE_TAG=${IMAGE_TAG} \
>>>>>>> bb7e8fb14018a8cdad8046b7b08248e8a85affdf
     -t fydev:${IMAGE_TAG} \
     -f ../dockerfiles/fydev.dockerfile \
     ../ebfiles     

<<<<<<< HEAD
# docker tag fydev:${IMAGE_TAG} fydev:latest

# echo "=======  Build FyLab" $(date +"%Y%m%d") " [" $(date) "] ============ "
# docker build --progress=plain  --rm \
#      --build-arg BASE_TAG=fydev:latest \
=======
docker tag fydev:${IMAGE_TAG} fydev:latest

# echo "=======  Build FyLab" $(date +"%Y%m%d") " [" $(date) "] ============ "
# docker build --progress=plain  --rm \
#      --build-arg IMAGE_TAG=${IMAGE_TAG} \
>>>>>>> bb7e8fb14018a8cdad8046b7b08248e8a85affdf
#      --build-arg TOOLCHAIN_NAME=${TOOLCHAIN_NAME} \
#      --build-arg TOOLCHAIN_VERSION=${TOOLCHAIN_VERSION} \
#      --build-arg FYLAB_VERSION=${FYLAB_VERSION} \
#      -t fylab:${IMAGE_TAG} \
#      -f ../dockerfiles/fylab.dockerfile \
#      ../ebfiles

# docker tag fylab:${IMAGE_TAG} fylab:latest

<<<<<<< HEAD
# echo "======= Done [" $(date) "]============ "  
=======
echo "======= Done [" $(date) "]============ "  
>>>>>>> bb7e8fb14018a8cdad8046b7b08248e8a85affdf

#docker run --rm -it --mount source=/home/salmon/workspace,target=/workspaces,type=bind fydev:latest