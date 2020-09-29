# CSI livenessprobe

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/livenessprobe](https://github.com/kubernetes-csi/livenessprobe)

**Status:** GA/Stable

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) |
--|--|--|--|--|--|--
[livenessprobe v2.1.0](https://github.com/kubernetes-csi/livenessprobe/releases/tag/v2.1.0) | [release-2.1](https://github.com/kubernetes-csi/livenessprobe/tree/release-2.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) |-| k8s.gcr.io/sig-storage/livenessprobe:v2.1.0 | v1.13 | -
[livenessprobe v2.0.0](https://github.com/kubernetes-csi/livenessprobe/releases/tag/v2.0.0) | [release-2.0](https://github.com/kubernetes-csi/livenessprobe/tree/release-2.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) |-| quay.io/k8scsi/livenessprobe:v2.0.0 | v1.13 | -
[livenessprobe v1.1.0](https://github.com/kubernetes-csi/livenessprobe/releases/tag/v1.1.0) | [release-1.1](https://github.com/kubernetes-csi/livenessprobe/tree/release-1.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | -|quay.io/k8scsi/livenessprobe:v1.1.0 | v1.13 | -
Unsupported. | No 0.x branch. | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) |[v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0)| quay.io/k8scsi/livenessprobe:v0.4.1 | v1.10 | v1.16

## Description

The CSI `livenessprobe` is a sidecar container that monitors the health of the CSI driver and reports it to Kubernetes via the [Liveness Probe mechanism](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/). This enables Kubernetes to automatically detect issues with the driver and restart the pod to try and fix the issue.

## Usage

All CSI drivers should use the liveness probe to improve the availability of the driver while deployed on Kubernetes.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/livenessprobe/blob/master/README.md](https://github.com/kubernetes-csi/livenessprobe/blob/master/README.md).

## Deployment

The CSI `livenessprobe` is deployed as part of controller and node deployments. See [deployment section](deploying.md) for more details.
