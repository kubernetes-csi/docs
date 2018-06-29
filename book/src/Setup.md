# Setup

To use CSI drivers, your Kubernetes cluster must allow privileged pods (i.e. `--allow-privileged` flag must be set to `true` for both the API server and the kubelet). This is the default in some environments (e.g. GCE, GKE, `kubeadm`).

Moreover, as stated in the [mount propagation docs][mount-propagation-docs], the Docker daemon of the cluster nodes must allow shared mounts. [This page][docker-shared-mount] explains how to check if shared mounts are enabled and how to configure Docker for shared mounts.

This document has been updated to the latest version of Kubernetes v1.11.

Please visit the [Archives](Archive.html) for setup instructions on previous versions of Kubernetes.

[mount-propagation-docs]: https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
[docker-shared-mount]: https://docs.portworx.com/knowledgebase/shared-mount-propogation.html
