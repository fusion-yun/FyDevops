#!/bin/bash
export FY_ROOT=${FY_ROOT:-$@}
echo "USING FY_ROOT=${FY_ROOT}"
source ${FY_ROOT}/software/lmod/lmod/init/profile
module use ${FY_ROOT}/modules/all

export EASYBUILD_PREFIX=${FY_ROOT}

export EASYBUILD_BUILDPATH=/tmp/eb_build
export EASYBUILD_ROBOT_PATHS=${FY_ROOT}/sources/ebfiles_extral:${EASYBUILD_ROBOT_PATHS}
module load EasyBuild

mkdir -p ${EASYBUILD_BUILDPATH}

eb --show-config

module avail 

echo "START INSTALL " 
eb -lr  --skip-test-step \
foss-2020b.eb \
SciPy-bundle-2020.11-foss-2020b.eb \
Ninja-1.10.1-GCCcore-10.2.0.eb \
PETSc-3.14.4-foss-2020b.eb \
PyYAML-5.3.1-GCCcore-10.2.0.eb \
HDF5-1.10.7-gompi-2020b.eb \
h5py-3.1.0-foss-2020b.eb \
netCDF-4.7.4-gompi-2020b.eb \
netCDF-Fortran-4.5.3-gompi-2020b.eb \
netCDF-C++4-4.3.1-gompi-2020b.eb \
netcdf4-python-1.5.7-foss-2020b.eb \
MDSplus-7.131.5-foss-2020b.eb  \
lxml-4.6.2-GCCcore-10.2.0.eb \
Java-13.eb \
Saxon-HE-9.9.1.7-Java-13.eb \
JupyterLab-3.0.16-GCCcore-10.2.0.eb \
dask-2021.2.0-foss-2020b.eb \
matplotlib-3.3.3-foss-2020b.eb \
sympy-1.7.1-foss-2020b.eb \
scikit-image-0.18.1-foss-2020b.eb \
networkx-2.5-foss-2020b.eb \
Doxygen-1.8.20-GCCcore-10.2.0.eb \
Pandoc-2.13.eb 

echo "END INSTALL " 

# module avail >> ${FY_ROOT}/foss-2020b.log 

# MDSplus-7.96.12-GCCcore-10.2.0.eb \
# MDSplus-Java-7.96.12-GCCcore-10.2.0-Java-13.eb \
# MDSplus-Python-7.96.12-foss-2020b-Python-3.8.6.eb \

# >> ${FY_ROOT}/foss-2020b.log 

# eb -Dr ${PKGS} >> ${FY_ROOT}/foss-2020b.log 

# JupyterHub-1.1.0-GCCcore-10.2.0.eb \
# PyQt5-5.15.1-GCCcore-10.2.0.eb \
# PyQtGraph-0.11.1-foss-2020b.eb \
# Saxon-HE-9.9.1.7-Java-13.eb
