ARG BASE_OS=${BASE_OS:-fuyun:bare-centos7}
FROM ${BASE_OS}

COPY archive /tmp/archive 

RUN yum install -y /tmp/archive/*.rpm \
    && yum clean all -y -q  \
    && rm -rf /tmp/archive


