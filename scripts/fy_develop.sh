#!/bin/bash

export FY_ROOT=${FY_ROOT:-$@}
export FY_DEVOPS=${FY_ROOT}/sources/scripts/FyDevOps/scripts

source ${FY_DEVOPS}/fy_profile.sh 

module load EasyBuild

export EASYBUILD_PREFIX=${FY_ROOT}
# export EASYBUILD_BUILDPATH=${EASYBUILD_BUILDPATH:-$(mktemp -d -p "/tmp/" -t "eb_XXXXXX")}
export EASYBUILD_ROBOT_PATHS=${FY_ROOT}/sources/scripts/FyDevOps/easyconfigs:${EBROOTEASYBUILD}/easybuild/easyconfigs

eb --show-config
# module use ${FY_ROOT}/modules/all
