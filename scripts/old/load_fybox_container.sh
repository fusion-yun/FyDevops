#!/bin/bash
PWD=`pwd`
docker run -h imas -it \
       --name=imas \
       -v ${PWD}/ebfiles:/home/fydev/ebfiles:rw \
       -v ${HOME}/workspace:/home/fydev/workspace:rw \
       imas:2018b

    #           -v ~/.ssh:/home/fydev/.ssh:ro \
    #    -v /packages/sources:/packages/sources:rw \
