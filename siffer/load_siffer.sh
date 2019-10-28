#!/bin/bash
PWD=`pwd`

docker run -h siffer --rm -it \
        -v /packages/software/MATLAB/:/packages/software/MATLAB:ro \
        -v ${PWD}/ebfiles:/home/fydev/ebfiles \
        -v ${PWD}/sources:/home/fydev/sources \
        -v /home/salmon/workspace:/workspace \
        fybox_matlab_dev:latest