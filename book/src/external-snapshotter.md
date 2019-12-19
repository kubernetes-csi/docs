# CSI external-snapshotter

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter)

**Status:** Alpha

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | Min K8s Version | Max K8s Version | Recommended K8s Version
--|--|--|--|--|--|--|--
[external-snapshotter v1.2.2](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v1.2.2) | [release-1.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-1.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | quay.io/k8scsi/csi-snapshotter:v1.2.2 | v1.13 | - | v1.14
[external-snapshotter v0.4.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v0.4.1) | [release-0.4](https://github.com/kubernetes-csi/external-snapshotter/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/csi-snapshotter:v0.4.1 | v1.10 | -v1.16 | v1.10

Definitions of the min/max/recommended Kubernetes versions can be found on the
[sidecar page](sidecar-containers.md#versioning)

## Description

The CSI `external-snapshotter` is a sidecar container that watches the Kubernetes API server for `VolumeSnapshot` and `VolumeSnapshotContent` CRD objects.

The creation of a new `VolumeSnapshot` object referencing a `SnapshotClass` CRD object corresponding to this driver causes the sidecar container to trigger a `CreateSnapshot` operation against the specified CSI endpoint to provision a new snapshot. When a new snapshot is successfully provisioned, the sidecar container creates a Kubernetes `VolumeSnapshotContent` object to represent the new snapshot.

The deletion of a `VolumeSnapshot` object bound to a `VolumeSnapshotContent` corresponding to this driver with a `delete` reclaim policy causes the sidecar container to trigger a `DeleteSnapshot` operation against the specified CSI endpoint to delete the snapshot. Once the snapshot is successfully deleted, the sidecar container also deletes the `VolumeSnapshotContent` object representing the snapshot.

For detailed information about volume snapshot and restore functionality, see [Volume Snapshot & Restore](snapshot-restore-feature.md).

## Usage

CSI drivers that support provisioning volume snapshots and the ability to provision new volumes using those snapshots should use this sidecar container, and advertise the CSI `CREATE_DELETE_SNAPSHOT` controller capability.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-snapshotter/blob/master/README.md](https://github.com/kubernetes-csi/external-snapshotter/blob/master/README.md).

## Deployment

The CSI `external-snapshotter` is deployed as a controller. See [deployment section](deploying.md) for more details.

For an example deployment, see [this example](https://github.com/kubernetes-csi/external-snapshotter/blob/master/deploy/kubernetes/csi-snapshotter/setup-csi-snapshotter.yaml) which deploys `external-snapshotter` and `external-provisioner` with the Hostpath CSI driver.
