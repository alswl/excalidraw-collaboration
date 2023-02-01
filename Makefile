# The old school Makefile, following are required targets. The Makefile is written
# to allow building multiple binaries. You are free to add more targets or change
# existing implementations, as long as the semantics are preserved.
#
#   make              - default to 'build' target
#   make test         - run unit test
#   make build        - build local binary targets
#   make container    - build containers
#   make push         - push containers
#   make clean        - clean up targets
#
# The makefile is also responsible to populate project version information.

#
# Tweak the variables based on your project.
#
SHELL := /bin/bash
NOW_SHORT := $(shell date +%Y%m%d%H%M)

PROJECT := excalidraw-collaboration
# Target binaries. You can build multiple binaries for a single project.
TARGETS := excalidraw excalidraw-room excalidraw-storage-backend

# Container registries.
REGISTRIES ?= ""

# Container image prefix and suffix added to targets.
# The final built images are:
#   $[REGISTRY]$[IMAGE_PREFIX]$[TARGET]$[IMAGE_SUFFIX]:$[VERSION]
# $[REGISTRY] is an item from $[REGISTRIES], $[TARGET] is an item from $[TARGETS].
IMAGE_PREFIX ?= $(strip )
IMAGE_SUFFIX ?= $(strip )

# This repo's root import path (under GOPATH).
ROOT := github.com/alswl/excalidraw-collaboration

# Git commit sha.
COMMIT := $(strip $(shell git rev-parse --short HEAD 2>/dev/null))
COMMIT := $(COMMIT)$(shell git diff-files --quiet || echo '-dirty')
COMMIT := $(if $(COMMIT),$(COMMIT),"Unknown")

# Current version of the project.
MAJOR_VERSION = 0
MINOR_VERSION = 1
PATCH_VERSION = 0
BUILD_VERSION = $(COMMIT)
VERSION ?= v$(MAJOR_VERSION).$(MINOR_VERSION).$(PATCH_VERSION)-$(BUILD_VERSION)

# Support gsed on OSX (installed via brew), falling back to sed. On Linux
# systems gsed won't be installed, so will use sed as expected.
SED ?= $(shell which gsed 2>/dev/null || which sed)

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: patch
patch: ## Patch endpoints
	@echo "# you can edit excalidraw.env.production to change endpoints"
	cp excalidraw.env.production excalidraw/.env.production
	cp excalidraw.dockerignore excalidraw/.dockerignore

.PHONY: images
images: ## Build docker images
	@for target in $(TARGETS); do \
		for registry in $(REGISTRIES); do \
		  image=$${registry}$(IMAGE_PREFIX)$${target}$(IMAGE_SUFFIX):$(VERSION); \
			docker build \
			-t $${image} \
			--build-arg COMMIT=$(COMMIT) \
			--progress=plain \
			 -f ./$${target}/Dockerfile $${target}; \
		done; \
	done

.PHONY: push-images
push-images: ## Push docker images
	@for target in $(TARGETS); do \
  		for registry in $(REGISTRIES); do \
  		  image=$${registry}$(IMAGE_PREFIX)$${target}$(IMAGE_SUFFIX):$(VERSION); \
		  docker push $$image; \
	  done; \
	done
	

.PHONY: ensure-git-clean
ensure-git-clean: ## Ensure git is clean
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "# git is not clean, please commit or stash your changes first"; \
		exit 1; \
	fi

.PHONY: update-docker-compose-version
update-docker-compose-version: ## Update images version for docker-compose
	@for target in $(TARGETS); do \
  		for registry in $(REGISTRIES); do \
			image=$${registry}$(IMAGE_PREFIX)$${target}$(IMAGE_SUFFIX); \
			$(SED) -i -E "s#image: $${image}:[^ ]+#image: $${image}:$(VERSION)#g" docker-compose.yaml; \
		done; \
	done

.PHONY: bump-version
previousVersion=$(shell head -n 1 ./VERSION)
bump-version: ensure-git-clean update-docker-compose-version ## Bump images version for docker-compose
	echo $(VERSION) > ./VERSION
	@echo "PLEASE using 'git commit -a' to commit image version changes"
