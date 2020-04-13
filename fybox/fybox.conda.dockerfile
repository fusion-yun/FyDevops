FROM registry.cn-hangzhou.aliyuncs.com/fusionyun/fydev:2019 

ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}
ARG PKG_DIR=${PKG_DIR:-/packages}
ENV PKG_DIR=${PKG_DIR}

USER root
RUN  echo "exclude=*.i386 *.i686" >> /etc/yum.conf   
#     &&  yum update -y -q \
#     &&  yum clean all -y -q

USER ${FYDEV_USER}

ENV CONDA_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/anaconda
ENV CONDA_DIR=${PKG_DIR}/software/conda

# --mount=type=cache,uid=1000,id=fy_pkgs,target=/eb_repos,sharing=shared \
RUN uname -a \
    # install conda with China mirror
    && curl -L ${CONDA_MIRROR}/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ${PKG_DIR}/sources/miniconda3.sh  \
    && /usr/bin/bash ${PKG_DIR}/sources/miniconda3.sh  -b -p ${CONDA_DIR} \
    && ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/main \
    && ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/free \
    && ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/r \
    && ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/pkgs/pro \
    && ${CONDA_DIR}/bin/conda config --add channels ${CONDA_MIRROR}/cloud/conda-forge \
    && ${CONDA_DIR}/bin/conda config --remove channels defaults \
    && ${CONDA_DIR}/bin/conda config --set show_channel_urls yes \
    && ${CONDA_DIR}/bin/conda update -n base -c defaults conda  \
    ##############################################################################
    # add pip mirror
    && ${CONDA_DIR}/bin/pip config set global.index-url  https://mirrors.aliyun.com/pypi/simple/ \
    && ${CONDA_DIR}/bin/pip install --upgrade pip 


RUN ${CONDA_DIR}/bin/conda install --quiet --yes \    
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
    nodejs 

ENV PATH ${CONDA_DIR}/bin:$PATH

RUN uname -a \
    # Activate ipywidgets extension in the environment that runs the notebook server
    && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager@^2.0.0 --no-build \
    && jupyter labextension install @bokeh/jupyter_bokeh@^2.0.0 --no-build \
    && jupyter labextension install jupyter-matplotlib@^0.7.2 --no-build  \
    && jupyter lab build  \
    && jupyter lab clean 



RUN mkdir -p /home/${FYDEV_USER}/.local/share/fonts/otf \
    && cd /home/${FYDEV_USER}/.local/share/fonts/otf \
    && curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Regular.otf \
    && curl -LO https://github.com/googlefonts/noto-cjk/raw/master/NotoSansCJKsc-Bold.otf \
    && fc-cache -fv


ENV PYTHONPATH=${PKG_DIR}/software/lmod/lmod/init:$PYTHONPATH
ENV XDG_CACHE_HOME /home/${FYDEV_USER}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

EXPOSE  8888

ENTRYPOINT  ["/bin/bash","-c"]
##########################################3
# Usage:
# - load jupyter
# docker run -p 8888:8888 --name fybox fydev:2019c "source /packages/software/lmod/lmod/init/bash ; module load IMAS; jupyter lab --ip=0.0.0.0 "  
