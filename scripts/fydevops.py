#!/usr/bin/env python3
########################
#
#
# 
########################

from optparse import OptionParser

# FYDEV_ROOT=${FYDEV_ROOT:-/gpfs/fydev}
# FYDEV_DEVOPS=${FYDEV_DEVOPS:-${FYDEV_ROOT}/devops}

# FYDEV_GID=${FYDEV_GID:-504}
# FYDEV_GROUP=${FYDEV_GROUP:-develop}

# TARGET=${TARGET:-$@}
# TARGET=${TARGET//./\/}

# TARGET_OS=${TARGET_OS:-centos.7}
# TARGET_OS=${TARGET_OS//./\/}

def initialize(TARGET,TARGET_OS):
    """
        initialize a FyYun repository

        - step 0: create repository diretories
        - step 1: create docker image
        - step 2: install lua, LMod, EasyBuild


    """
    
    # cd ${FYDEV_DEVOPS}/dockerfiles/${TARGET_OS}

    # FY_USER=${FY_USER:-physical_suport}
    # FY_UID=${FY_UID:-11048}
    # FY_GID=${FY_GID:-11181}
    # FY_HOME=${FY_HOME:-/public/home/} 
    # FY_PREFIX=${FY_PREFIX:-/public/share/physical_suport}

    # docker build   \
    #     --build-arg FY_LOCAL_GID=${FYDEV_GID}         \
    #     --build-arg FY_LOCAL_GROUP=${FYDEV_GROUP}     \
    #     --build-arg FY_USER=${FY_USER}                \
    #     --build-arg FY_UID=${FY_UID}                  \
    #     --build-arg FY_GID=${FY_GID}                  \
    #     --build-arg FY_HOME=${FY_HOME}                \
    #     --build-arg FY_PREFIX=${FY_PREFIX}            \
    #     -t fydev/${TARGET}/${TARGET_OS} .


    # FYDEV_SOFTWARE=${FYDEV_REPOSITORY:-${FYDEV_ROOT}/repository/${TARGET}/fuyun/software}

    # mkdir -p ${FYDEV_SOFTWARE}/scripts

    # cp ${FYDEV_DEVOPS}/scripts/fy_profile.sh ${FYDEV_SOFTWARE}/scripts/
    pass

def load_image(TARGET_TAG):

    # TARGET_TAG=${TARGET_TAG:-ubuntu/focal}
    # TARGET_IMAGE=${TARGET_IMAGE:-fydev:ubuntu.focal}
    # TARGET_FY_PREFIX=${TARGET_FY_PREFIX:-/fuyun}
    # TARGET_USER=${TARGET_USER:-fuyun}
    
    # echo "TARGET_TAG=${TARGET_TAG}"
    # echo "TARGET_IMAGE=${TARGET_IMAGE}"
    # echo "TARGET_FY_PREFIX=${TARGET_FY_PREFIX}"
    
    # FYDEV_PREFIX=/gpfs/fuyun_
    
    # docker run  --rm --user ${TARGET_USER} -it \
    #     --mount type=bind,source=${FYDEV_PREFIX}repos/${TARGET_TAG}/fuyun,target=${TARGET_FY_PREFIX} \
    #     --mount type=bind,source=${FYDEV_PREFIX}sources/,target=${TARGET_FY_PREFIX}/sources \
    # ${TARGET_IMAGE} 
    pass

if __name__ == "__main__":
    parser = OptionParser()
    parser.add_option("-f", "--file", dest="filename",
                    help="write report to FILE", metavar="FILE")
    parser.add_option("-q", "--quiet",
                    action="store_false", dest="verbose", default=True,
                    help="don't print status messages to stdout")

    (options, args) = parser.parse_args()
    
    