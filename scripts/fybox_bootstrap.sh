#!/bin/bash


for i in "$@"
do
case $i in
    -h|--help)
    SHOW_HELP="YES"
    ;;
    -c|--cache-only)
    CACHE_ONLY="YES"
    shift # past argument=value
    ;; 
    -f|--force|--rebuild)
    FORCE_REBUILD="YES"
    shift # past argument=value
    ;; 
    --default)
    DEFAULT=YES
    shift # past argument with no value
    ;;
    *)
        if [[ $i != -* ]]; then
                value=${1##*=}
                name=${1%%=*}            
                eval ${name}=$value
                shift # past argument=value
        fi
    ;;
esac
done

PWD=`pwd`

PKG_DIR=${PKG_DIR:-/packages}

INSTALL_DIR=${INSTALL_DIR:-${PKG_DIR}/software}
 
INSTALL_SOURCE_CACHE=${INSTALL_SOURCE_CACHE:${PWD}/sources}

BUILD_DIR=$(mktemp -d -t fybuild-XXXXXXXXXX)

ETC_DIR=${ETC_DIR:-${PKG_DIR}/etc}

MODULE_DIR=${MODULE_DIR:-${PKG_DIR}/modules}

LMOD_VERSION=${LMOD_VERSION:-8.1.18}

EASYBUILD_VERSION=${EASYBUILD_VERSION:-4.0.1}

CACHE_ONLY='NO'

PYTHON_EXE=${PYTHON_EXE:-python}

if [  "${SHOW_HELP}" = "YES" ]; then
echo "   
Usage: $0  [...OPTIONS]  <key=value>  
OPTIONS: 
    -h|--help           : show this message 
    -f|--force          : Force rebuild  
    -c|--cache-only     : Only cache sources (todo)

KEYS:
    PKG_DIR             : (${PKG_DIR}) 
    ETC_DIR             : (${ETC_DIR}) 
    MODULE_DIR          : (${MODULE_DIR}) 
    INSTALL_DIR         : (${INSTALL_DIR}) 
    INSTALL_SOURCE_CACHE: (${INSTALL_SOURCE_CACHE}) 
    BUILD_DIR           : (${BUILD_DIR}) 
    LMOD_VERSION        : (${LMOD_VERSION}) 
    EASYBUILD_VERSION   : (${EASYBUILD_VERSION}) 
    FORCE_REBUILD       : (${FORCE_REBUILD})
    "
exit
fi
ls ${INSTALL_SOURCE_CACHE}

function fetch_source {
    if [ -f ${INSTALL_SOURCE_CACHE}/$2 ]; then
        echo "Using cache ${INSTALL_SOURCE_CACHE}/${2}" 
    else
        curl -L $1 -o ${INSTALL_SOURCE_CACHE}/$2.tar.gz
        echo "Download from ${1} to  ${INSTALL_SOURCE_CACHE}/${2}.tar.gz"
    fi

  
}

function clean_build {
    
    cd ..
    if [ "${KEEP_BUILD}" = "NO" ]; then
        rm -rf $1
    fi

    if [ "${KEEP_CACHE}" = "NO" ]; then
        rm -rf ${INSTALL_SOURCE_CACHE}/$1.tar.gz 
    fi 
    echo "Successfully installed '${1}' "   
}



mkdir -m 755 -p ${INSTALL_DIR}
mkdir -m 755 -p ${INSTALL_SOURCE_CACHE}

echo "INSTALL_DIR=${INSTALL_DIR} INSTALL_SOURCE_CACHE=${INSTALL_SOURCE_CACHE} BUILD_DIR=${BUILD_DIR}"

echo "Entering directory ${BUILD_DIR}"

cd  ${BUILD_DIR}

############################
# Install lmod
 
curl -L https://github.com/TACC/Lmod/archive/${LMOD_VERSION}.tar.gz  -o  lmod-${LMOD_VERSION}.tar.gz 
curl -L  https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py -O
curl -L https://files.pythonhosted.org/packages/18/59/3274a58af6af84a87f7655735b452c06c769586ee73954f5ee15d303aa29/vsc-install-0.11.3.tar.gz -O
curl -L https://files.pythonhosted.org/packages/48/aa/f05d350c358338d0e843835660e3993cc5eb28401f32c0c5b8bc9a9458d5/vsc-base-2.8.4.tar.gz  -O
curl -L https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${EASYBUILD_VERSION}.tar.gz -O
curl -L https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${EASYBUILD_VERSION}.tar.gz  -O
curl -L https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${EASYBUILD_VERSION}.tar.gz  -O


    # curl -L https://github.com/TACC/Lmod/archive/${LMOD_VERSION}.tar.gz  -o  lmod-${LMOD_VERSION}.tar.gz &&\

############################
# Install Easybuild
# if [ -d ${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION} ] && [ "${FORCE_REBUILD}"!="YES" ]  ; then
#     echo "EasyBuild/${EASYBUILD_VERSION}  is  installed at ' ${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION} ', ignored."
# else
#     if [ -f ${INSTALL_SOURCE_CACHE}/bootstrap_eb.py ]; then
#         echo "Using cache '${INSTALL_SOURCE_CACHE}/bootstrap_eb.py'"
#     else
#         curl -L  https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py -o ${INSTALL_SOURCE_CACHE}/bootstrap_eb.py
#     fi

#     EASYBUILD_BOOTSTRAP_SKIP_STAGE0=1 EASYBUILD_BOOTSTRAP_SOURCEPATH=${INSTALL_SOURCE_CACHE} ${PYTHON_EXE}  ${INSTALL_SOURCE_CACHE}/bootstrap_eb.py ${INSTALL_DIR}
# fi

# echo "Leaving directory ${BUILD_DIR}"
# rm -rf ${BUILD_DIR}
# if [ -d ${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION} && ${FORCE_REBUILD}!="YES" ]; then
#     echo "WARNING: EasyBuild/${EASYBUILD_VERSION}  is  installed at ' ${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION} '."
# else
#     fetch_source https://github.com/easybuilders/easybuild-framework/archive/easybuild-framework-v${EASYBUILD_VERSION}.tar.gz  easybuild-framework-v${EASYBUILD_VERSION} 

#     source ${ETC_DIR}/profile.d/lmod.sh && pip3 install --install-option "--prefix=${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION}" . 

#     clean_build  easybuild-framework-v${EASYBUILD_VERSION} 


#     fetch_source https://github.com/easybuilders/easybuild-easyconfigs/archive/easybuild-easyconfigs-v${EASYBUILD_VERSION}.tar.gz   easybuild-easyconfigs-v${EASYBUILD_VERSION}

#     source ${ETC_DIR}/profile.d/lmod.sh &&  pip3 install --install-option "--prefix=${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION}"  . 

#     clean_build easybuild-easyconfigs-v${EASYBUILD_VERSION} 


#     fetch_source https://github.com/easybuilders/easybuild-easyblocks/archive/easybuild-easyblocks-v${EASYBUILD_VERSION}.tar.gz  easybuild-easyblocks-v${EASYBUILD_VERSION}

#     source ${ETC_DIR}/profile.d/lmod.sh &&  pip3 install --install-option "--prefix=${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION}"  .  

#     clean_build easybuild-easyblocks-v${EASYBUILD_VERSION} 

#     mkdir -m 755 -p ${ETC_DIR}/profile.d/

#     ln -s${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION}/bin/eb_bash_completion.bash ${ETC_DIR}/bash_completion.d/eb_bash_completion.bash 

#     ln -s${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION}/bin/optcomplete.bash ${ETC_DIR}/bash_completion.d/optcomplete.bash 

#     echo "complete -F _optcomplete eb" >>${INSTALL_DIR}/EasyBuild/${EASYBUILD_VERSION}/bin/optcomplete.bash 
# fi

# if [ -f ${MODULE_DIR}/all/EasyBuild/${EASYBUILD_VERSION}.lua && ${FORCE_REBUILD}!="YES" ]; then
#     echo "WARNING: modulefile EasyBuild  is  installed at ' ${MODULE_DIR}/all/EasyBuild/${EASYBUILD_VERSION}.lua '."
# else
#     echo "Writing modulefile to ${MODULE_DIR}/all/EasyBuild/${EASYBUILD_VERSION}.lua"

#     mkdir -m 755 -p ${MODULE_DIR}/all/EasyBuild/

#     PYTHON_SHORTVERSION=`python3 -c "import sys;print(f'{sys.version_info.major}.{sys.version_info.minor}')"`

    
#     echo " 
# help([==[   

# Description   
# ===========   
# EasyBuild is a software build and installation framework   
# written in Python that allows you to install software in a structured,   
# repeatable and robust way.   


# More information   
# ================   
# - Homepage: http://easybuilders.github.com/easybuild/   
# ]==])   

# whatis([==[Description: EasyBuild is a software build and installation framework   
# written in Python that allows you to install software in a structured,   
# repeatable and robust way.]==])   
# whatis([==[Homepage: http://easybuilders.github.com/easybuild/]==])   

# local root = \"${EASYBUILD_PREFIX}/software/EasyBuild/${EASYBUILD_VERSION}\"   

# conflict(\"EasyBuild\")   

# prepend_path(\"PATH\", pathJoin(root, \"bin\"))   
# setenv(\"EBROOTEASYBUILD\", root)   
# setenv(\"EBVERSIONEASYBUILD\", ${EASYBUILD_VERSION})   
# setenv(\"EBDEVELEASYBUILD\", pathJoin(root, \"easybuild/EasyBuild-${EASYBUILD_VERSION}-easybuild-devel\"))   

# prepend_path(\"PYTHONPATH\", pathJoin(root, \"lib/python${PYTHON_SHORTVERSION}/site-packages\"))   
# -- Built with EasyBuild version ${EASYBUILD_VERSION}-Python-${PYTHON_SHORTVERSION}
#     ">  ${MODULE_DIR}/all/EasyBuild/${EASYBUILD_VERSION}.lua
# fi

