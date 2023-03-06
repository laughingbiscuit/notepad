# notepad

[![.github/workflows/pipeline.yml](https://github.com/laughingbiscuit/notepad/actions/workflows/pipeline.yml/badge.svg?branch=main)](https://github.com/laughingbiscuit/notepad/actions/workflows/pipeline.yml)

Any shell code blocks are run by github actions and must return 0 for CI to pass.

Lets check if our dependencies are installed

```sh
which kubectl
which helm
which kind
```

Lets create a multi-node kind cluster

```sh
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

sleep 10
kubectl cluster-info --context kind-kind
```

Lets install Cilium

```sh
helm repo add cilium https://helm.cilium.io/
docker pull quay.io/cilium/cilium:v1.13.0
kind load docker-image quay.io/cilium/cilium:v1.13.0
helm install cilium cilium/cilium --version 1.13.0 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
sleep 30
kubectl cluster-info --context kind-kind
kubectl get nodes --context kind-kind
kubectl get nodes
```


