SHELL = /bin/bash

export DOCKER_DEFAULT_PLATFORM := linux/amd64
ARCH := $(shell sed -e 's@linux/@@' <<< "$(DOCKER_DEFAULT_PLATFORM)")

PY := py311
ifeq ($(PY),py311)
AL_TAG := 2023
AL_PY := python3.11
else ifeq ($(PY),py39)
AL_TAG := 2023
AL_PY := python3.9
else
AL_TAG := 2
AL_PY := python3.7
endif
IMAGE := pyemr-amazonlinux:$(AL_TAG)-$(ARCH)
CONTAINER := pyemr-amazonlinux-$(AL_TAG)-$(ARCH)

.DEFAULT_GOAL := build-package

# ------------------------------------------------------------------------------

DOCKER_BUILD := docker buildx
BUILD_OPTS :=
build-image: docker-build
docker-build:
	$(DOCKER_BUILD) build $(BUILD_OPTS)     \
		--platform=$(DOCKER_DEFAULT_PLATFORM) \
		-t $(IMAGE)                           \
		--build-arg al_tag=$(AL_TAG)          \
		--build-arg al_py=$(AL_PY)            \
		.


CMD := /bin/bash
docker-run:
	docker run -it --rm --name $(CONTAINER) -v $(PWD):/mnt $(IMAGE) $(CMD)


build-package:
	$(MAKE) docker-run CMD="make -f /mnt/amazonlinux.mk tar-dev-packages PY=$(PY)"
