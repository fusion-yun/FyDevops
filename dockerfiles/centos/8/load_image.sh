#!/bin/bash


TARGET_TAG=${TARGET_TAG:-centos8}
TARGET_IMAGE=${TARGET_IMAGE:-fydev:centos.8}
TARGET_FY_PREFIX=${TARGET_FY_PREFIX:-/fuyun}

FYDEV_PREFIX=/gpfs/fuyun_
FYDEV_REPO=${FYDEV_PREFIX}repos/centos/9

docker run  --rm   -it \
-e FY_ROOT=${TARGET_FY_PREFIX} \
--mount type=bind,source=${FYDEV_REPO}/fuyun/software,target=${TARGET_FY_PREFIX}/software \
--mount type=bind,source=${FYDEV_REPO}/fuyun/modules,target=${TARGET_FY_PREFIX}/modules \
--mount type=bind,source=${FYDEV_REPO}/fuyun/ebfiles_repo,target=${TARGET_FY_PREFIX}/ebfiles_repo \
--mount type=bind,source=${FYDEV_PREFIX}sources/,target=${TARGET_FY_PREFIX}/sources \
  ${TARGET_IMAGE}


#"bash source ${TARGET_FY_PREFIX}/sources/scripts/fydev_init.sh"