# syntax=docker/dockerfile:experimental
ARG FYDEV_TAG=${FYDEV_TAG:-latest}
FROM fydev:${FYDEV_TAG} 

ARG FY_OS=${FY_OS:-centos}
ARG FY_OS_VERSION=${FY_OS_VERSION:-8}

################################################################################
# Add user for DevOps
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FUYUN_DIR=${FUYUN_DIR:-/fuyun}
ENV FUYUN_DIR=${FUYUN_DIR}

ARG FYLAB_VERSION=${FYLAB_VERSION:-${FYDEV_VERSION}}
ENV FYLAB_VERSION=${FYLAB_VERSION}

RUN --mount=type=cache,uid=1000,id=fycache,target=/fycache,sharing=shared \
    --mount=type=bind,target=/tmp/ebfiles,source=ebfiles \
    source /etc/profile.d/modules.sh ;\
    module use ${FUYUN_DIR}/modules/all ;\
    module avail ; \
    module load EasyBuild ; \    
    eb --info -r \
    --use-existing-modules \
    --minimal-toolchain \
    --sourcepath=${FUYUN_DIR}/sources:/tmp/sources \
    --robot-paths=/tmp/ebfiles:$EBROOTEASYBUILD/easybuild/easyconfigs  \
    /tmp/ebfiles/FyLab-${FYLAB_VERSION}.eb 



RUN source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
    module use ${FUYUN_DIR}/modules/all ; \
    module load Miniconda3 ; \
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



RUN mkdir -p /home/${FYDEV_USER}/.local/share/fonts/otf && \
    cd /home/${FYDEV_USER}/.local/share/fonts/otf ;\
    curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Regular.otf ;\
    curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Bold.otf ;\
    fc-cache -fv


ENV LMOD_DIR=${FUYUN_DIR}/software/lmod/lmod
ENV XDG_CACHE_HOME=/home/${FYDEV_USER}/.cache/

# ARG PYTHONPATH=${PYTHONPATH}
# ENV PYTHONPATH=${FUYUN_DIR}/software/lmod/lmod/init/:${PYTHONPATH}

# ARG MODULEPATH=${MODULEPATH}
# ENV MODULEPATH=${MODULEPATH}

RUN source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
    module use ${FUYUN_DIR}/modules/all ; \
    module load Miniconda3 ; \
    MPLBACKEND=Agg python -c "import matplotlib.pyplot"

EXPOSE  8888

ENTRYPOINT  ["/bin/bash","-c"]
