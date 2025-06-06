# CSI external-snapshotter

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter)

**Status:** GA v4.0.0+

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version) |
--|--|--|--|--|--|--|--
[external-snapshotter v8.2.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v8.2.0) | [release-8.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-8.2) | [v1.11.0](https://github.com/container-storage-interface/spec/releases/tag/v1.11.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v8.2.0 <br> registry.k8s.io/sig-storage/csi-snapshotter:v8.2.0 | v1.25 | - | v1.25
[external-snapshotter v8.1.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v8.1.0) | [release-8.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-8.1) | [v1.11.0](https://github.com/container-storage-interface/spec/releases/tag/v1.11.0) | - | registry.k8s.io/sig-storage/snapshot-controller:v8.1.0 <br> registry.k8s.io/sig-storage/csi-snapshotter:v8.1.0 <br> registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.1.0 | v1.25 | - | v1.25
[external-snapshotter v8.0.2](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v8.0.2) | [release-8.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-8.0) | [v1.9.0](https://github.com/container-storage-interface/spec/releases/tag/v1.9.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v8.0.2 <br> registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.2 | v1.25 | - | v1.25

### Unsupported Versions

<details>

<summary>List of previous versions</summary>

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version) |
--|--|--|--|--|--|--|--
[external-snapshotter v6.3.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.3.0) | [release-6.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.3) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v6.2.1 | v1.20 | - | v1.24
[external-snapshotter v6.2.2](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.2.2) | [release-6.2](https://github.c
[external-snapshotter v6.1.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.1.0) | [release-6.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v6.1.0 | v1.20 | - | v1.24
[external-snapshotter v6.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.0.1) | [release-6.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v6.0.1 | v1.20 | - | v1.24
[external-snapshotter v5.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v5.0.1) | [release-5.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-5.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v5.0.1 | v1.20 | - | v1.22
[external-snapshotter v4.2.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.2.1) | [release-4.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v4.2.1 | v1.20 | - | v1.22
[external-snapshotter v4.1.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.1.1) | [release-4.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v4.1.1 | v1.20 | - | v1.20
[external-snapshotter v4.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.0.1) | [release-4.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v4.0.1 | v1.20 | - | v1.20
[external-snapshotter v3.0.3 (beta)](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v3.0.3) | [release-3.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-3.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v3.0.3 | v1.17 | - | v1.17
[external-snapshotter v2.1.4 (beta)](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v2.1.4) | [release-2.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-2.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/csi-snapshotter:v2.1.4 | v1.17 | - | v1.17
[external-snapshotter v1.2.2 (alpha)](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v1.2.2) | [release-1.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-1.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | /registry.k8s.io/sig-storage/csi-snapshotter:v1.2.2 | v1.13 | v1.16 | v1.14
[external-snapshotter v0.4.2 (alpha)](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v0.4.2) | [release-0.4](https://github.com/kubernetes-csi/external-snapshotter/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/csi-snapshotter:v0.4.2 | v1.12 | v1.16 | v1.12

</details>

To use the snapshot beta and GA feature, a snapshot controller is also required. For more information, see [this snapshot-controller page](snapshot-controller.md).

## Snapshot Beta/GA

### Description

The CSI `external-snapshotter` sidecar watches the Kubernetes API server for `VolumeSnapshotContent` CRD objects. The CSI `external-snapshotter` sidecar is also responsible for calling the CSI RPCs `CreateSnapshot`, `DeleteSnapshot`, and `ListSnapshots`.

Volume Group Snapshot support can be enabled with the `--enable-volume-group-snapshots` option. When enabled, the CSI `external-snapshotter` sidecar watches the API server for `VolumeGroupSnapshotContent` CRD object, and will be responsible for calling the CSI RPCs `CreateVolumeGroupSnapshot`, `DeleteVolumeGroupSnapshot` and `GetVolumeGroupSnapshot`.

#### VolumeSnapshotClass and VolumeGroupSnapshotClass Parameters

When provisioning a new volume snapshot, the CSI `external-snapshotter` sets the `map<string, string> parameters` field in the CSI `CreateSnapshotRequest` call to the key/values specified in the `VolumeSnapshotClass` it is handling.

When volume group snapshot support is enabled, the `map<string, string> parameters` field is set in the CSI `CreateVolumeGroupSnapshotRequest` call to the key/values specified in the `VolumeGroupSnapshotClass` it is handling.

The CSI `external-snapshotter` also reserves the parameter keys prefixed with `csi.storage.k8s.io/`. Any `VolumeSnapshotClass` or `VolumeGroupSnapshotClass` keys prefixed with `csi.storage.k8s.io/` are not passed to the CSI driver as an opaque `parameter`.

The following reserved `VolumeSnapshotClass` parameter keys trigger behavior in the CSI `external-snapshotter`:

* `csi.storage.k8s.io/snapshotter-secret-name` (v1.0.1+)
* `csi.storage.k8s.io/snapshotter-secret-namespace` (v1.0.1+)
* `csi.storage.k8s.io/snapshotter-list-secret-name` (v2.1.0+)
* `csi.storage.k8s.io/snapshotter-list-secret-namespace` (v2.1.0+)

For more information on how secrets are handled see [Secrets & Credentials](secrets-and-credentials.md).

#### VolumeSnapshot, VolumeSnapshotContent, VolumeGroupSnapshot and VolumeGroupSnapshotContent Parameters

The CSI `external-snapshotter` (v4.0.0+) introduces the `--extra-create-metadata` flag, which automatically sets the following `map<string, string> parameters` in the CSI `CreateSnapshotRequest` and `CreateVolumeGroupSnapshotRequest`:

* `csi.storage.k8s.io/volumesnapshot/name`
* `csi.storage.k8s.io/volumesnapshot/namespace`
* `csi.storage.k8s.io/volumesnapshotcontent/name`

These parameters are internally generated using the name and namespace of the source `VolumeSnapshot` and `VolumeSnapshotContent`.

For detailed snapshot beta design changes, see the design doc [here](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/177-volume-snapshot/README.md).

For detailed information about volume snapshot and restore functionality, see [Volume Snapshot & Restore](snapshot-restore-feature.md).

### Usage

CSI drivers that support provisioning volume snapshots and the ability to provision new volumes using those snapshots should use this sidecar container, and advertise the CSI `CREATE_DELETE_SNAPSHOT` controller capability.

CSI drivers that support provisioning volume group snapshots should use this side container too, and advertise the CSI `CREATE_DELETE_GET_VOLUME_GROUP_SNAPSHOT` controller capability.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-snapshotter/blob/release-6.2/README.md](https://github.com/kubernetes-csi/external-snapshotter/blob/release-6.2/README.md).

### Deployment

The CSI `external-snapshotter` is deployed as a sidecar controller. See [deployment section](deploying.md) for more details.

For an example deployment, see [this example](https://github.com/kubernetes-csi/external-snapshotter/blob/release-6.2/deploy/kubernetes/csi-snapshotter/setup-csi-snapshotter.yaml) which deploys `external-snapshotter` and `external-provisioner` with the Hostpath CSI driver.

## Snapshot Alpha

### Description

The CSI `external-snapshotter` is a sidecar container that watches the Kubernetes API server for `VolumeSnapshot` and `VolumeSnapshotContent` CRD objects.

The creation of a new `VolumeSnapshot` object referencing a `SnapshotClass` CRD object corresponding to this driver causes the sidecar container to trigger a `CreateSnapshot` operation against the specified CSI endpoint to provision a new snapshot. When a new snapshot is successfully provisioned, the sidecar container creates a Kubernetes `VolumeSnapshotContent` object to represent the new snapshot.

The deletion of a `VolumeSnapshot` object bound to a `VolumeSnapshotContent` corresponding to this driver with a `delete` deletion policy causes the sidecar container to trigger a `DeleteSnapshot` operation against the specified CSI endpoint to delete the snapshot. Once the snapshot is successfully deleted, the sidecar container also deletes the `VolumeSnapshotContent` object representing the snapshot.

### Usage

CSI drivers that support provisioning volume snapshots and the ability to provision new volumes using those snapshots should use this sidecar container, and advertise the CSI `CREATE_DELETE_SNAPSHOT` controller capability.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-snapshotter/blob/release-1.2/README.md](https://github.com/kubernetes-csi/external-snapshotter/blob/release-1.2/README.md).

### Deployment

The CSI `external-snapshotter` is deployed as a controller. See [deployment section](deploying.md) for more details.

For an example deployment, see [this example](https://github.com/kubernetes-csi/external-snapshotter/tree/release-1.2/deploy/kubernetes/setup-csi-snapshotter.yaml) which deploys `external-snapshotter` and `external-provisioner` with the Hostpath CSI driver.
