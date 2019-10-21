#!/bin/bash
DOCKER_BUILDKIT=1 docker build -ssh --rm -f dockerfiles/imas.dockerfile -t imas:2018b .  
