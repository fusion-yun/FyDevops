#!/bin/bash
# launch build script, catch log  and save pid to file
BUILD_TAG=$(date +"%Y%m%d")_$(git describe --dirty --always --tags)

`pwd`/build_images.sh > /tmp/build_fydev_${BUILD_TAG}.log 2>&1 & echo $! > /tmp/build_fydev_${BUILD_TAG}.pid

echo "tag is " ${BUILD_TAG}