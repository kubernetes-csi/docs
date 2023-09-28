# Cross-namespace storage data sources

## Status

Status | Min K8s Version | Max K8s Version | external-provisioner Version
-------|-----------------|-----------------|-----------------------------
Alpha  | 1.26            | -               | 3.4.0+

## Overview
By default, a `VolumeSnapshot` is a namespace-scoped resource while a `VolumeSnapshotContent` is a cluster-scope resource.
Consequently, you can not restore a snapshot from a different namespace than the source.

With that feature enabled, you can specify a `namespace` attribute in the [`dataSourceRef`](snapshot-restore-feature.md). Once Kubernetes checks that access is OK, the new PersistentVolume can populate its data from the storage source specified in another
namespace.

> See the [Kubernetes Enhancement Proposal](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3294-provision-volumes-from-cross-namespace-snapshots) 
> for more details on the background, design and discussions.

## Usage

To enable this feature, cluster administrators must:
* Install a CRD for `ReferenceGrants` supplied by the [gateway API project](https://github.com/kubernetes-sigs/gateway-api)
* Enable the `AnyVolumeDataSource` and `CrossNamespaceVolumeDataSource` [feature gates](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/) for the kube-apiserver and kube-controller-manager
* Install a CRD for the specific `VolumeSnapShot` controller
* Start the CSI Provisioner controller with the argument `--feature-gates=CrossNamespaceVolumeDataSource=true`
* Grant the CSI Provisioner with **get**, **list**, and **watch** permissions for `referencegrants` (API group `gateway.networking.k8s.io`)
* Install the CSI driver

> For more information about how to use the feature, visit the [Kubernetes blog](https://kubernetes.io/blog/2023/01/02/cross-namespace-data-sources-alpha/) page. 
