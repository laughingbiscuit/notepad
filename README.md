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
```

Now lets install the cilium cli and check everything works

```sh
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
