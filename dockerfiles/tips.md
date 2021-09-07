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
