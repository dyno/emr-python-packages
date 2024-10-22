## Create A Python Enviroment with All Packages Installed for EMR

### Prerequisite

[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

### Create dev-packages.tar.gz

- add a package edit `pyproject.toml` OR `uv add <package>`

- build the package on local machine

```bash
make build-image   DOCKER_DEFAULT_PLATFORM=linux/amd64
make build-package DOCKER_DEFAULT_PLATFORM=linux/amd64
# OR
make build-image   DOCKER_DEFAULT_PLATFORM=linux/arm64
make build-package DOCKER_DEFAULT_PLATFORM=linux/arm64
```

- On EMR as user `hadoop`

```bash
tar zxvf dev-packages-py311-amd64.tar.gz
# OR
tar zxvf dev-packages-py311-arm64.tar.gz
```
