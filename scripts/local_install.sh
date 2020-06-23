#!/bin/bash
#
#  Build and install toolchain (foss-2019b)
#  Build and install dev environment
#

FUYUN_HOME=/gpfs/fuyun

SOURCE_DIR=${FUYUN_HOME}/sources
BUILD_DIR=/tmp/fybuild
mkdir -p ${BUILD_DIR}

SCRIPT_DIR=$(cd "$(dirname "$0")/../"; pwd)
SCRIPT_TAG=$(git describe --dirty --always --tags)
 
export EASYBUILD_PREFIX=${FUYUN_HOME}
 

module use ${EASYBUILD_PREFIX}/modules/all
module load EasyBuild/${FY_EB_VERSION} 


TOOLCHAIN="foss-2019b"
IMAS_VERSION="3.28.1_4.7.2"



EBFILES_PATH=${SCRIPT_DIR}/easybuild/easyconfigs

echo "=======  Build FyDev [" $(date +"%Y%m%d") ${SCRIPT_TAG} "] ============ "  > ${BUILD_DIR}/local_install.log 2>&1 

FY_EB_ARGS="--buildpath=${BUILD_DIR}/   \
  --sourcepath=${SOURCE_DIR} \
  --robot-paths=${EBFILES_PATH}:${EBROOTEASYBUILD}/easybuild/easyconfigs  \
   --minimal-toolchain --use-existing-modules  -lr "

eb ${FY_EB_ARGS} --show-config  >> ${BUILD_DIR}/local_install.log 2>&1 

eb ${FY_EB_ARGS} GCCcore-8.3.0.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} Tcl-8.6.9-GCCcore-8.3.0.eb >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} Python-3.7.4-GCCcore-8.3.0.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} Perl-5.30.0-GCCcore-8.3.0.eb  PCRE-8.43-GCCcore-8.3.0.eb   >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} gompi-2019b.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} HDF5-1.10.5-gompi-2019b.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} Boost-1.71.0-gompi-2019b.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} foss-2019b.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} SciPy-bundle-2019.10-foss-2019b-Python-3.7.4.eb  >> ${BUILD_DIR}/local_install.log 2>&1 
# eb ${FY_EB_ARGS} --moduleclasses=fuyun  FyDev-0.01.eb   >> ${BUILD_DIR}/local_install.log 2>&1 

echo "======= Done [" ${SCRIPT_TAG} "]============ "
