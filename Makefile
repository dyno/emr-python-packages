SHELL = /bin/bash

export DOCKER_DEFAULT_PLATFORM := linux/amd64
ARCH := $(shell sed -e 's@linux/@@' <<< "$(DOCKER_DEFAULT_PLATFORM)")

IMAGE := pyemr-amazonlinux:2023-$(ARCH)
CONTAINER := pyemr-amazonlinux-2023-$(ARCH)


.DEFAULT_GOAL := build-package

# ------------------------------------------------------------------------------

DOCKER_BUILD := docker buildx
BUILD_OPTS :=
build-image: docker-build
docker-build:
	$(DOCKER_BUILD) build $(BUILD_OPTS) --platform=$(DOCKER_DEFAULT_PLATFORM) -t $(IMAGE) .


CMD := /bin/bash
docker-run:
	docker run -it --rm --name $(CONTAINER) -v $(PWD):/mnt $(IMAGE) $(CMD)


build-package:
	$(MAKE) docker-run CMD="make -f /mnt/amazonlinux.mk tar-dev-packages"
