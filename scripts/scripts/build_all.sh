#!/bin/bash

FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}


TOOLCHAIN="foss-2019b"
IMAS_VERSION="3.28.1_4.7.2"

BUILD_DIR=$(cd "$(dirname "$0")/../"; pwd)
BUILD_TAG=$(git describe --dirty --always --tags)


echo "=======  Build IMAS  [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "  

# for imas doxygen
# sudo yum install -y texlive texlive-epstopdf 

source /etc/profile.d/modules.sh     

module load EasyBuild/${FY_EB_VERSION} 

eb --robot-paths=${BUILD_DIR}/easybuild/easyconfigs:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --sourcepath=${BUILD_DIR}/sources:$EASYBUILD_PREFIX/sources \
    --minimal-toolchain --use-existing-modules --info   -l  -r \
    IMAS_actors-${IMAS_VERSION}-${TOOLCHAIN}.eb 
    
echo "======= Done [" ${BUILD_TAG} "]============ "
