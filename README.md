# notepad

[![.github/workflows/pipeline.yml](https://github.com/laughingbiscuit/notepad/actions/workflows/pipeline.yml/badge.svg?branch=main)](https://github.com/laughingbiscuit/notepad/actions/workflows/pipeline.yml)

Any shell code blocks are run by github actions and must return 0 for CI to pass.

Lets check if our dependencies are installed

```bash
which kubectl
which helm
which kind
```

Lets create a multi-node kind cluster

```bash
kind create cluster --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true
EOF

kubectl cluster-info --context kind-kind
```

Lets install Cilium

```bash
helm repo add cilium https://helm.cilium.io/
docker pull quay.io/cilium/cilium:v1.13.0
kind load docker-image quay.io/cilium/cilium:v1.13.0
helm install cilium cilium/cilium --version 1.13.0 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
```

Now lets install the cilium cli and check everything works

```bash
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

cilium status --wait
cilium connectivity test
kubectl cluster-info --context kind-kind
kubectl get nodes
```

Next up.. Istio

```bash
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
helm install istio-base istio/base -n istio-system --create-namespace
helm install istiod istio/istiod -n istio-system --wait
helm ls -n istio-system
helm status istiod -n istio-system
kubectl label namespace default istio-injection=enabled
curl https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml | kubectl apply -f -
while ! kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sSf productpage:9080/productpage | grep -o "<title>.*</title>"; do sleep 5; echo -n "."; done
kubectl get svc
kubectl get po
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```
Gloo

<!-- https://docs.solo.io/gloo-edge/latest/getting_started/ -->

```bash
helm repo add gloo https://storage.googleapis.com/solo-public-helm
helm repo update

helm install gloo gloo/gloo -n gloo-system --create-namespace
sleep 30
kubectl get all -n gloo-system

```
