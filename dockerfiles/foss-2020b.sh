#!/bin/bash
source /fuyun/software/lmod/lmod/init/bash
module use /fuyun/modules/all/
module load EasyBuild

PKGS=foss-2020b.eb \
SciPy-bundle-2020.11-foss-2020b.eb \
Ninja-1.10.1-GCCcore-10.2.0.eb \
PETSc-3.14.4-foss-2020b.eb \
HDF5-1.10.7-gompic-2020b.eb \
netCDF-4.7.4-gompic-2020b.eb \
netCDF-Fortran-4.5.3-gompic-2020b.eb \
netCDF-C++4-4.3.1-gompi-2020b.eb \
JupyterLab-3.0.16-GCCcore-10.2.0.eb 

eb -lr ${PKGS} >> /fuyun/foss-2020b.log 

# netcdf4-python-1.5.5.1-foss-2020b.eb \
# MDSplus-7.96.12-GCCcore-10.2.0.eb \
# MDSplus-Python-7.96.12-foss-2020b-Python-3.8.6.eb \
# MDSplus-Java-7.96.12-GCCcore-10.2.0-Java-13.eb \
# JupyterLab-3.0.16-GCCcore-10.2.0.eb \
# JupyterHub-1.1.0-GCCcore-10.2.0.eb \
# PyQt5-5.15.1-GCCcore-10.2.0.eb \
# PyQtGraph-0.11.1-foss-2020b.eb \
# Saxon-HE-9.9.1.7-Java-13.eb
