RELEASE_FILE := hack/release.yaml

.PHONY: default
default: release-build ;

## Location to install dependencies to
LOCALBIN ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

YQ := $(abspath $(LOCALBIN)/yq)
YQ_VERSION=v4.44.1
.PHONY: yq
yq: $(YQ) ## Download yq locally if necessary.
$(YQ): | $(LOCALBIN)
	@curl -fsSL -o $(YQ) https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_linux_amd64 && chmod +x $(YQ)

.PHONY: build
build:
	go build -o $(LOCALBIN)/app .

.PHONY: clean
clean:
	rm -f $(LOCALBIN)/app
	go clean

.PHONY: release-build
release-build: | $(YQ)
ifndef DOCKER_REGISTRY
	$(error DOCKER_REGISTRY is not set)
endif
ifndef DOCKER_TAG
	$(error DOCKER_TAG is not set)
endif
	@echo "Checking if release.yaml has been updated..."
	@if [ "$$($(YQ) e '.TestingComponent.repository' $(RELEASE_FILE))" != "$(DOCKER_REGISTRY)" ]; then \
	    echo "Error: repository is not set correctly in $(RELEASE_FILE)"; exit 1; \
	fi
	@if [ "$$($(YQ) e '.TestingComponent.version' $(RELEASE_FILE))" != "$(DOCKER_TAG)" ]; then \
	    echo "Error: version is not set correctly in $(RELEASE_FILE)"; exit 1; \
	fi
	@if [ "$$($(YQ) e '.AnotherTestingComponent.repository' $(RELEASE_FILE))" != "$(DOCKER_REGISTRY)" ]; then \
		echo "Error: repository is not set correctly in $(RELEASE_FILE)"; exit 1; \
	fi
	@if [ "$$($(YQ) e '.AnotherTestingComponent.version' $(RELEASE_FILE))" != "$(DOCKER_TAG)" ]; then \
		echo "Error: version is not set correctly in $(RELEASE_FILE)"; exit 1; \
	fi
	@echo "release.yaml is correctly updated."
