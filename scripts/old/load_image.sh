#!/bin/bash

TARGET_TAG=${TARGET_TAG:-hfcube_support}
TARGET_IMAGE=${TARGET_IMAGE:-fydev:hfcube_support}
TARGET_FY_PREFIX=${TARGET_FY_PREFIX:-/public/share/physical_suport}
TARGET_USER=${TARGET_USER:-physical_suport}

echo "TARGET_TAG=${TARGET_TAG}"
echo "TARGET_IMAGE=${TARGET_IMAGE}"
echo "TARGET_FY_PREFIX=${TARGET_FY_PREFIX}"

FYDEV_PREFIX=/gpfs/fuyun_

docker run  --rm --user ${TARGET_USER} -it \
-e FY_ROOT=${TARGET_FY_PREFIX} \
--mount type=bind,source=${FYDEV_PREFIX}repos/${TARGET_TAG}/fuyun,target=${TARGET_FY_PREFIX} \
--mount type=bind,source=${FYDEV_PREFIX}sources/,target=${TARGET_FY_PREFIX}/sources,readonly \
 ${TARGET_IMAGE} 


#"bash source ${TARGET_FY_PREFIX}/sources/scripts/fydev_init.sh" 