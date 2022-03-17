#!/bin/bash

sudo yum install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
CUDA_TAG=rhel8-10-2
if ! [ -f cuda-repo-${CUDA_TAG}.rpm ]
then 
    curl -L http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-rhel7-10-2-local-10.2.89-440.33.01-1.0-1.x86_64.rpm cuda-repo-rhel8-10-2.rpm cuda-repo-${CUDA_TAG}.rpm
fi
sudo rpm -i cuda-repo-${CUDA_TAG}.rpm
sudo yum clean all
sudo yum -y install nvidia-driver-latest-dkms cuda
sudo yum -y install cuda-drivers