FROM alpine
ARG HELM_VERSION="2.9.1"

# Metadata
LABEL org.label-schema.vcs-url="https://github.com/lightsaway/helm" \
      org.label-schema.docker.dockerfile="/Dockerfile"

# SETUP HELM
COPY ./bin/helm.sh ./helm.sh

ENV HELM_SCRIPT_URL "https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get"
ENV HELM_HOME "/usr/helm"

RUN apk add --update --no-cache --virtual build-deps tar openssl curl sudo \
	&& apk add ca-certificates \
	&& chmod +x ./helm.sh \
	&& sh ./helm.sh \
	&& apk del --purge build-deps \
	&& rm -rf /tmp/helm* \
	&& helm init --client-only