# Snapshot Controller

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter)

**Status:** v2.0.0 and higher is Beta

### Snapshot Controller

When Volume Snapshot is promoted to Beta in Kubernetes 1.17, the CSI external-snapshotter sidecar controller is split into two controllers: a snapshot-controller and a CSI external-snapshotter sidecar. See the following table for snapshot-controller release information.

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) | [Recommended K8s Version](kubernetes-compatibility.md#recommended-version)
--|--|--|--|--|--|--|--
[external-snapshotter v3.0.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v3.0.0) | [release-3.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-3.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | k8s.gcr.io/sig-storage/snapshot-controller:v3.0.0 | v1.17 | - | v1.17
[external-snapshotter v2.1.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v2.1.0) | [release-2.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-2.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | quay.io/k8scsi/snapshot-controller:v2.1.0 | v1.17 | - | v1.17

For more information on the beta version of the CSI external-snapshotter sidecar, see [this external-snapshotter page](external-snapshotter.md).

## Description

In the Beta version, the snapshot controller will be watching the Kubernetes API server for `VolumeSnapshot` and `VolumeSnapshotContent` CRD objects. The CSI `external-snapshotter` sidecar only watches the Kubernetes API server for `VolumeSnapshotContent` CRD objects. The snapshot controller will be creating the `VolumeSnapshotContent` CRD object which triggers the CSI `external-snapshotter` sidecar to create a snapshot on the storage system.

For detailed snapshot beta design changes, see the design doc [here](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/177-volume-snapshot/README.md).

For detailed information about volume snapshot and restore functionality, see [Volume Snapshot & Restore](snapshot-restore-feature.md).

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-snapshotter/blob/release-2.0/README.md](https://github.com/kubernetes-csi/external-snapshotter/blob/release-2.0/README.md).

## Deployment

Kubernetes distributors should bundle and deploy the controller and CRDs as part of their Kubernetes cluster management process (independent of any CSI Driver).

If your cluster does not come pre-installed with the correct components, you may manually install these components by executing the following steps.

Install Snapshot Beta CRDs per cluster:

```
kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml

kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml

kubectl create -f  https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
```

Install Snapshot Controller per cluster:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-2.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```
