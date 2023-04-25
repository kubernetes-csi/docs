# Snapshot Controller

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter)

**Status:** GA v4.0.0+

When Volume Snapshot is promoted to Beta in Kubernetes 1.17, the CSI external-snapshotter sidecar controller is split into two controllers: a snapshot-controller and a CSI external-snapshotter sidecar. See the following table for snapshot-controller release information.

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) | [Recommended K8s Version](kubernetes-compatibility.md#recommended-version)
--|--|--|--|--|--|--|--
[external-snapshotter v6.2.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.2.1) | [release-6.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v6.2.1 | v1.20 | - | v1.24
[external-snapshotter v6.1.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.1.0) | [release-6.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v6.1.0 | v1.20 | - | v1.24
[external-snapshotter v6.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.0.1) | [release-6.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v6.0.1 | v1.20 | - | v1.24

### Unsupported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) | [Recommended K8s Version](kubernetes-compatibility.md#recommended-version)
--|--|--|--|--|--|--|--
[external-snapshotter v5.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v5.0.1) | [release-5.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-5.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v5.0.1 | v1.20 | - | v1.22
[external-snapshotter v4.2.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.2.1) | [release-4.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v4.2.1 | v1.20 | - | v1.22
[external-snapshotter v4.1.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.1.1) | [release-4.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v4.1.1 | v1.20 | - | v1.20
[external-snapshotter v4.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.0.1) | [release-4.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v4.0.1 | v1.20 | - | v1.20
[external-snapshotter v3.0.3 (beta)](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v3.0.3) | [release-3.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-3.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v3.0.3 | v1.17 | - | v1.17
[external-snapshotter v2.1.4 (beta)](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v2.1.4) | [release-2.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-2.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v2.1.4 | v1.17 | - | v1.17

For more information on the CSI external-snapshotter sidecar, see [this external-snapshotter page](external-snapshotter.md).

## Description

The snapshot controller will be watching the Kubernetes API server for `VolumeSnapshot` and `VolumeSnapshotContent` CRD objects. The CSI `external-snapshotter` sidecar only watches the Kubernetes API server for `VolumeSnapshotContent` CRD objects. The snapshot controller will be creating the `VolumeSnapshotContent` CRD object which triggers the CSI `external-snapshotter` sidecar to create a snapshot on the storage system.

For detailed snapshot beta design changes, see the design doc [here](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/177-volume-snapshot/README.md).

For detailed information about volume snapshot and restore functionality, see [Volume Snapshot & Restore](snapshot-restore-feature.md).

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-snapshotter/blob/release-6.2/README.md](https://github.com/kubernetes-csi/external-snapshotter/blob/release-6.2/README.md).

## Deployment

Kubernetes distributors should bundle and deploy the controller and CRDs as part of their Kubernetes cluster management process (independent of any CSI Driver).

If your cluster does not come pre-installed with the correct components, you may manually install these components by executing the following steps.

```
git clone https://github.com/kubernetes-csi/external-snapshotter/
cd ./external-snapshotter
git checkout release-6.2
kubectl kustomize client/config/crd | kubectl create -f -
kubectl -n kube-system kustomize deploy/kubernetes/snapshot-controller | kubectl create -f -
```