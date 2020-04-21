ARG FYDEV_TAG={$FYDEV_TAG:-latest}

FROM fydev:${FYDEV_TAG} 

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}


USER ${FYDEV_USER}
CONDA_MIRROR

RUN source ${FUYUN_DIR}/software/lmod/lmod/init/profile ; \
    module avail ; \
    module load Miniconda3 ; \
    conda config --add channels ${CONDA_MIRROR}/pkgs/main ; \
    conda config --add channels ${CONDA_MIRROR}/pkgs/free ; \
    conda config --add channels ${CONDA_MIRROR}/pkgs/r ; \
    conda config --add channels ${CONDA_MIRROR}/pkgs/pro ; \
    conda config --add channels ${CONDA_MIRROR}/cloud/conda-forge ; \
    conda config --remove channels defaults ; \
    conda config --set show_channel_urls yes ; \
    conda update -n base -c defaults conda    ; \
    ##############################################################################
    # add pip mirror
    pip config set global.index-url  https://mirrors.aliyun.com/pypi/simple/ ; \
    pip install --upgrade pip ; \
    conda install --quiet --yes \
    'notebook=6.0.3' \
    'jupyterhub=1.1.0' \
    'jupyterlab=2.0.1' \
    'beautifulsoup4=4.8.*' \
    'blas=*=openblas' \
    'bokeh=1.4.*' \
    'cloudpickle=1.3.*' \
    'cython=0.29.*' \
    'dask=2.11.*' \
    'dill=0.3.*' \
    'h5py=2.10.*' \
    'hdf5=1.10.*' \
    'ipywidgets=7.5.*' \
    'ipympl=0.5.*'\
    'matplotlib-base=3.1.*' \
    'numba=0.48.*' \
    'numexpr=2.7.*' \
    'pandas=1.0.*' \
    'patsy=0.5.*' \
    'protobuf=3.11.*' \
    'scikit-image=0.16.*' \
    'scikit-learn=0.22.*' \
    'scipy=1.4.*' \
    'seaborn=0.10.*' \
    'sqlalchemy=1.3.*' \
    'statsmodels=0.11.*' \
    'sympy=1.5.*' \
    'vincent=0.4.*' \
    'widgetsnbextension=3.5.*'\
    'xlrd' \
    netcdf4 \
    pyyaml \
    jsonschema \
    f90nml \
    requests \
    NetworkX \
    python-graphviz \
    nodejs   ; \
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

ENV LMOD_DIR=${PKG_DIR}/software/lmod/lmod
ENV PYTHONPATH=${PKG_DIR}/software/lmod/lmod/init:$PYTHONPATH
ENV XDG_CACHE_HOME=/home/${FYDEV_USER}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

EXPOSE  8888

ENTRYPOINT  ["/bin/bash","-c"]
##########################################3
# Usage:
# - load jupyter
# docker run --rm -p 8889:8888/tcp fydev:2019c "source \${LMOD_DIR}/init/bash ; module load IMAS; module unload Python ; jupyter lab --ip=\$(hostname -i) --no-browser"