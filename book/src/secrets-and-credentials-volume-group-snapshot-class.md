# VolumeGroupSnapshotClass Secrets

The CSI [external-snapshotter](external-snapshotter.md) sidecar container facilitates the handling of secrets for the following operations:
* `CreateGroupSnapshotRequest`
* `DeleteGroupSnapshotRequest`
* `GetGroupSnapshotRequest`

CSI `external-snapshotter` v8.1.0+ supports the following keys in `VolumeGroupSnapshotClass.parameters`:

* `csi.storage.k8s.io/group-snapshotter-secret-name`
* `csi.storage.k8s.io/group-snapshotter-secret-namespace`

With CSI `external-snapshotter` v8.2.0 the following additional `VolumeGroupSnapshotClass.parameters` were added specifically for `GetGroupSnapshotRequest` operations:

* `csi.storage.k8s.io/group-snapshotter-get-secret-name`
* `csi.storage.k8s.io/group-snapshotter-get-secret-namespace`

Cluster admins can populate the secret fields for the operations listed above with data from Kubernetes `Secret` objects by specifying these keys in the `VolumeGroupSnapshotClass` object.

## Operations
Details for each secret supported by the external-snapshotter can be found below.

### Create/Delete VolumeGroupSnapshot Secret

CSI `external-snapshotter` v8.1.0+ looks for the following keys in `VolumeGroupSnapshotClass.parameters` for `CreateGroupSnapshotRequest` and `DeleteGroupSnapshotRequest` operations:

* `csi.storage.k8s.io/group-snapshotter-secret-name`
* `csi.storage.k8s.io/group-snapshotter-secret-namespace`

The values of both of these parameters, together, refer to the name and namespace of a `Secret` object in the Kubernetes API.

If specified, the CSI `external-snapshotter` will attempt to fetch the secret before creation and deletion.

If the secret is retrieved successfully, the snapshotter passes it to the CSI driver in the `CreateGroupSnapshotRequest.secrets` or `DeleteGroupSnapshotRequest.secrets` field.

If no such secret exists in the Kubernetes API, or the snapshotter is unable to fetch it, the create operation will fail.

Note, however, that the delete operation will continue even if the secret is not found (because, for example, the entire namespace containing the secret was deleted). In this case, if the driver requires a secret for deletion, then the volume group snapshot and related snapshots need to be manually cleaned up.

The values of these parameters may be "templates". The `external-snapshotter` will automatically resolve templates at volume group snapshot create time, as detailed below:

* `csi.storage.k8s.io/group-snapshotter-secret-name`
  * `${volumegroupsnapshotcontent.name}`
    * Replaced with name of the `VolumeGroupSnapshotContent` object being created.
  * `${volumegroupsnapshot.namespace}`
    * Replaced with namespace of the `VolumeGroupSnapshot` object that triggered creation.
  * `${volumegroupsnapshot.name}`
    * Replaced with the name of the `VolumeGroupSnapshot` object that triggered creation.
* `csi.storage.k8s.io/group-snapshotter-secret-namespace`
  * `${volumegroupsnapshotcontent.name}`
    * Replaced with name of the `VolumeGroupSnapshotContent` object being created.
  * `${volumegroupsnapshot.namespace}`
    * Replaced with namespace of the `VolumeGroupSnapshot` object that triggered creation.

### Get VolumeGroupSnapshot Secret

CSI `external-snapshotter` v8.2.0+ looks for the following keys in `VolumeGroupSnapshotClass.parameters` for `GetGroupSnapshotRequest` operations:

* `csi.storage.k8s.io/group-snapshotter-get-secret-name`
* `csi.storage.k8s.io/group-snapshotter-get-secret-namespace`

The values of both of these parameters, together, refer to the name and namespace of a `Secret` object in the Kubernetes API.

If specified, the CSI `external-snapshotter` will attempt to fetch the secret before creation and deletion.

If the secret is retrieved successfully, the snapshotter passes it to the CSI driver in the `GetGroupSnapshotRequest.secrets` field.

If no such secret exists in the Kubernetes API, or the snapshotter is unable to fetch it, the create operation will fail.

The values of these parameters may be "templates". The `external-snapshotter` will automatically resolve templates at volume group snapshot create time, as detailed below:

* `csi.storage.k8s.io/group-snapshotter-secret-name`
  * `${volumegroupsnapshotcontent.name}`
    * Replaced with name of the `VolumeGroupSnapshotContent` object being created.
  * `${volumegroupsnapshot.namespace}`
    * Replaced with namespace of the `VolumeGroupSnapshot` object that triggered creation.
  * `${volumegroupsnapshot.name}`
    * Replaced with the name of the `VolumeGroupSnapshot` object that triggered creation.
* `csi.storage.k8s.io/group-snapshotter-secret-namespace`
  * `${volumegroupsnapshotcontent.name}`
    * Replaced with name of the `VolumeGroupSnapshotContent` object being created.
  * `${volumegroupsnapshot.namespace}`
    * Replaced with namespace of the `VolumeGroupSnapshot` object that triggered creation.
