# syntax=docker/dockerfile:experimental

ARG BASE_VERSION=latest

FROM fybox_base:${BASE_VERSION}

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2017a
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

LABEL Description   "Toolchain ${TOOLCHAIN}"
LABEL Name          "fybox_toolchain"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
LABEL Description   "toolchain and packages "

################################################################################
# INSTALL packages

ENV PKG_DIR=/packages

ARG EB_ARGS=" --use-existing-modules --info -l -r"

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${FY_EB_VERSION} &&\
    eb ${TOOLCHAIN}.eb ${EB_ARGS}  


# Java 
ARG JAVA_VERSION=13.0.1

RUN --mount=type=bind,target=sources,source=sources  --mount=type=bind,target=ebfiles,source=ebfiles \
    source /etc/profile.d/lmod.bash  && module load EasyBuild &&\
    export _EB_ARGS=" --robot-paths=ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs --sourcepath=$EASYBUILD_PREFIX/sources/:sources ${EB_ARGS}"  &&\
    eb --software=Java,${JAVA_VERSION} --toolchain-name=system ${_EB_ARGS}  

ARG GCC_VERSION=6.3.0 

ARG MATLAB_VERSION="2017a"

RUN mkdir -p ${PKG_DIR}/modules/all/MATLAB/ && echo -e ""\
"help([==[\n"\
"Description\n"\
"===========\n"\
"MATLAB is a high-level language and interactive environment\n"\
" that enables you to perform computationally intensive tasks faster than with\n"\
" traditional programming languages such as C, C++, and Fortran.\"\n"\
"\n"\
"More information\n"\
"================\n"\
" - Homepage: http://www.mathworks.com/products/matlab\n"\
"]==])\n"\
"whatis([==[Description: MATLAB is a high-level language and interactive environment\n"\
" that enables you to perform computationally intensive tasks faster than with\n"\
" traditional programming languages such as C, C++, and Fortran.]==])\n"\
"whatis([==[Homepage: http://www.mathworks.com/products/matlab]==])\n"\
"whatis([==[URL: http://www.mathworks.com/products/matlab]==])\n"\
"local root = \"/packages/software/MATLAB/${MATLAB_VERSION}\"\n"\
"conflict(\"MATLAB\")\n"\
"if not ( isloaded(\"Java/${JAVA_VERSION}\") ) then\n"\
"    load(\"Java/${JAVA_VERSION}\")\n"\
"end\n"\
"if not ( isloaded(\"GCCcore/${GCC_VERSION}\") ) then\n"\
"    load(\"GCCcore/${GCC_VERSION}\")\n"\
"end\n"\
"prepend_path(\"PATH\", pathJoin(root, \"bin\"))\n"\
"setenv(\"EBROOTMATLAB\", root)\n"\
"setenv(\"EBVERSIONMATLAB\", \"${MATLAB_VERSION}\")\n"\
"setenv(\"EBDEVELMATLAB\", pathJoin(root, \"easybuild/MATLAB-R2019b-easybuild-devel\"))\n"\
"prepend_path(\"PATH\", root)\n"\
"setenv(\"_JAVA_OPTIONS\", \"-Xmx256m\")\n"\
"setenv(\"LM_LICENSE_FILE\", \"202.127.204.4:25030\") \n"\
"-- Built with EasyBuild version 4.0.1\n "\
>> ${PKG_DIR}/modules/all/MATLAB/${MATLAB_VERSION}.lua