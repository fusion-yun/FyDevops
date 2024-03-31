#!/bin/bash
export FY_ROOT=${FY_ROOT:-/fuyun}
source ${FY_ROOT}/software/lmod/lmod/init/bash
module use ${FY_ROOT}/modules/all
eb -Dr SciPy-bundle-2023.07-gfbf-2023a.eb foss-2023a.eb > /fuyun/foss-2023a.log  2>&1 &