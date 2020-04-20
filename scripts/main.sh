#!/bin/bash
# launch build script, catch log  and save pid to file

`pwd`/build_images.sh > /tmp/build_fydev_$(date +"%Y%m%d").log 2>&1 & echo $! > /tmp/build_fydev_$(date +"%Y%m%d").pid
