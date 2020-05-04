# syntax=docker/dockerfile:experimental

FROM alpine:latest

# USER fydev:fydev

RUN --mount=type=cache,uid=1000,gid=1000,id=fycache,target=/tmp/cache,sharing=shared \        
    mkdir -p /fuyun/sources && \
    cp -r /tmp/cache/* /fuyun/sources/ &&\
    ls -lh /fuyun/sources
    

# FROM fylab:b106610-dirty_fix
# RUN --mount=type=cache,uid=1000,id=fycache,target=/cache,sharing=shared \        
#     cp -r /fuyun/* /cache/ && ls -lh  /cache

        
    
    

    # cp -r /fuyun/sources /fycache/
    # for _name in b  bootstrap  f  g  generic  h  i  j  l  m  n  o  p  s   t  u  x  z; do \
    #     cp -r /fuyun/sources/${_name} /fycache/sources ;\
    # done ;\
    # for _name in compiler  data  devel    math  mpi  numlib    toolchain ; do \
    # cp -r /fuyun/modules/${_name}   /fycache/centos_8/modules/${_name}  ; \
    # done ; \
    # mkdir -p /fycache/centos_8/modules/lang ; \
    # for _name in Java Perl Bison flex ; do \
    # cp -r /fuyun/modules/lang/${_name} /fycache/centos_8/modules/lang/${_name} ;\
    # done ; \
    # mkdir -p /fycache/centos_8/modules/lib ; \
    # for _name in Blitz++  libreadline    libtool  libxml2  libyaml  zlib ; do \
    # cp -r /fuyun/modules/lib/${_name} /fycache/centos_8/modules/lib/${_name} ;\
    # done ; \
    # mkdir -p /fycache/centos_8/modules/tools ; \
    # for _name in EasyBuild      Ninja  Szip  XZ  binutils  bzip2  cURL  expat  gettext  git  help2man  libMemcached  numactl  util-linux ; do \
    # cp -r /fuyun/modules/tools/${_name} /fycache/centos_8/modules/tools/${_name} ;\
    # done ; \
    # mkdir -p /fycache/centos_8/modules/system ; \
    # for _name in hwloc libpciaccess; do \
    # cp -r /fuyun/modules/system/${_name} /fycache/centos_8/modules/system/${_name} ;\
    # done ; \
    # for _name in gompi  \
    #  hwloc libpciaccess \
    # Autoconf  Automake  Autotools  Bison  "Blitz++" \
    # CMake  Doxygen  EasyBuild  FFTW   GCC  GCCcore  GMP \
    # HDF5     Java   M4  MDSplus  Ninja  OpenBLAS  OpenMPI  \
    # Perl  PostgreSQL   SQLite  Saxon-HE  ScaLAPACK   Szip  XZ \  
    # ant  binutils   bzip2  cURL  expat  flex      gettext    git  \
    # gperf   help2man     intltool  libMemcached    libreadline   libtool  libxml2  \
    # ncurses  netCDF-C++4  netCDF-Fortran  netCDF  numactl  pkg-config  util-linux    zlib ;  do \
    # cp -r /fuyun/modules/all/${_name}   /fycache/centos_8/modules/all/${_name}  ; \
    # cp -r /fuyun/ebfiles_repo/${_name}   /fycache/centos_8/ebfiles_repo/${_name} ; \
    # cp -r /fuyun/software/${_name}   /fycache/centos_8/software/${_name}  ; \
    # done ; \
    # for _name in lmod lua ;do \
    #     cp -r /fuyun/software/${_name}   /fycache/centos_8/software/${_name}  ; \
    # done ;\    
    # ls /fycache/centos_8/software