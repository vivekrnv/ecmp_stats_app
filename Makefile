.ONESHELL:
SHELL = /bin/bash
.SHELLFLAGS += -e

VERSION=1.0.0
CONTAINER_NAME=ecmp-stats

all:
	DOCKER_BUILDKIT=1 docker build \
		--build-arg \
			manifest='$(shell \
				[ -f manifest.json.j2 ] && \
				version=$(VERSION) \
				container_name=$(CONTAINER_NAME) \
				j2 manifest.json.j2)' \
		. -t ecmp-stats:$(VERSION)

build:
	docker save ecmp-stats > docker-ecmp-stats.gz