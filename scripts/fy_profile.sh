#!/bin/bash
#export FY_ROOT=${FY_ROOT:-/public/share/physical_suport}

export FY_ROOT=${FY_ROOT:-$@}

# echo "USING FY_ROOT=${FY_ROOT}"

source ${FY_ROOT}/software/lmod/lmod/init/profile

module use ${FY_ROOT}/modules/external  
module use ${FY_ROOT}/modules/system  
module use ${FY_ROOT}/modules/tools  
module use ${FY_ROOT}/modules/lib  

module use ${FY_ROOT}/modules/data  
module use ${FY_ROOT}/modules/phys  
module use ${FY_ROOT}/modules/cae
module use ${FY_ROOT}/modules/vis
module use ${FY_ROOT}/modules/math  
module use ${FY_ROOT}/modules/numlib  
module use ${FY_ROOT}/modules/lang  
module use ${FY_ROOT}/modules/devel  
module use ${FY_ROOT}/modules/mpi  
module use ${FY_ROOT}/modules/compiler  
module use ${FY_ROOT}/modules/toolchain 

