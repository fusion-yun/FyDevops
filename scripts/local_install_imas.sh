#!/bin/bash

# OS dependence
# sudo yum install -y texlive texlive-epstopdf 


export EASYBUILD_PREFIX=/gpfs/fuyun 
FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

module use ${EASYBUILD_PREFIX}/modules/all
module load EasyBuild/${FY_EB_VERSION} 


TOOLCHAIN="foss-2019b"
IMAS_VERSION="3.28.1_4.7.2"

SCRIPT_DIR=$(cd "$(dirname "$0")/../"; pwd)
SCRIPT_TAG=$(git describe --dirty --always --tags)

TEMP_BUILD_DIR=/tmp/imasbuild_$(date +"%Y%m%d")

mkdir -p ${TEMP_BUILD_DIR}

OTHER_EBFILES=${SCRIPT_DIR}/../FyDevOps/easybuild/easyconfigs/

echo "=======  Build IMAS  [" $(date +"%Y%m%d") ${SCRIPT_TAG} "] ============ "  

EB_ARGS="--buildpath=${TEMP_BUILD_DIR}/   \
  --robot-paths=${OTHER_EBFILES}:${SCRIPT_DIR}/easybuild/easyconfigs:${EBROOTEASYBUILD}/easybuild/easyconfigs  \
  --sourcepath=${SCRIPT_DIR}/sources:${EASYBUILD_PREFIX}/sources \
  --skip-test-cases --minimal-toolchain --use-existing-modules  "

eb  ${EB_ARGS} --show-config
# eb  ${EB_ARGS} -lr  Python-3.7.4-GCCcore-8.3.0.eb 
# eb  ${EB_ARGS} -lr  IMAS-${IMAS_VERSION}-${TOOLCHAIN}.eb 
# eb  ${EB_ARGS} -lr  IMAS_devs-${IMAS_VERSION}-${TOOLCHAIN}.eb 
# eb  ${EB_ARGS} -lr  FRUIT-3.4.3-GCCcore-8.3.0-Ruby-2.7.1.eb
eb  ${EB_ARGS} -l --rebuild  XMLlib-3.3.0-GCCcore-8.3.0.eb FC2K-4.10.1-foss-2019b-IMAS-3.28.1_4.7.2.eb
eb  ${EB_ARGS} -lr GENRAY-10.11.1-foss-2019b-IMAS-3.28.1_4.7.2.eb
# eb  ${EB_ARGS} -lr  IMAS_actors-${IMAS_VERSION}-${TOOLCHAIN}.eb 
# rm -rf ${TEMP_BUILD_DIR}
echo "======= Done [" ${SCRIPT_TAG} "]============ "
