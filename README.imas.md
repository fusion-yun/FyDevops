# IMAS-foss-2019b

    The EasyBuild files included in this directory are used to build IMAS with the foss-2019b toolchain.
 

# Packages:   

    UDA     2.3.0
    IMAS    3.28.1-4.7.2
    FC2K    4.10.1

# Dependences:
## Modules
    EasyBuild   4.2.0 (recommend)
    foss        2019b
    Java        1.8 
    ant         1.10.7  
    Saxon-HE    9.9.1.5-Java-1.8
    Doxygen     1.8.16
    Python      3.7.4
    Boost       1.71.0
    Blitz++     1.0.2
    HDF5        1.10.5
    netCDF      4.7.1
    MDSplus     7.96.12
    libMemcached 1.0.18 

## System dependences
    texlive             # for imas document
    texlive-epstopdf    # for imas document

# Patch
    
- easybuild/easyconfigs/u/uda/uda-2.3.0-rpc.patch
    - rpc has been removed from glibc in Centos 8, using libtirpc replace it;
    - add compile flags for libtirpc to *.pc files
    - old type conversion syntex cause g++ compiler error, change to reinterpret_cast<>

# Scripts

 download source codes and run ebfiles  


     $bash ./scripts/build_all.sh
