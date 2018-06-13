DOCKER_IMAGE=lightsaway/helm
HELM_VERSIONS=2.2.3 2.3.1 2.2.1 2.4.2 2.5.0 2.6.0 2.8.0 2.9.1


help:	## to show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

test:   ## to test all images
	@$(foreach version,$(HELM_VERSIONS), \
	echo 'Testing helm ${version} \n' && \
	docker run $(HUB)$(DOCKER_IMAGE):$(version) helm repo list;)

build:  ## to build all images
	@$(foreach version,$(HELM_VERSIONS), \
	docker build --pull \
	--build-arg HELM_VERSION=$(version) \
	-t $(HUB)$(DOCKER_IMAGE):$(version) -f docker/Dockerfile . ;)

push:   ## to push all images
	@$(foreach version,$(HELM_VERSIONS), docker push $(HUB)$(DOCKER_IMAGE):$(version);)
