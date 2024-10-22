## Create A Python Enviroment with All Packages Installed for EMR

### Prerequisite

[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

### Create dev-packages.tar.gz

- add a package edit `pyproject.toml` OR `uv add <package>`
- build the package `make build-package`
- On EMR as user hadoop, `tar zxvf dev-packages.tar.gz`
