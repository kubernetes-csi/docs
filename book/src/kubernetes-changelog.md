# Kubernetes Changelog

This page summarizes major CSI changes made in each Kubernetes release. For
details on individual features, visit the [Features section](features.md).

## Kubernetes 1.15

### Features
* New features:
    * Volume capacity usage metrics
* New alpha features:
    * Volume cloning
    * Ephemeral local volumes
    * Resizing secrets

## Kubernetes 1.14

### Breaking Changes
* `csi.storage.k8s.io/v1alpha1` `CSINodeInfo` and `CSIDriver` CRDs are no longer supported.

### Features
* New beta features:
    * Topology
    * Raw block
    * Skip attach
    * Pod info on mount
* New alpha features:
    * Volume expansion
* New `storage.k8s.io/v1beta1` `CSINode` and `CSIDriver` objects were introduced.

## Kubernetes 1.13

### Deprecations
* CSI spec 0.2 and 0.3 are deprecated and support will be removed in Kubernetes 1.18.

### Features
* GA support added for [CSI spec
  1.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0).

## Kubernetes 1.12

### Breaking Changes
Kubelet device plugin registration is enabled by default, which requires CSI
plugins to use `driver-registrar:v0.3.0` to register with kubelet.

### Features
* New alpha features:
    * Snapshots
    * Topology
    * Skip attach
    * Pod info on mount
* New `csi.storage.k8s.io/v1alpha1` `CSINodeInfo` and `CSIDriver` CRDs were
  introduced and have to be installed before deploying a CSI driver.

## Kubernetes 1.11

### Features
* Beta support added for [CSI spec
  0.3](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0).
* New alpha features:
    * Raw block

## Kubernetes 1.10

### Breaking Changes
* CSI spec 0.1 is no longer supported.

### Features
* Beta support added for [CSI spec 0.2](https://github.com/container-storage-interface/spec/releases/tag/v0.2.0).
  This added optional `NodeStageVolume` and `NodeUnstageVolume` calls which
  map to Kubernetes `MountDevice` and `UnmountDevice` operations.

## Kubernetes 1.9

### Features
* Alpha support added for [CSI spec
  0.1](https://github.com/container-storage-interface/spec/releases/tag/v0.1.0).
