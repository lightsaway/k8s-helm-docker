# Helm Docker Image
## Provides an image with prebuilt and pre-initialized Helm client

## Running through docker image

Helm reuses kubernetes client config. This is because helm container doesn't include any kubernetes configuration, therefore  we need to pass them inside the container

Here is a code snippet that provides helm alias on build agent without helm binary

```bash
function helm(){
ARGS=$@
NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`
docker run --env-file <(printenv | grep KUBE) \
				-v /var/run/secrets/kubernetes.io/serviceaccount/token:/var/run/secrets/kubernetes.io/serviceaccount/token \
				-v /var/run/secrets/kubernetes.io/serviceaccount/ca.crt:/var/run/secrets/kubernetes.io/serviceaccount/ca.crt \
				lightsaway/helm:0.0.7 helm --tiller-namespace=${NAMESPACE} ${ARGS}
}
```

*See Makefile on how-to build and push manually*

TODO:
* provide travis