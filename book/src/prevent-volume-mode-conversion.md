# Prevent unauthorised volume mode conversion

## Status

Status | Min K8s Version | Max K8s Version | external-snapshotter Version | external-provisioner Version
--|--|--|--|--
Alpha | 1.24 | - | 6.0.1+ | 3.2.1+

## Overview

Malicious users can populate the `spec.volumeMode` field of a `PersistentVolumeClaim`
with a [Volume Mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#volume-mode)
that differs from the original volume's mode to potentially exploit an as-yet-unknown
vulnerability in the host operating system.
This feature allows cluster administrators to prevent unauthorized users from converting
the mode of a volume when a `PersistentVolumeClaim` is being created from an existing
`VolumeSnapshot` instance.

> See the [Kubernetes Enhancement Proposal](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3141-prevent-volume-mode-conversion) 
> for more details on the background, design and discussions.

## Usage

To enable this feature, cluster administrators must:

* Create `VolumeSnapshot` APIs with a minimum version of [`v6.0.1`](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/client%2Fv6.0.1).
* Use `snapshot-controller` and `snapshot-validation-webhook` with a minimum version of `v6.0.1`.
* Use `external-provisioner` with a minimum version of [`v3.2.1`](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v3.2.1).
* Set `--prevent-volume-mode-conversion=true` flag in `snapshot-controller`, `snapshot-validation-webhook` and `external-provisioner`.

> For more information about how to use the feature, visit the [Kubernetes blog](https://kubernetes.io/blog/2022/05/18/prevent-unauthorised-volume-mode-conversion-alpha/) page. 