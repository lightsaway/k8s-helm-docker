DOCKER_IMAGE=lightsaway/helm
HELM_VERSIONS=2.2.3 2.3.1 2.2.1 2.4.2 2.5.0 2.6.0 2.8.0 2.9.1

build: build_all

help:	## to show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

test:	## to test all images
	@$(foreach version,$(HELM_VERSIONS), \
	echo 'Testing helm ${version} \n' && \
	docker run $(HUB)$(DOCKER_IMAGE):$(version) helm repo list;)

build_all:	## to build all images
	@$(foreach version,$(HELM_VERSIONS), \
	docker build \
	--build-arg HELM_VERSION=$(version) \
	-t $(HUB)$(DOCKER_IMAGE):$(version) -f Dockerfile . ;)

build_default:	## to builds default image
	docker build -t $(HUB)$(DOCKER_IMAGE):latest -f Dockerfile .

push:	## to push all images
	@$(foreach version,$(HELM_VERSIONS), docker push $(HUB)$(DOCKER_IMAGE):$(version);)

##TODO: fixme
build-%:
	VERSION_PRESENT_IN_HUB_LATEST = curl $(HUB_VERSION_URL)-$(version) > /dev/null
	if ! $(VERSION_PRESENT_IN_HUB_LATEST); then $(MAKE) build-$*; fi