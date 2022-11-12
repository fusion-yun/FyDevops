#!/bin/bash
FYDEV_PREFIX=/gpfs/fydev

TARGET_TAG=${TARGET_TAG:-$1}
TARGET_IMAGE=${TARGET_IMAGE:-fydev:hfcube_support}
TARGET_FY_PREFIX=${TARGET_FY_PREFIX:-/public/share/physical_suport}

FY_REPO=/gpfs/fydev/repository/${TARGET_TAG}/fuyun

rsync -azvhe --exclude 'EasyBuild'  ${FY_REPO}/modules hfcube_support://${TARGET_FY_PREFIX}
rsync -avzhe 'ssh -o ServerAliveInterval=180' --log-file=rsync_software.log --exclude '*/easybuild' --exclude 'EasyBuild' --exclude ".locks" ${FY_REPO}/software hfcube_support://${TARGET_FY_PREFIX}