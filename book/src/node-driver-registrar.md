# CSI node-driver-registrar

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/node-driver-registrar](https://github.com/kubernetes-csi/node-driver-registrar)

**Status:** GA/Stable

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | Min k8s Version | Max k8s version
--|--|--|--|--|--|--
[node-driver-registrar v1.1.0](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v1.1.0) | [release-1.1](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-1.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | quay.io/k8scsi/csi-node-driver-registrar:v1.1.0 | v1.13 | -
[node-driver-registrar v1.0.2](https://github.com/kubernetes-csi/node-driver-registrar/releases/tag/v1.0.2) | [release-1.0](https://github.com/kubernetes-csi/node-driver-registrar/tree/release-1.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | quay.io/k8scsi/csi-node-driver-registrar:v1.0.2 | v1.13 | -
[driver-registrar v0.4.2](https://github.com/kubernetes-csi/driver-registrar/releases/tag/v0.4.2) | [release-0.4](https://github.com/kubernetes-csi/driver-registrar/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/driver-registrar:v0.4.2 | v1.10 | -

## Description

The CSI `node-driver-registrar` is a sidecar container that fetches driver information (using `NodeGetInfo`) from a CSI endpoint and registers it with the kubelet on that node using the [kubelet plugin registration mechanism](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/device-plugins/#device-plugin-registration).

## Usage

Kubelet directly issues CSI `NodeGetInfo`, `NodeStageVolume`, and `NodePublishVolume` calls against CSI drivers. It uses the [kubelet plugin registration mechanism](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/device-plugins/#device-plugin-registration) to discover the unix domain socket to talk to the CSI driver. Therefore, all CSI drivers should use this sidecar container to register themselves with kubelet.

For detailed information (binary parameters, etc.), see the README of the relevant branch.

## Deployment

The CSI `node-driver-registrar` is deployed per node. See [deployment section](deploying.md) for more details.
