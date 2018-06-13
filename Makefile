DOCKER_IMAGE=lightsaway/helm
HELM_VERSIONS=v2.2.3 v2.3.1 v2.2.1 v2.4.2 v2.5.0 v2.6.0 v2.8.0


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
