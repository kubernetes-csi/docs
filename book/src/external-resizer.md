# CSI external-resizer

## Status and Releases

**Git Repository:** https://github.com/kubernetes-csi/external-resizer/

**Status:** Alpha

Latest release | Branch | Compatible with CSI Version | Container Image | Min k8s Version | Max k8s version
--|--|--|--|--|--
[external-resizer v0.1.0](https://github.com/kubernetes-csi/external-resizer/tree/v0.1.0)  | [master](https://github.com/kubernetes-csi/external-resizer/tree/master) |[v1.1.0](https://github.com/container-storage-interface/spec/releases/tag/v1.1.0) | docker pull quay.io/k8scsi/csi-resizer:v0.1.0 | v1.14 | -

## Description

The CSI `external-resizer` is a sidecar container that watches the Kubernetes API server for `PersistentVolumeClaim` object edits and
triggers `ControllerExpandVolume` operations against a CSI endpoint if user requested more storage on `PersistentVolumeClaim` object.

## Usage

CSI drivers that support Kubernetes volume expansion should use this sidecar container, and advertise the CSI `VolumeExpansion` plugin capability.

## Deployment

The CSI `external-resizer` is deployed as a controller. See [deployment section](deploying.md) for more details.
