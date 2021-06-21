## Create A Python Enviroment with All Packages Installed on EMR

### Prerequisite

[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

### Add a package

- `make deploy` to start the docker image
- edit `pyproject.yaml` and add the package
- `make exec-make` to create the `dev-packages.tar.gz`
- On EMR as user hadoop, `tar zxvf dev-packages.tar.gz`
