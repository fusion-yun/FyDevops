###  FyDevops——面向集成建模软件集的基础工作环境的初始化工具集
#### 目的
- 该工具集的目的是提供基础工作环境，为实现磁约束聚变研究中的集成建模软件集合在不同站上的管理和分发。

#### 特点：
- 从可重现性的角度， 首先要保持基础软件环境的一致性，脚本化是基础，提高自动化的可靠性；
- 启动不同站点的虚拟化环境，支持多个站点上的软件环境同步；
#### 功能
- 启动兼容层的虚拟环境，如：
    - centos
        - 7
        - 8
    - ubutun
- 自动搭建基础包管理工具（如easybuild）:
    - ./scripts/fy_bootstrap.sh
#### 用法:
##### build base image

```bash
docker build --build-arg FY_UID=$(id -u) --build-arg FY_GID=$(id -g)  -t fybase:ubuntu.focal .
```

##### mount volume

```bash
docker run --rm -it \
--mount type=bind,source=/gpfs/fuyun_repos/ubuntu/focal/,target=/fuyun \
--mount type=bind,source=/gpfs/fuyun_sources/,target=/fuyun/sources,readonly \
fybase:ubuntu.focal
```

```bash
sudo groupadd -g 504 develop
sudo usermod -g develop fuyun

source ${EASYBUILD_PREFIX}/software/lmod/lmod/init/bash
module use ${EASYBUILD_PREFIX}/modules/all/

export EASYBUILD_PREFIX=/fuyun
export EASYBUILD_ROBOT_PATHS=/fuyun/sources/ebfiles/FyDevOps/easybuild/easyconfigs/:/fuyun/sources/ebfiles/imas_ebs/easybuild/easyconfigs/:/fuyun/sources/ebfiles/easybuild-easyconfigs/:$EBROOTEASYBUILD/easybuild/easyconfigs
export EASYBUILD_BUILDPATH=/tmp/eb_build_${USERID}

```
##### build EasyBuild in docker
```bash
bash ./scripts/fy_bootstrap.sh
```
##### deploy research sofware in docker 
- Refer to the method described in the FyBuild repository(https://github.com/Fusion-FyDev/FyBuild)

##### rsync the result to destination site
```bash
sh ./scripts/scripts/rsync_to_site.sh
```