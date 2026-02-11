# Makefile for building carbonio-thirds packages using YAP
#
# Usage:
#   make build TARGET=ubuntu-jammy           # Build all packages for Ubuntu 22.04
#   make build-native TARGET=rocky-9         # Build only native packages
#   make build-perl TARGET=ubuntu-noble      # Build only perl packages
#   make clean                               # Clean build artifacts
#
# Supported targets:
#   ubuntu-jammy, ubuntu-noble, rocky-8, rocky-9

# Configuration
YAP_IMAGE_PREFIX ?= docker.io/m0rf30/yap
YAP_VERSION ?= 1.48
CONTAINER_RUNTIME ?= $(shell command -v docker >/dev/null 2>&1 && echo docker || echo podman)

# Build directories
OUTPUT_DIR ?= artifacts

# CCache directory for build caching
CCACHE_DIR ?= $(CURDIR)/.ccache

# Default target (can be overridden)
TARGET ?= ubuntu-jammy

# Container image name (format: docker.io/m0rf30/yap-<target>:<version>)
YAP_IMAGE = $(YAP_IMAGE_PREFIX)-$(TARGET):$(YAP_VERSION)

# Container name
CONTAINER_NAME ?= yap-$(TARGET)

# Container options
CONTAINER_OPTS = --rm -ti \
	--name $(CONTAINER_NAME) \
	--entrypoint bash \
	-v $(CURDIR):/project \
	-v $(CURDIR)/$(OUTPUT_DIR):/artifacts \
	-v $(CCACHE_DIR):/root/.ccache \
	-e CCACHE_DIR=/root/.ccache

.PHONY: all build build-native build-perl clean list-targets help pull

# Default target
all: build

## build: Build all packages (native and perl) for the specified TARGET
build: build-native build-perl

## build-native: Build only native packages for the specified TARGET
build-native:
	@echo "Building native packages for $(TARGET)..."
	@mkdir -p $(OUTPUT_DIR) $(CCACHE_DIR)
	$(CONTAINER_RUNTIME) run $(CONTAINER_OPTS) $(YAP_IMAGE) -c "yap prepare $(TARGET) && yap build $(TARGET) /project/native"

## build-perl: Build only perl packages for the specified TARGET
build-perl:
	@echo "Building perl packages for $(TARGET)..."
	@mkdir -p $(OUTPUT_DIR) $(CCACHE_DIR)
	$(CONTAINER_RUNTIME) run $(CONTAINER_OPTS) $(YAP_IMAGE) -c "yap prepare $(TARGET) && yap build $(TARGET) /project/perl"

## pull: Pull the YAP container image for the specified TARGET
pull:
	@echo "Pulling YAP image for $(TARGET)..."
	$(CONTAINER_RUNTIME) pull $(YAP_IMAGE)

## clean: Remove build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(OUTPUT_DIR)
	rm -rf native/artifacts perl/artifacts

## clean-all: Remove build artifacts
clean-all: clean

## list-targets: List supported distribution targets
list-targets:
	@echo "Supported distribution targets:"
	@echo ""
	@echo "  ubuntu-jammy    (Ubuntu 22.04 LTS)"
	@echo "  ubuntu-noble    (Ubuntu 24.04 LTS)"
	@echo "  rocky-8         (Rocky Linux 8)"
	@echo "  rocky-9         (Rocky Linux 9)"
	@echo ""
	@echo "Usage: make build TARGET=<target>"

## help: Show this help message
help:
	@echo "Carbonio Thirds - Build System"
	@echo ""
	@echo "This Makefile builds third-party packages for Carbonio using YAP"
	@echo "(Yet Another Packager) in Docker/Podman containers."
	@echo ""
	@echo "Usage:"
	@echo "  make <target> [TARGET=<distro>] [OPTIONS]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## /  /' | column -t -s ':'
	@echo ""
	@echo "Options:"
	@echo "  TARGET             Distribution target (default: $(TARGET))"
	@echo "  YAP_IMAGE_PREFIX   YAP image prefix (default: $(YAP_IMAGE_PREFIX))"
	@echo "  YAP_VERSION        YAP image version (default: $(YAP_VERSION))"
	@echo "  CONTAINER_RUNTIME  Container runtime (default: podman)"
	@echo "  CONTAINER_NAME     Container name (default: $(CONTAINER_NAME))"
	@echo "  OUTPUT_DIR         Output directory for packages (default: $(OUTPUT_DIR))"
	@echo "  CCACHE_DIR         CCache directory for build caching (default: $(CCACHE_DIR))"
	@echo ""
	@echo "Examples:"
	@echo "  make build TARGET=ubuntu-jammy"
	@echo "  make build-native TARGET=rocky-9"
	@echo "  make build-perl TARGET=ubuntu-noble"
	@echo "  make pull TARGET=ubuntu-noble"
	@echo ""
