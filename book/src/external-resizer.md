# CSI external-resizer

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-resizer](https://github.com/kubernetes-csi/external-resizer)

**Status:** Beta starting with v0.3.0

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) | [Recommended K8s Version](kubernetes-compatibility.md#recommended-version) |
--|--|--|--|--|--|--|--
[external-resizer v1.7.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.7.0)  | [release-1.7](https://github.com/kubernetes-csi/external-resizer/tree/release-1.7) |[v1.5.0](https://github.com/container-storage-interface/spec/releases/tag/v1.5.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.7.0  | v1.16 | - | v1.23
[external-resizer v1.6.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.6.0)  | [release-1.6](https://github.com/kubernetes-csi/external-resizer/tree/release-1.6) |[v1.5.0](https://github.com/container-storage-interface/spec/releases/tag/v1.5.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.6.0  | v1.16 | - | v1.23
[external-resizer v1.5.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.5.0)  | [release-1.5](https://github.com/kubernetes-csi/external-resizer/tree/release-1.5) |[v1.5.0](https://github.com/container-storage-interface/spec/releases/tag/v1.5.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.5.0  | v1.16 | - | v1.23

### Unsupported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) | [Recommended K8s Version](kubernetes-compatibility.md#recommended-version) |
--|--|--|--|--|--|--|--
[external-resizer v1.4.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.4.0)  | [release-1.4](https://github.com/kubernetes-csi/external-resizer/tree/release-1.4) |[v1.5.0](https://github.com/container-storage-interface/spec/releases/tag/v1.5.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.4.0  | v1.16 | - | v1.23
[external-resizer v1.3.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.3.0)  | [release-1.3](https://github.com/kubernetes-csi/external-resizer/tree/release-1.3) |[v1.5.0](https://github.com/container-storage-interface/spec/releases/tag/v1.5.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.3.0  | v1.16 | - | v1.22
[external-resizer v1.2.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.2.0)  | [release-1.2](https://github.com/kubernetes-csi/external-resizer/tree/release-1.2) |[v1.2.0](https://github.com/container-storage-interface/spec/releases/tag/v1.2.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.2.0  | v1.16 | - | v1.21
[external-resizer v1.1.0](https://github.com/kubernetes-csi/external-resizer/tree/v1.1.0)  | [release-1.1](https://github.com/kubernetes-csi/external-resizer/tree/release-1.1) |[v1.2.0](https://github.com/container-storage-interface/spec/releases/tag/v1.2.0) | - | registry.k8s.io/sig-storage/csi-resizer:v1.1.0  | v1.16 | - | v1.16
[external-resizer v0.5.0](https://github.com/kubernetes-csi/external-resizer/tree/v0.5.0)  | [release-0.5](https://github.com/kubernetes-csi/external-resizer/tree/release-0.5) |[v1.2.0](https://github.com/container-storage-interface/spec/releases/tag/v1.2.0) | - | quay.io/k8scsi/csi-resizer:v0.5.0 | v1.15 | - | v1.16
[external-resizer v0.2.0](https://github.com/kubernetes-csi/external-resizer/tree/v0.2.0)  | [release-0.2](https://github.com/kubernetes-csi/external-resizer/tree/release-0.2) |[v1.1.0](https://github.com/container-storage-interface/spec/releases/tag/v1.1.0) | - | quay.io/k8scsi/csi-resizer:v0.2.0 | v1.15 | - | v1.15
[external-resizer v0.1.0](https://github.com/kubernetes-csi/external-resizer/tree/v0.1.0)  | [release-0.1](https://github.com/kubernetes-csi/external-resizer/tree/release-0.1) |[v1.1.0](https://github.com/container-storage-interface/spec/releases/tag/v1.1.0) | - | quay.io/k8scsi/csi-resizer:v0.1.0 | v1.14 | v1.14 | v1.14
[external-resizer v1.0.1](https://github.com/kubernetes-csi/external-resizer/tree/v1.0.1)  | [release-1.0](https://github.com/kubernetes-csi/external-resizer/tree/release-1.0) |[v1.2.0](https://github.com/container-storage-interface/spec/releases/tag/v1.2.0) | - | quay.io/k8scsi/csi-resizer:v1.0.1  | v1.16 | - | v1.16

## Description

The CSI `external-resizer` is a sidecar container that watches the Kubernetes API server for `PersistentVolumeClaim` object edits and
triggers `ControllerExpandVolume` operations against a CSI endpoint if user requested more storage on `PersistentVolumeClaim` object.

## Usage

CSI drivers that support Kubernetes volume expansion should use this sidecar container, and advertise the CSI `VolumeExpansion` plugin capability.

## Deployment

The CSI `external-resizer` is deployed as a controller. See [deployment section](deploying.md) for more details.
