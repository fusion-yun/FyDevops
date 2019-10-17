FROM fy2018b:latest

ARG EB_ARGS=" --use-existing-modules -rl"

ARG TOOLCHAIN_NAME=foss
ARG TOOLCHAIN_VERSION=2018b
ARG TOOLCHAIN=${TOOLCHAIN_NAME}-${TOOLCHAIN_VERSION}

ARG PYTHON_VERSION=3.6.6
ARG GCC_VERSION=7.3.0

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb --software-name=CMake --toolchain=GCCcore,7.3.0  ${EB_ARGS}  

WORKDIR /home/${FYDEV_USER}
USER ${FYDEV_USER}
RUN mkdir -p ebfiles
COPY ./ebfiles/*.eb ./ebfiles/

RUN source /etc/profile.d/lmod.bash  && module load EasyBuild/${EASYBUILD_VERSION} &&\   
    eb ./ebfiles ${EB_ARGS}  &&\   
    rm -rf ebfiles
