# CSI node-driver-registrar

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/node-driver-registrar](https://github.com/kubernetes-csi/node-driver-registrar)

**Status:** GA/Stable

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version) |
--|--|--|--|--|--|--|--
[node-driver-registrar v2.9.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.9.0) | [release-2.8](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.9) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.9.0 | v1.13 | -
[node-driver-registrar v2.8.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.8.0) | [release-2.8](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.8) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.8.0 | v1.13 | -
[node-driver-registrar v2.7.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.7.0) | [release-2.7](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.7) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.7.0 | v1.13 | -
[node-driver-registrar v2.6.3](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.6.3) | [release-2.6](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.6) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.6.3 | v1.13 | -

### Unsupported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version) |
--|--|--|--|--|--|--|--
[node-driver-registrar v2.5.1](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.5.1) | [release-2.5](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.5) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.5.1 | v1.13 | -
[node-driver-registrar v2.4.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.4.0) | [release-2.4](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.4) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.4.0 | v1.13 | -
[node-driver-registrar v2.3.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.3.0) | [release-2.3](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.3) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.3.0 | v1.13 | -
[node-driver-registrar v2.2.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.2.0) | [release-2.2](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.2.0 | v1.13 | -
[node-driver-registrar v2.1.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.1.0) | [release-2.1](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.1.0 | v1.13 | -
[node-driver-registrar v2.0.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v2.0.0) | [release-2.0](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-2.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.0.0 | v1.13 | -
[node-driver-registrar v1.2.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v1.2.0) | [release-1.2](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-1.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | quay.io/k8scsi/csi-node-driver-registrar:v1.2.0 | v1.13 | -
[driver-registrar v0.4.2](https://github.com/kubernetes-csi/driver-registrar/releases/tag/v0.4.2) | [release-0.4](https://github.com/kubernetes-csi/driver-registrar/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/driver-registrar:v0.4.2 | v1.10 | v1.16

## Description

The CSI `node-driver-registrar` is a sidecar container that fetches driver information (using `NodeGetInfo`) from a CSI endpoint and registers it with the kubelet on that node using the [kubelet plugin registration mechanism](https://github.com/kubernetes/kubernetes/blob/master/pkg/kubelet/pluginmanager/pluginwatcher/README.md).

## Usage

Kubelet directly issues CSI `NodeGetInfo`, `NodeStageVolume`, and `NodePublishVolume` calls against CSI drivers. It uses the [kubelet plugin registration mechanism](https://github.com/kubernetes/kubernetes/blob/master/pkg/kubelet/pluginmanager/pluginwatcher/README.md) to discover the unix domain socket to talk to the CSI driver. Therefore, all CSI drivers should use this sidecar container to register themselves with kubelet.

For detailed information (binary parameters, etc.), see the README of the relevant branch.

## Deployment

The CSI `node-driver-registrar` is deployed per node. See [deployment section](deploying.md) for more details.
