SHELL = /bin/bash

IMAGE := pyemr-amazonlinux:2023
CONTAINER := pyemr-amazonlinux-2023

export DOCKER_DEFAULT_PLATFORM=linux/amd64

.DEFAULT_GOAL := build-package

# ------------------------------------------------------------------------------

DOCKER_BUILD := docker buildx
BUILD_OPTS :=
docker-build:
	$(DOCKER_BUILD) build $(BUILD_OPTS) --platform=linux/amd64 -t $(IMAGE) .

CMD := /bin/bash
docker-run:
		docker run -it --rm   \
			--name $(CONTAINER) \
			-v $(PWD):/mnt      \
			$(IMAGE)            \
			$(CMD)              \
		# END

build-package: docker-build
	$(MAKE) docker-run CMD="make -f /mnt/amazonlinux.mk tar-dev-packages"
