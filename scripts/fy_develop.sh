#!/bin/bash

export FY_ROOT=${FY_ROOT:-$@}

export FY_SCRIPTS=${FY_ROOT}/sorftware/scripts

source ${FY_SCRIPTS}/fy_profile.sh 

module load EasyBuild

export EASYBUILD_PREFIX=${FY_ROOT}
export EASYBUILD_BUILDPATH=${EASYBUILD_BUILDPATH:-$(mktemp -d -p "/tmp/" -t "eb_${USER}_XXXXXX")}
export EASYBUILD_ROBOT_PATHS=${FY_ROOT}/sources/scripts/FyDevOps/easyconfigs:${EBROOTEASYBUILD}/easybuild/easyconfigs

eb --show-config
# module use ${FY_ROOT}/modules/all
