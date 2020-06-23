#!/bin/bash
#
#  Build and install IMAS environment
#

FUYUN_HOME=/gpfs/fuyun

SOURCE_DIR=${FUYUN_HOME}/sources
BUILD_DIR=/tmp/fybuild
mkdir -p ${BUILD_DIR}

SCRIPT_DIR=$(cd "$(dirname "$0")/../"; pwd)
SCRIPT_TAG=$(git describe --dirty --always --tags)
 
export EASYBUILD_PREFIX=${FUYUN_HOME}
 
#source /etc/profile.d/modules.sh 

module use ${EASYBUILD_PREFIX}/modules/all
module load EasyBuild/${FY_EB_VERSION} 


TOOLCHAIN="foss-2019b"
IMAS_VERSION="3.28.1_4.7.2"



EBFILES_PATH=${SCRIPT_DIR}/easybuild/easyconfigs:${SCRIPT_DIR}/../imas_ebs/easybuild/easyconfigs

echo "=======  Build IMAS [" $(date +"%Y%m%d") ${SCRIPT_TAG} "] ============ "  

FY_EB_ARGS="--buildpath=${BUILD_DIR}/   \
  --sourcepath=${SOURCE_DIR} \
  --robot-paths=${EBFILES_PATH}:${EBROOTEASYBUILD}/easybuild/easyconfigs  \
  --minimal-toolchain --use-existing-modules  -lr "

eb ${FY_EB_ARGS} --show-config  

eb ${FY_EB_ARGS} IMAS-3.28.1_4.7.2-foss-2019b.eb
eb ${FY_EB_ARGS} IMAS_devs-3.28.1_4.7.2-foss-2019b.eb
eb ${FY_EB_ARGS} IMAS_actors-3.28.1_4.7.2-foss-2019b.eb
# eb ${FY_EB_ARGS} GCCcore-8.3.0.eb   && \
# eb ${FY_EB_ARGS} Tcl-8.6.9-GCCcore-8.3.0.eb && \
# eb ${FY_EB_ARGS} Python-3.7.4-GCCcore-8.3.0.eb  && \
# eb ${FY_EB_ARGS} Perl-5.30.0-GCCcore-8.3.0.eb  PCRE-8.43-GCCcore-8.3.0.eb   && \
# eb ${FY_EB_ARGS} gompi-2019b.eb  && \
# eb ${FY_EB_ARGS} HDF5-1.10.5-gompi-2019b.eb  && \
# eb ${FY_EB_ARGS} Boost-1.71.0-gompi-2019b.eb  && \
# eb ${FY_EB_ARGS} foss-2019b.eb  && \
# eb ${FY_EB_ARGS} SciPy-bundle-2019.10-foss-2019b-Python-3.7.4.eb  && \
# eb ${FY_EB_ARGS} netCDF-4.7.1-gompi-2019b.eb
# eb ${FY_EB_ARGS} netCDF-C++4-4.3.1-gompi-2019b.eb
# eb ${FY_EB_ARGS} PyQt5-5.15.0-GCCcore-8.3.0-Python-3.7.4.eb
# eb ${FY_EB_ARGS} --moduleclasses=fuyun  FyDev-0.0.1.eb   
# eb ${FY_EB_ARGS} --moduleclasses=fuyun  FyLab-0.0.1.eb   

echo "======= Done [" ${SCRIPT_TAG} "]============ "
