#!/bin/bash
#
#  Build and install Easybuild environment
# 
#  Create by salomn (20200623)
#

FUYUN_HOME=/gpfs/fuyun

SOURCE_DIR=${FUYUN_HOME}/sources
BUILD_DIR=/tmp/imasbuild_$(date +"%Y%m%d")
mkdir -p ${BUILD_DIR}

SCRIPT_DIR=$(cd "$(dirname "$0")/../"; pwd)
SCRIPT_TAG=$(git describe --dirty --always --tags)

sudo yum install -y \
    sudo which  Lmod \
    autoconf automake make help2man \
    m4 binutils bison flex diffutils\
    gettext elfutils libtool \
    patch pkgconfig bzip2 \
    git openssh-clients \
    asciidoc xmlto \
    gcc gcc-c++ python3 perl  \
    openssl openssl-devel \
    texlive texlive-epstopdf 


export EASYBUILD_PREFIX=${FUYUN_HOME}

FY_EB_VERSION=${FY_EB_VERSION:-4.2.0}

echo "=======  Install EasyBuild-${FY_EB_VERSION} to ${FY_EB_VERSION}  [" $(date +"%Y%m%d") ${SCRIPT_TAG} "] ============ "  

source /etc/profile.d/modules.sh 
if ! [ -f ${EASYBUILD_PREFIX}/software/EasyBuild/${FY_EB_VERSION}/bin/eb ]; then
    if ! [ -f ${SOURCE_DIR}/bootstrap/bootstrap_eb.py  ]; then
        mkdir -p ${SOURCE_DIR}/bootstrap &&\
        cd ${SOURCE_DIR}/bootstrap &&\
        curl -LO https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py  
        curl -LO https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${FY_EB_VERSION}.tar.gz  
        curl -LO https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${FY_EB_VERSION}.tar.gz   
        curl -LO https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${FY_EB_VERSION}.tar.gz   ;
    fi 
    export EASYBUILD_BOOTSTRAP_SKIP_STAGE0=YES  
    export EASYBUILD_BOOTSTRAP_SOURCEPATH=${SOURCE_DIR}/bootstrap   
    export EASYBUILD_BOOTSTRAP_FORCE_VERSION=${FY_EB_VERSION}  
    /usr/bin/python3 ${SOURCE_DIR}/bootstrap/bootstrap_eb.py  ${EASYBUILD_PREFIX} 
    unset EASYBUILD_BOOTSTRAP_SKIP_STAGE0 
    unset EASYBUILD_BOOTSTRAP_SOURCEPATH 
    unset EASYBUILD_BOOTSTRAP_FORCE_VERSION 
    if [ -f ${SOURCE_DIR}/bootstrap/easybuild-${FY_EB_VERSION}.patch ]; then
        PY_VER=$(python -c "import sys ;print('python%d.%d'%(sys.version_info.major,sys.version_info.minor))") 
        cd ${EASYBUILD_PREFIX}/software/EasyBuild/${FY_EB_VERSION}/lib/${PY_VER}/site-packages 
        patch -s -p0 < ${SOURCE_DIR}/bootstrap/easybuild-${FY_EB_VERSION}.patch  ;\
    fi 
    sudo ln -s  ${EASYBUILD_PREFIX}/software/EasyBuild/${FY_EB_VERSION}/bin/eb_bash_completion.bash /etc/bash_completion.d/ ;
fi


module use ${EASYBUILD_PREFIX}/modules/all
module load EasyBuild/${FY_EB_VERSION} 


EB_ARGS="--buildpath=${TEMP_BUILD_DIR}/   \
  --robot-paths=${EBFILES_PATH}:${EBROOTEASYBUILD}/easybuild/easyconfigs  \
  --sourcepath=${SCRIPT_DIR}/sources:${EASYBUILD_PREFIX}/sources \
  --skip-test-cases --minimal-toolchain --use-existing-modules  "

eb  ${EB_ARGS} --show-config

echo "=======  Install EasyBuild-${FY_EB_VERSION}  DONE ============ "  