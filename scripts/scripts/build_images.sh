#!/bin/bash
# create IMAS docker image

TOOLCHAIN="foss-2019b"
IMAS_VERSION="3.28.1_4.7.2"

BUILD_DIR=$(cd "$(dirname "$0")/../"; pwd)
BUILD_TAG=v${IMAS_VERSION}_$(git describe --dirty --always --tags)


BASE_TAG=fydev:latest
FYDEV_USER=fydev

echo "=======  Build IMAS  [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "  

docker buildx build --progress=plain --rm  -t fy_imas:${BUILD_TAG}  \
     -f- ${BUILD_DIR} <<EOF
#syntax=docker/dockerfile:experimental
FROM ${BASE_TAG}
USER ${FYDEV_USER}
COPY --chown=${FYDEV_USER}:${FYDEV_USER} sources/ /tmp/ebsources
COPY --chown=${FYDEV_USER}:${FYDEV_USER} easybuild /tmp/easybuild

RUN sudo yum install -y texlive texlive-epstopdf  

RUN source /etc/profile.d/modules.sh     && \ 
    module load EasyBuild/${FY_EB_VERSION} && \    
    eb --robot-paths=/tmp/easybuild/easyconfigs:\$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --sourcepath=/tmp/ebsources:\$EASYBUILD_PREFIX/sources/ \
    --minimal-toolchain --use-existing-modules --info   -l  -r \
    IMAS-${IMAS_VERSION}-${TOOLCHAIN}.eb && \
    rm -rf /tmp/ebsources && \
    rm -rf /tmp/easybuild 

ARG BUILD_TAG=${BUILD_TAG}
LABEL Description   "IMAS Actors  (IMAS:${IMAS_VERSION}, UDA:${UDA_VERSION} build:${BUILD_TAG}) "
LABEL Name          "IMAS Actors"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
EOF

docker tag fy_imas:${BUILD_TAG}  fy_imas:latest

echo "======= Done [" ${BUILD_TAG} "]============ "

echo "=======  Build IMAS actors [" $(date +"%Y%m%d") ${BUILD_TAG} "] ============ "  

docker buildx build --progress=plain --rm  -t fy_imas_devs:${BUILD_TAG}  \
     -f- ${BUILD_DIR} <<EOF
#syntax=docker/dockerfile:experimental
FROM fy_imas:${BUILD_TAG}
USER ${FYDEV_USER}
COPY --chown=${FYDEV_USER}:${FYDEV_USER} sources/ /tmp/ebsources
COPY --chown=${FYDEV_USER}:${FYDEV_USER} easybuild /tmp/easybuild

RUN sudo yum install -y libX11-devel 

RUN source /etc/profile.d/modules.sh     && \ 
    module load EasyBuild/${FY_EB_VERSION} && \    
    eb --robot-paths=/tmp/easybuild/easyconfigs:\$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --sourcepath=/tmp/ebsources:\$EASYBUILD_PREFIX/sources \
    --minimal-toolchain --use-existing-modules --info   -l  -r \
    IMAS_devs-${IMAS_VERSION}-${TOOLCHAIN}.eb   && \
    rm -rf /tmp/ebsources && \
    rm -rf /tmp/easybuild 

ARG BUILD_TAG=${BUILD_TAG}
LABEL Description   "IMAS Devs  (IMAS:${IMAS_VERSION}, UDA:${UDA_VERSION} , build:${BUILD_TAG}) "
LABEL Name          "IMAS Devs"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
EOF


docker tag fy_imas_devs:${BUILD_TAG} fy_imas_devs:latest  

docker buildx build --progress=plain --rm  -t fy_imas_actors:${BUILD_TAG}  \
     -f- ${BUILD_DIR} <<EOF
#syntax=docker/dockerfile:experimental
FROM fy_imas_devs:${BUILD_TAG}
USER ${FYDEV_USER}
COPY --chown=${FYDEV_USER}:${FYDEV_USER} sources/ /tmp/ebsources
COPY --chown=${FYDEV_USER}:${FYDEV_USER} easybuild /tmp/easybuild

RUN source /etc/profile.d/modules.sh     && \ 
    module load EasyBuild/${FY_EB_VERSION} && \    
    eb --robot-paths=/tmp/easybuild/easyconfigs:\$EBROOTEASYBUILD/easybuild/easyconfigs  \
    --sourcepath=/tmp/ebsources:\$EASYBUILD_PREFIX/sources \
    --minimal-toolchain --use-existing-modules --info   -l  -r \
    IMAS_actors-${IMAS_VERSION}-${TOOLCHAIN}.eb   && \
    rm -rf /tmp/ebsources && \
    rm -rf /tmp/easybuild 

ARG BUILD_TAG=${BUILD_TAG}
LABEL Description   "IMAS Actors  (IMAS:${IMAS_VERSION}, UDA:${UDA_VERSION} build:${BUILD_TAG}) "
LABEL Name          "IMAS Actors"
LABEL Author        "salmon <yuzhi@ipp.ac.cn>"
EOF

docker tag fy_imas_actors:${BUILD_TAG} fy_imas_actors:latest  




echo "======= Done [" ${BUILD_TAG} "]============ "
