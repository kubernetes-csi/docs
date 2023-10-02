# Kubernetes Changelog

This page summarizes major CSI changes made in each Kubernetes release. For
details on individual features, visit the [Features section](features.md).


## Kubernetes 1.28

### Features
* GA
    * [Automatic retroactive assignment of a default StorageClass](https://kubernetes.io/blog/2023/08/18/retroactive-default-storage-class-ga/)
    * [Non-graceful node shutdown](https://kubernetes.io/blog/2023/08/16/kubernetes-1-28-non-graceful-node-shutdown-ga/)
* Alpha
    * [PersistentVolume last phase transition time](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/3762-persistent-volume-last-phase-transition-time/README.md)
* Removals:
    * [Removal of CSI Migration for GCE PD](https://github.com/kubernetes/enhancements/issues/1488)
* Deprecations:
    * [Ceph RBD in-tree plugin](https://github.com/kubernetes/kubernetes/pull/118303)
    * [Ceph FS in-tree plugin](https://github.com/kubernetes/kubernetes/pull/118143)

## Kubernetes 1.27

### Features

* Beta
    * [StatefulSet PVC Auto-Deletion](https://kubernetes.io/blog/2023/05/04/kubernetes-1-27-statefulset-pvc-auto-deletion-beta/)
    * [Robust VolumeManager reconstruction after kubelet restart](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3756-volume-reconstruction)
    * [ReadWriteOncePod Access mode](https://kubernetes.io/blog/2023/04/20/read-write-once-pod-access-mode-beta/)
    * [Speed up SELinux volume relabeling using mounts](https://kubernetes.io/blog/2023/04/18/kubernetes-1-27-efficient-selinux-relabeling-beta/)
* Alpha
    * [VolumeGroupSnapshot](https://kubernetes.io/blog/2023/05/08/kubernetes-1-27-volume-group-snapshot-alpha/)

## Kubernetes 1.26

### Features
* GA
    * Delegate fsgroup to CSI driver
    * Azure File CSI migration
    * vSphere CSI migration
* Alpha
    * Cross namespace volume provisioning

## Kubernetes 1.25

### Features
* GA
    * CSI ephemeral inline volumes
    * Core CSI migration
    * AWS EBS CSI migration
    * GCE PD CSI migration
* Beta
    * vSphere CSI Migration (on by default)
    * Portworx CSI Migration (off-by-default)
    * [CSI node expand secret](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3107-csi-nodeexpandsecret)
    * [Prevent unauthorized volume mode converstion](https://github.com/kubernetes/enhancements/issues/3141)

### Deprecation
* In-tree plugin removal:
    * AWS EBS
    * Azure Disk

## Kubernetes 1.24

### Features
* GA
    * Volume expansion
    * Storage capacity tracking
    * Azure Disk CSI Migration
    * OpenStack Cinder CSI Migration
* Beta
    * Volume populator
* Alpha
    * SELinux relabeling with mount options
    * Prevent volume mode conversion

## Kubernetes 1.23

### Features
* GA
    * CSI fsgroup policy
    * Non-recusrive fsgroup ownership
    * Generic ephemeral volumes
* Beta
    * Delegate fsgroup to CSI driver
    * Azure Disk CSI Migration (on-by-default)
    * AWS EBS CSI Migration (on-by-default)
    * GCE PD CSI Migration (on-by-default)
* Alpha
    * Recover from Expansion Failure
    * Honor PV Reclaim Policy
    * RBD CSI Migration
    * Portworx CSI migration

## Kubernetes 1.22

### Features
* GA
    * Windows CSI (CSI-Proxy API v1)
    * Pod token requests (CSIServiceAccountToken)
* Alpha
    * ReadWriteOncePod access mode
    * Delegate fsgroup to CSI driver
    * Generic data populators

## Kubernetes 1.21

### Features
* Beta
    * Pod token requests (CSIServiceAccountToken)
    * Storage capacity tracking
    * Generic ephemeral volumes

## Kubernetes 1.20

### Breaking Changes
* Kubelet no longer creates the target_path for NodePublishVolume
in accordance with the CSI spec. Kubelet also no longer checks if staging and
target paths are mounts or corrupted. CSI drivers need to be idempotent and do
any necessary mount verification.

### Features
* GA
    * Volume snapshots and restore
* Beta
    * CSI fsgroup policy
    * Non-recusrive fsgroup ownership
* Alpha
    * Pod token requests (CSIServiceAccountToken)

## Kubernetes 1.19

### Deprecations
* Behaviour of NodeExpandVolume being called between NodeStage and NodePublish is
deprecated for CSI volumes. CSI drivers should support calling NodeExpandVolume
after NodePublish if they have node EXPAND_VOLUME capability

### Features
* Beta
    * CSI on Windows
    * CSI migration for AzureDisk and vSphere drivers
* Alpha
    * CSI fsgroup policy
    * Generic ephemeral volumes
    * Storage capacity tracking
    * Volume health monitoring

## Kubernetes 1.18

### Deprecations
* `storage.k8s.io/v1beta1` `CSIDriver` object has been deprecated and will be
  removed in a future release.
* In a future release, kubelet will no longer create the CSI NodePublishVolume
  target directory, in accordance with the CSI specification. CSI drivers may
  need to be updated accordingly to properly create and process the target path.

### Features
* GA
    * Raw block volumes
    * Volume cloning
    * Skip attach
    * Pod info on mount
* Beta
    * CSI migration for Openstack cinder driver.
* Alpha
    * CSI on Windows
* `storage.k8s.io/v1` `CSIDriver` object introduced.

## Kubernetes 1.17

### Breaking Changes
* CSI 0.3 support has been removed. CSI 0.3 drivers will no longer function.

### Deprecations
* `storage.k8s.io/v1beta1` `CSINode` object has been deprecated and will be
  removed in a future release.

### Features
* GA
    * Volume topology
    * Volume limits
* Beta
    * Volume snapshots and restore
    * CSI migration for AWS EBS and GCE PD drivers
* `storage.k8s.io/v1` `CSINode` object introduced.

## Kubernetes 1.16

### Features
* Beta
    * Volume cloning
    * Volume expansion
    * Ephemeral local volumes

## Kubernetes 1.15

### Features
* Volume capacity usage metrics
* Alpha
    * Volume cloning
    * Ephemeral local volumes
    * Resizing secrets

## Kubernetes 1.14

### Breaking Changes
* `csi.storage.k8s.io/v1alpha1` `CSINodeInfo` and `CSIDriver` CRDs are no longer supported.

### Features
* Beta
    * Topology
    * Raw block
    * Skip attach
    * Pod info on mount
* Alpha
    * Volume expansion
* `storage.k8s.io/v1beta1` `CSINode` and `CSIDriver` objects introduced.

## Kubernetes 1.13

### Deprecations
* CSI spec 0.2 and 0.3 are deprecated and support will be removed in Kubernetes 1.17.

### Features
* GA support added for [CSI spec
  1.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0).

## Kubernetes 1.12

### Breaking Changes
Kubelet device plugin registration is enabled by default, which requires CSI
plugins to use `driver-registrar:v0.3.0` to register with kubelet.

### Features
* Alpha
    * Snapshots
    * Topology
    * Skip attach
    * Pod info on mount
* `csi.storage.k8s.io/v1alpha1` `CSINodeInfo` and `CSIDriver` CRDs were
  introduced and have to be installed before deploying a CSI driver.

## Kubernetes 1.11

### Features
* Beta support added for [CSI spec
  0.3](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0).
* Alpha
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
