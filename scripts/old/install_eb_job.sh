# use $HOME/easybuild for software, modules, sources, etc.
export EASYBUILD_PREFIX=$FUYUN_DIR

# use ramdisk for build directories
# export EASYBUILD_BUILDPATH=/dev/shm/$USER

# use Slurm as job backend
export EASYBUILD_JOB_BACKEND=Slurm

export SBATCH_PARTITION=hfactest


eb  --tmp-logdir $HOME/eb_tmplogs  --job --job-cores 20 --robot --trace \
    foss-2020b.eb \
    Python-3.8.6-GCCcore-10.2.0.eb  JupyterLab-2.2.8-GCCcore-10.2.0.eb  SciPy-bundle-2020.11-foss-2020b.eb \
    HDF5-1.10.7-gompi-2020b.eb netCDF-4.7.4-gompi-2020b.eb netCDF-Fortran-4.5.3-gompi-2020b.eb netCDF-C++4-4.3.1-gompi-2020b.eb \
    h5py-3.1.0-foss-2020b.eb \
    PETSc-3.14.4-foss-2020b.eb

eb  --tmp-logdir $HOME/eb_tmplogs  --job --job-cores 20 --robot --trace foss-2020b.eb

squeue -u $USER -la