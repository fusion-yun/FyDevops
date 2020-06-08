FROM fydev:latest


ENV FYDEV_USER fydev
ARG FYDEV_USER=${FYDEV_USER:-fydev}
ENV FYDEV_USER=${FYDEV_USER}

ARG FYDEV_USER_ID=${FYDEV_USER_ID:-1000}
ENV FYDEV_USER_ID=${FYDEV_USER_ID}

# RUN apt-get install -y sudo

# RUN useradd -u ${FYDEV_USER_ID}  -d /home/${FYDEV_USER}  ${FYDEV_USER}  && \
#     echo "%${FYDEV_USER} ALL=(ALL)    NOPASSWD: ALL" >>/etc/sudoers

# Copy environment.yml (if found) to a temp locaition so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
# COPY ../environment.yml*  ../requirements.txt*  noop.txt /home/${FYDEV_USER}/tmp/

# USER ${FYDEV_USER} 

# RUN  conda install pylint pytest unittest2 autopep8
# Configure apt and install packages

# && if [ -f "/home/${FYDEV_USER}/tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /home/${FYDEV_USER}/tmp/environment.yml; fi \
# && if [ -f "/home/${FYDEV_USER}/tmp/requirements.txt" ]; then /opt/conda/bin/pip install -i https://mirrors.aliyun.com/pypi/simple/ -r /home/${FYDEV_USER}/tmp/requirements.txt; fi \
# # Clean up
# && rm -rf /home/${FYDEV_USER}/tmp/conda-tmp \
##############################################################################
#  cache extensions
USER ${FYDEV_USER}
RUN mkdir -p /home/${FYDEV_USER}/.vscode-server/extensions 
