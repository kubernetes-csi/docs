# Volume Attributes Classes

## Status

Status | Min K8s Version | Max K8s Version | external-provisioner  | external-resizer
-------|-----------------|-----------------|-----------------------|-------------------------
Alpha  | 1.29            | -               | v4.0.0                | v1.10.0
Beta   | 1.31            | -               | v5.1.0                | v1.12.0
GA     | 1.34            | -               | v6.0.0                | v2.0.0

## Overview
A `VolumeAttributesClass` is a cluster-scoped resource that can be used to control and change the settings of a `PersistentVolume`.
Its primary use is to adjust the class of service for a volume (e.g., bronze, silver, gold) to meet different performance, quality-of-service, or resilience requirements.

> See the [Kubernetes Enhancement Proposal](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/3751-volume-attributes-class/README.md) 
> for more details on the background, design and discussions.

## Usage
This feature is enabled by default in the [external-provisioner](https://github.com/kubernetes-csi/external-provisioner/?tab=readme-ov-file#feature-status).

To take advantage of `VolumeAttibutesClass` feature:
* The CSI driver must implement the `MODIFY_VOLUME` capability.
* The Kubernetes administrator must create the `VolumeAttributesClass` with the relevant `parameters` for the `driverName`
* The user can then patch the `PersistentVolumeClaim` under `spec.volumeAttributesClassName` to select or update the settings he needs for the volume.

> For more information about how to use the feature, visit the [Kubernetes documentation](https://kubernetes.io/docs/concepts/storage/volume-attributes-classes/) page. 
