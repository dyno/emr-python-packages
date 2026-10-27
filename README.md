## Create A Python Enviroment with All Packages Installed for EMR

### Prerequisite

[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

### Create dev-packages.tar.gz

- add a package edit `pyproject.toml` OR `uv add <package>`

- build the package on local machine

```bash
# DOCKER_DEFAULT_PLATFORM in [linux/amd64, linux/arm64]
make build-image   DOCKER_DEFAULT_PLATFORM=linux/amd64
make build-package DOCKER_DEFAULT_PLATFORM=linux/amd64
```

- On the target host as user `hadoop`

```bash
tar zxvf dev-packages-py312-x86_64.tar.gz
```

- duckdb extensions `httpfs` and `aws` are baked into `~/.duckdb/extensions`
  (duckdb's default extension directory), so `LOAD httpfs;` / `LOAD aws;` work
  without downloading or uploading them.

### experiment with uv

```bash
make docker-run

# inside docker
cp /mnt/pyproject.py312.toml pyproject.toml
uv sync
```
