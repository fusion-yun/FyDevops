#!/usr/bin/bash
IMG_NAME=imas_3_24_0_ual_4_2_0
docker build --progress=plain --ssh=default --rm -f "dockerfiles/imas.dockerfile" -t imas:3_24_0_ual_4_2_0 . >> build_${IMG_NAME}.log 2>&1  & # redirect stderr to log file
echo $! >build_${IMG_NAME}.pid # save pid


###
# save image to tar.gz
docker save myimage:latest | gzip > myimage_latest.tar.gz
