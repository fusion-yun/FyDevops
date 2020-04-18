#!/bin/bash
# git clone git://github.com/docker/buildx && cd buildx
# make install
# try aliyun mirror "https://<????>.mirror.aliyuncs.com",
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [ 
                        "https://docker.mirrors.ustc.edu.cn"],
  "experimental": true
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker


export DOCKER_BUILDKIT=1
git clone  git://github.com/docker/buildx && cd buildx
make install 