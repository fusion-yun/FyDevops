#!/bin/bash
PWD=`pwd`
docker run -it \
       --name=fybox \
       -v ~/.ssh:/home/fydev/.ssh:ro \
       -v ${PWD}/install_sources:/home/fydev/install_sources:ro \
       -v ${PWD}/ebfiles:/home/fydev/ebfiles:ro \
       -v ${PWD}/sources:/packages/sources:rw \
       fybox:2018b