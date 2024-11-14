## Create A Python Enviroment with All Packages Installed for EMR

### Prerequisite

[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

### Create dev-packages.tar.gz

- add a package edit `pyproject.toml` OR `uv add <package>`

- build the package on local machine

```bash
# PY in [py37, py39, py311]
# DOCKER_DEFAULT_PLATFORM in [linux/amd64, linux/arm64]

# EMR 6.x
make build-image   PY=py37 DOCKER_DEFAULT_PLATFORM=linux/amd64
make build-package PY=py37 DOCKER_DEFAULT_PLATFORM=linux/amd64

# EMR 7.x
make build-image   PY=py39 DOCKER_DEFAULT_PLATFORM=linux/amd64
make build-package PY=py39 DOCKER_DEFAULT_PLATFORM=linux/amd64

make build-image   PY=py311 DOCKER_DEFAULT_PLATFORM=linux/amd64
make build-package PY=py311 DOCKER_DEFAULT_PLATFORM=linux/amd64
```

- On EMR as user `hadoop`

```bash
# EMR 6.x
tar zxvf dev-packages-py37-x86_64.tar.gz

# EMR 7.x
tar zxvf dev-packages-py311-x86_64.tar.gz
```

### experiment with uv

```bash
make PY=py39 docker-run

# inside docker
cp /mnt/pyproject.py39.toml pyproject.toml
uv sync
```
