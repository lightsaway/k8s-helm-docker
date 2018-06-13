FROM alpine:3.5
ARG HELM_VERSION="v2.2.3"
ARG PUSHA_VERSION="v0.1.0"

RUN apk add --no-cache curl tar sudo openssl make

ENV HOME /home/jenkins
RUN adduser -D -u 10000 jenkins

WORKDIR $HOME

ENV HELM_SCRIPT_URL "https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get"
ENV HELM_HOME "/usr/helm"

# SETUP HELM

COPY ./bin/helm.sh ./helm.sh

RUN chmod +x ./helm.sh \
		&& sh ./helm.sh
RUN	helm init --client-only


# DOWNLOAD PUSH PLUGIN
ENV PUSHA_URL "https://github.com/lightsaway/helm-pusha/releases/download/${PUSHA_VERSION}/pusha.tar"

RUN	mkdir "$HELM_HOME/plugins/push" \
	&& cd $HELM_HOME/plugins/ \
	&& mkdir -p push \
	&& curl -L $PUSHA_URL --output /tmp/pusha.tar \
	&& tar -xvf /tmp/pusha.tar \
	&& cp ./build/linux/pusher push/pusher \
	&& cp ./build/plugin.yaml push/pusher \
	&& chmod +x push/pusher \
	&& rm -rf ./build \
	&& rm -rf /tmp/pusha.tar


