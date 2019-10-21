#!/bin/bash
PWD=`pwd`
docker run -h fybox -it \
       --name=fybox \
       -v ~/.ssh:/home/fydev/.ssh:ro \
       -v ${PWD}/ebfiles:/home/fydev/ebfiles:ro \
       -v ${HOME}/workspace:/home/fydev/workspace:rw \
       -v /packages/sources:/packages/sources:rw \
       fybox:2018b