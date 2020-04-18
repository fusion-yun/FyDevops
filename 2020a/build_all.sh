#!/usr/bin/bash

OS=centos
OS_VERSION=8
OS_TAG=${OS}${OS_VERSION}

mkdir -p ../build_${OS_TAG}

docker build --progress=plain --ssh=default --rm \
     -f "dockerfiles/fyos.${OS}.dockerfile" \
     --build-arg OS_VERSION=${OS_VERSION} \
     -t fyos:${OS_TAG} \
     ../build_${OS_TAG} \
      > /tmp/build_${OS_TAG}.log 2>&1  & 

docker build --progress=plain --ssh=default --rm \
     -f "dockerfiles/fybase.dockerfile" \
     --build-arg OS_TAG=${OS_TAG}  \
     -t fybase:${OS_TAG}  \
     ../build_${OS_TAG} \
     > /tmp/build_${OS_TAG}.log 2>&1  &

docker build --progress=plain --ssh=default --rm \
     -f "dockerfiles/fypkgs.dockerfile" \
     --build-arg OS_TAG=${OS_TAG}  \
     -t fypkgs:${OS_TAG}  \
     ../build_${OS_TAG} \
     > /tmp/build_${OS_TAG}.log 2>&1  &     