# Setup

To use CSI drivers, your Kubernetes cluster must allow privileged pods (i.e. `--allow-privileged` flag must be set to `true` for both the API server and the kubelet). This is the default in some environments (e.g. GCE, GKE, `kubeadm`).

If you are on Kubernetes 1.9, some extra setup is required. Please check [this page](Kubernetes-1.9.html).
