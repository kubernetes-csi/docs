# VolumeSnapshotClass Secrets

The CSI [external-snapshotter](external-snapshotter.md) sidecar container facilitates the handling of secrets for the following operations:

* `CreateSnapshotRequest`
* `DeleteSnapshotRequest`

CSI `external-snapshotter` v1.0.1+ supports the following keys in `VolumeSnapshotClass.parameters`:

* `csi.storage.k8s.io/snapshotter-secret-name`
* `csi.storage.k8s.io/snapshotter-secret-namespace`

Cluster admins can populate the secret fields for the operations listed above with data from Kubernetes `Secret` objects by specifying these keys in the `VolumeSnapshotClass` object.

## Operations

Details for each secret supported by the external-snapshotter can be found below.

### Create/Delete VolumeSnapshot Secret

CSI `external-snapshotter` v1.0.1+ looks for the following keys in `VolumeSnapshotClass.parameters`:

* `csi.storage.k8s.io/snapshotter-secret-name`
* `csi.storage.k8s.io/snapshotter-secret-namespace`

The values of both of these parameters, together, refer to the name and namespace of a `Secret` object in the Kubernetes API.

If specified, the CSI `external-snapshotter` will attempt to fetch the secret before creation and deletion.

If the secret is retrieved successfully, the snapshotter passes it to the CSI driver in the `CreateSnapshotRequest.secrets` or `DeleteSnapshotRequest.secrets` field.

If no such secret exists in the Kubernetes API, or the snapshotter is unable to fetch it, the create operation will fail.

Note, however, that the delete operation will continue even if the secret is not found (because, for example, the entire namespace containing the secret was deleted). In this case, if the driver requires a secret for deletion, then the volume and PV may need to be manually cleaned up.

The values of these parameters may be "templates". The `external-snapshotter` will automatically resolve templates at snapshot create time, as detailed below:

* `csi.storage.k8s.io/snapshotter-secret-name`
  * `${volumesnapshotcontent.name}`
    * Replaced with name of the `VolumeSnapshotContent` object being created.
  * `${volumesnapshot.namespace}`
    * Replaced with namespace of the `VolumeSnapshot` object that triggered creation.
  * `${volumesnapshot.name}`
    * Replaced with the name of the `VolumeSnapshot` object that triggered creation.
* `csi.storage.k8s.io/snapshotter-secret-namespace`
  * `${volumesnapshotcontent.name}`
    * Replaced with name of the `VolumeSnapshotContent` object being created.
  * `${volumesnapshot.namespace}`
    * Replaced with namespace of the `VolumeSnapshot` object that triggered creation.
