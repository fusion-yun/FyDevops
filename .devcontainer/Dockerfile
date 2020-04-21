FROM fybase:centos_8

ENV FYDEV_USER fydev
# Copy environment.yml (if found) to a temp locaition so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
# COPY ../environment.yml*  ../requirements.txt*  noop.txt /home/${FYDEV_USER}/tmp/


# RUN  conda install pylint pytest unittest2 autopep8
# Configure apt and install packages
RUN uname -a \
    # && if [ -f "/home/${FYDEV_USER}/tmp/environment.yml" ]; then /opt/conda/bin/conda env update -n base -f /home/${FYDEV_USER}/tmp/environment.yml; fi \
    # && if [ -f "/home/${FYDEV_USER}/tmp/requirements.txt" ]; then /opt/conda/bin/pip install -i https://mirrors.aliyun.com/pypi/simple/ -r /home/${FYDEV_USER}/tmp/requirements.txt; fi \
    # # Clean up
    # && rm -rf /home/${FYDEV_USER}/tmp/conda-tmp \
    ##############################################################################
    #  cache extensions
    &&  mkdir -p /home/${FYDEV_USER}/.vscode-server/extensions


# ENTRYPOINT [ "/bin/bash","-c" ]
