#!/usr/bin/bash
FY_OS=centos
FY_OS_VERSION=8
echo "======= Build FyBase [" $(date) "] ============ "  > /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1     

docker build  --rm \
     --build-arg FY_OS=${FY_OS} --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     -t fybase:${FY_OS}_${FY_OS_VERSION} \
     - < "dockerfiles/fyBase.${FY_OS}.${FY_OS_VERSION}.dockerfile" \
      >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1  


echo "======= Build FyScratch [" $(date) "] ============ "  >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1     
docker build  --rm \
     --build-arg FY_OS=${FY_OS} --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
     -t fyscratch:${FY_OS}_${FY_OS_VERSION} \
     - < "dockerfiles/fyScratch.${FY_OS}.${FY_OS_VERSION}.dockerfile" \
      >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1  

echo "=======  Build FyEasyBuild [" $(date) "] ============ ">> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1

docker build  --rm \
     --build-arg FY_OS=${FY_OS}  --build-arg  FY_OS_VERSION=${FY_OS_VERSION} \
     -t fyeb:${FY_OS}_${FY_OS_VERSION} \
     - < dockerfiles/fyEasyBuild.dockerfile \
     >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1  

echo "=======  Build packages [" $(date) "] ============ ">> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1
docker build --progress=plain  --rm \
     --build-arg FY_OS=${FY_OS}  --build-arg  FY_OS_VERSION=${FY_OS_VERSION} \
     -t fypkgs:${FY_OS}_${FY_OS_VERSION} \
     - < dockerfiles/fypkgs.dockerfile \
     >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1     


# echo "=======  Export FyDev [" $(date) "] ============ ">> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1     

# docker build --progress=plain  --rm \
#      --build-arg FY_SCRATCH=fyeb:centos_8 \
#      --build-arg FY_OS=${FY_OS}  \
#      --build-arg FY_OS_VERSION=${FY_OS_VERSION} \
#      -t fydev:${FY_OS}_${FY_OS_VERSION} \
#      - < dockerfiles/fydev.dockerfile \
#      >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1       


echo "======= Done [" $(date) "]============ " >> /tmp/build_${FY_OS}_${FY_OS_VERSION}.log 2>&1     