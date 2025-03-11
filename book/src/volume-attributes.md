# Volume Attributes Classes

## Status

Status | Min K8s Version | Max K8s Version | external-provisioner Version
-------|-----------------|-----------------|-----------------------------
Alpha  | 1.29            | -               | 5.0.2+
Beta   | 1.31            | -               | 5.1.0+

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
* The user can then patch the `PersistentVolume` under `spec.volumeAttributesClassName` to select or update the settings he needs for the volume.

> For more information about how to use the feature, visit the [Kubernetes blog](https://kubernetes.io/blog/2024/08/15/kubernetes-1-31-volume-attributes-class/) page. 
