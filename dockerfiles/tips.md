# Tips

## build base image

```bash
docker build --build-arg FY_UID=$(id -u) --build-arg FY_GID=$(id -g)  -t fybase:ubuntu.focal .
```

## mount volume

```bash
docker run --rm -it \
--mount type=bind,source=/gpfs/fuyun_repos/ubuntu/focal/,target=/fuyun \
--mount type=bind,source=/gpfs/fuyun_sources/,target=/fuyun/sources,readonly \
fybase:ubuntu.focal
```

```bash
sudo groupadd -g 504 develop
sudo usermod -g develop fuyun

export EASYBUILD_PREFIX=/fuyun
export EASYBUILD_ROBOT_PATHS=/fuyun/sources/ebfiles/FyDevOps/easybuild/easyconfigs/:/fuyun/sources/ebfiles/imas_ebs/easybuild/easyconfigs/:/fuyun/sources/ebfiles/easybuild-easyconfigs/:$EBROOTEASYBUILD/easybuild/easyconfigs
export EASYBUILD_BUILDPATH=/tmp/eb_build
source /fuyun/software/lmod/lmod/init/bash
module use /fuyun/modules/all/

```