# CSI `external-attacher`

## Status and Releases

**Git Repository:** https://github.com/kubernetes-csi/external-attacher

**Status:** GA/Stable

Latests stable release | Branch | Compatible with CSI Version | Container Image | Min k8s Version | Max k8s version
--|--|--|--|--|--
[external-attacher v1.0.1](https://github.com/kubernetes-csi/external-attacher/releases/tag/v1.0.1) | [release-1.0](https://github.com/kubernetes-csi/external-attacher/tree/release-1.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | quay.io/k8scsi/csi-attacher:v1.0.1 | v1.13 | -
[external-attacher v0.4.2](https://github.com/kubernetes-csi/external-attacher/releases/tag/v0.4.2) | [release-0.4](https://github.com/kubernetes-csi/external-attacher/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/csi-attacher:v0.4.2 | v1.10 | -

## Description

The CSI `external-attacher` is a sidecar container that watches the Kubernetes API server for `VolumeAttachment` objects and triggers `Controller[Publish|Unpublish]Volume` operations against a CSI endpoint.

## Usage

CSI drivers that require integrating with the Kubernetes volume attach/detach hooks should use this sidecar container, and advertise the CSI `PUBLISH_UNPUBLISH_VOLUME` controller capability.

For detailed information (binary parameters, RBAC rules, etc.), see https://github.com/kubernetes-csi/external-attacher/blob/master/README.md.

## Deployment

The CSI `external-attacher` is deployed as a controller. See [deployment section](deploying.md) for more details.