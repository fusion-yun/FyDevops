#!/usr/bin/bash

# install buildx
# 
#  export DOCKER_BUILDKIT=1
#  docker build --platform=local -o . git://github.com/docker/buildx
#  mkdir -p ~/.docker/cli-plugins
#  mv buildx ~/.docker/cli-plugins/docker-buildx
OS=centos
OS_VERSION=8
OS_TAG=${OS}${OS_VERSION}

mkdir -p ../build_${OS_TAG}

docker buildx build --progress=plain --ssh=default --rm \
     -f "dockerfiles/fyos.${OS}.dockerfile" \
     --build-arg OS_VERSION=${OS_VERSION} \
     -t fyos:${OS_TAG} ../build_${OS_TAG} \
      > /tmp/build_fyos_${OS_TAG}.log 2>&1  & # redirect stderr to log file
