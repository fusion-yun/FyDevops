# syntax=docker/dockerfile:experimental
ARG FYDEV_TAG=${FYDEV_TAG:-latest}
FROM fybase:${FYDEV_TAG} 


ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}
################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FYLAB_VERSION=${FYLAB_VERSION:-0.0.0}


RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \  
    sudo mkdir -p /tmp/cache/sources ; \ 
    sudo mkdir -p /tmp/cache/${FY_OS}_${FY_OS_VERSION} ; \
    sudo ln -sf /tmp/cache/sources   /tmp/cache/${FY_OS}_${FY_OS_VERSION}/sources ; \ 
    sudo ln -sf /tmp/cache/${FY_OS}_${FY_OS_VERSION}   ${FUYUN_DIR}  ; \
    sudo chown ${FYDEV_USER}:${FYDEV_USER} -R  ${FUYUN_DIR} 
 

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=./ \
    source /etc/profile.d/modules.sh ;\
    module load EasyBuild ; \    
    eb --info -lr \
    --use-existing-modules \
    --minimal-toolchain \
    --sourcepath=${FUYUN_DIR}/sources:/tmp/ebsources \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    /tmp/ebfiles/FyLab-${FYLAB_VERSION}.eb 

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    source /etc/profile.d/modules.sh ;\
    module use ${FUYUN_DIR}/modules/all ;\
    module load FyLab ; \
    # Activate ipywidgets extension in the environment that runs the notebook server
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter nbextension enable --py widgetsnbextension --sys-prefix ; \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build ; \
    jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build ;  \
    jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build ;  \
    jupyter lab build  ; \
    jupyter lab clean 


ENV XDG_CACHE_HOME=/home/${FYDEV_USER}/.cache/

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    source /etc/profile.d/modules.sh ;\
    module use ${FUYUN_DIR}/modules/all ;\
    module load Anaconda3; \
    MPLBACKEND=Agg python -c "import matplotlib.pyplot"

RUN --mount=type=cache,uid=1000,id=fycache,target=/tmp/cache,sharing=shared \
    if ! [ -z ${FUYUN_DIR}/sources/fonts/NotoSansCJKsc-Regular.otf ] ; then \    
    mkdir -p ${FUYUN_DIR}/sources/fonts/ ; \
    curl -L https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Regular.otf -o  ${FUYUN_DIR}/sources/fonts/NotoSansCJKsc-Regular.otf  ;\
    curl -L https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Bold.otf -o  ${FUYUN_DIR}/sources/fonts/NotoSansCJKsc-Bold.otf  ;\    
    fi ;\
    sudo mkdir -p /usr/share/fonts/otf ; \        
    sudo cp /usr/share/fonts/otf/* /usr/share/fonts/otf/;\
    sudo fc-cache -fv


# RUN rm /tmp/cache/sources 

# EXPOSE  8888

# ENTRYPOINT  ["/bin/bash","-c"]
