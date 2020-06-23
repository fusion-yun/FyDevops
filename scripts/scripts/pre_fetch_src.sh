#!/bin/bash
#  pre-fetch source codes from git.iter.org to local sources directory
#

BUILD_DIR=$(cd "$(dirname "$0")/../"; pwd)

UDA_VERSION=2.3.0
INSTALLER_VERSION=1.9.3
DD_VERSION=3.28.1
AL_VERSION=4.7.2
FC2K_VERSION=4.10.1
IMAS_VERSION=${DD_VERSION}_${AL_VERSION}

if ! [ -f ${BUILD_DIR}/sources/u/UDA/uda-${UDA_VERSION}.tar.gz  ]; then 
    git archive --format=tar.gz --prefix=uda/ --remote=ssh://git@git.iter.org/imas/uda.git ${UDA_VERSION} > ${BUILD_DIR}/sources/u/UDA/uda-${UDA_VERSION}.tar.gz
fi 

if ! [ -f ${BUILD_DIR}/sources/f/FC2K/fc2k-${FC2K_VERSION}.tar.gz  ]; then \
    git archive --format=tar.gz --prefix=fc2k/ --remote=ssh://git@git.iter.org/imex/fc2k.git ${FC2K_VERSION} > ${BUILD_DIR}/sources/f/FC2K/fc2k-${FC2K_VERSION}.tar.gz
fi 

if ! [ -f ${BUILD_DIR}/sources/i/IMAS/installer-${INSTALLER_VERSION}.tar.gz  ]; then 
    git archive --format=tar.gz --prefix=installer/ --remote=ssh://git@git.iter.org/imas/installer.git ${INSTALLER_VERSION} >  ${BUILD_DIR}/sources/i/IMAS/installer-${INSTALLER_VERSION}.tar.gz
fi 

cd ${BUILD_DIR}/sources/i/IMAS/
if ! [ -f access-layer-repo.tar.gz  ]; then 
    git clone ssh://git@git.iter.org/imas/access-layer
    tar czvf access-layer-repo.tar.gz access-layer
    # git archive --format=tar.gz --prefix=access-layer/ --remote=ssh://git@git.iter.org/imas/access-layer.git ${AL_VERSION} >  ../sources/i/IMAS/access-layer-${AL_VERSION}.tar.gz
fi 

if ! [ -f data-dictionary-repo.tar.gz  ]; then 
    git clone ssh://git@git.iter.org/imas/data-dictionary
    tar czvf data-dictionary-repo.tar.gz data-dictionary
    # git archive --format=tar.gz --prefix=data-dictionary/ --remote=ssh://git@git.iter.org/imas/data-dictionary.git ${DD_VERSION} >  ../sources/i/IMAS/data-dictionary-${DD_VERSION}.tar.gz
fi 
