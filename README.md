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

sleep 30
kubectl cluster-info --context kind-kind
```

