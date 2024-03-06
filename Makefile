GO ?= $(shell which go)
OS ?= $(shell $(GO) env GOOS)
ARCH ?= $(shell $(GO) env GOARCH)
KUBE_VERSION=1.25.0

OUT := $(shell pwd)/_out
$(shell mkdir -p "$(OUT)")

export TEST_ASSET_ETCD=../_test/kubebuilder/etcd
export TEST_ASSET_KUBE_APISERVER=../_test/kubebuilder/kube-apiserver
export TEST_ASSET_KUBECTL=../_test/kubebuilder/kubectl
export TEST_ZONE_NAME=puzzzzle.ch.
export DNSIMPLE_SANDBOX=true

test: _test/kubebuilder
	cd src && $(GO) test -v .

_test/kubebuilder:
	curl -fsSL https://go.kubebuilder.io/test-tools/$(KUBE_VERSION)/$(OS)/$(ARCH) -o kubebuilder-tools.tar.gz
	mkdir -p _test/kubebuilder
	tar -xvf kubebuilder-tools.tar.gz
	mv kubebuilder/bin/* _test/kubebuilder/
	rm kubebuilder-tools.tar.gz
	rm -R kubebuilder

clean: clean-kubebuilder

clean-kubebuilder:
	rm -Rf _test/kubebuilder

.PHONY: rendered-manifest.yaml
rendered-manifest.yaml:
	helm template \
	    --name dnsimple-webhook \
        --set image.repository=$(IMAGE_NAME) \
        --set image.tag=$(IMAGE_TAG) \
        deploy/dnsimple-webhook > "$(OUT)/rendered-manifest.yaml"
