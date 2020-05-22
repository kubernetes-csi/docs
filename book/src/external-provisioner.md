# CSI external-provisioner

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-provisioner](https://github.com/kubernetes-csi/external-provisioner)

**Status:** GA/Stable

| Latest stable release                                                                                     | Branch                                                                                 | Min CSI Version                                                                   | Max CSI Version                                                                   | Container Image                       | [Min K8s Version](kubernetes-compatibility.md#minimum-version) | [Max K8s Version](kubernetes-compatibility.md#maximum-version) | [Recommended K8s Version](kubernetes-compatibility.md#recommended-version) |
| --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------- |
| [external-provisioner v1.6.0](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v1.6.0) | [release-1.6](https://github.com/kubernetes-csi/external-provisioner/tree/release-1.6) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | -                                                                                 | quay.io/k8scsi/csi-provisioner:v1.6.0 | v1.13                                                          | -                                                              | v1.18                                                                      |
| [external-provisioner v1.5.0](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v1.5.0) | [release-1.5](https://github.com/kubernetes-csi/external-provisioner/tree/release-1.5) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | -                                                                                 | quay.io/k8scsi/csi-provisioner:v1.5.0 | v1.13                                                          | -                                                              | v1.17                                                                      |
| [external-provisioner v1.4.0](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v1.4.0) | [release-1.4](https://github.com/kubernetes-csi/external-provisioner/tree/release-1.4) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | -                                                                                 | quay.io/k8scsi/csi-provisioner:v1.4.0 | v1.13                                                          | -                                                              | v1.16                                                                      |
| [external-provisioner v1.3.1](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v1.3.1) | [release-1.3](https://github.com/kubernetes-csi/external-provisioner/tree/release-1.3) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | -                                                                                 | quay.io/k8scsi/csi-provisioner:v1.3.1 | v1.13                                                          | v1.19                                                          | v1.15                                                                      |
| [external-provisioner v1.2.0](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v1.2.2) | [release-1.2](https://github.com/kubernetes-csi/external-provisioner/tree/release-1.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | -                                                                                 | quay.io/k8scsi/csi-provisioner:v1.2.0 | v1.13                                                          | v1.19                                                          | v1.14                                                                      |
| [external-provisioner v0.4.2](https://github.com/kubernetes-csi/external-provisioner/releases/tag/v0.4.2) | [release-0.4](https://github.com/kubernetes-csi/external-provisioner/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/csi-provisioner:v0.4.2 | v1.10                                                          | v1.16                                                          | v1.10                                                                      |

## Description

The CSI `external-provisioner` is a sidecar container that watches the Kubernetes API server for `PersistentVolumeClaim` objects.

It calls `CreateVolume` against the specified CSI endpoint to provision a new volume.

Volume provisioning is triggered by the creation of a new Kubernetes `PersistentVolumeClaim` object, if the PVC references a Kubernetes `StorageClass`, and the name in the `provisioner` field of the storage class matches the name returned by the specified CSI endpoint in the `GetPluginInfo` call.

Once a new volume is successfully provisioned, the sidecar container creates a Kubernetes `PersistentVolume` object to represent the volume.

The deletion of a `PersistentVolumeClaim` object bound to a `PersistentVolume` corresponding to this driver with a `delete` reclaim policy causes the sidecar container to trigger a `DeleteVolume` operation against the specified CSI endpoint to delete the volume. Once the volume is successfully deleted, the sidecar container also deletes the `PersistentVolume` object representing the volume.

### DataSources

The external-provisioner provides the ability to request a volume be pre-populated from a data source during provisioning.
For more information on how data sources are handled see [DataSources](volume-datasources.md).

#### Snapshot

The CSI `external-provisioner` supports the `Snapshot` DataSource. If a `Snapshot` CRD is specified as a data source on a PVC object, the sidecar container fetches the information about the snapshot by fetching the `SnapshotContent` object and populates the data source field in the resulting `CreateVolume` call to indicate to the storage system that the new volume should be populated using the specified snapshot.

#### PersistentVolumeClaim (clone)

Cloning is also implemented by specifying a `kind:` of type `PersistentVolumeClaim` in the DataSource field of a Provision request.  It's the responsbility of the external-provisioner to verify that the claim specified in the DataSource object exists, is in the same storage class as the volume being provisioned and that the claim is currently `Bound`.

### StorageClass Parameters

When provisioning a new volume, the CSI `external-provisioner` sets the `map<string, string> parameters` field in the CSI `CreateVolumeRequest` call to the key/values specified in the `StorageClass` it is handling.

The CSI `external-provisioner` (v1.0.1+) also reserves the parameter keys prefixed with `csi.storage.k8s.io/`. Any keys prefixed with `csi.storage.k8s.io/` are not passed to the CSI driver as an opaque `parameter`.

The following reserved `StorageClass` parameter keys trigger behavior in the CSI `external-provisioner`:

* `csi.storage.k8s.io/provisioner-secret-name`
* `csi.storage.k8s.io/provisioner-secret-namespace`
* `csi.storage.k8s.io/controller-publish-secret-name`
* `csi.storage.k8s.io/controller-publish-secret-namespace`
* `csi.storage.k8s.io/node-stage-secret-name`
* `csi.storage.k8s.io/node-stage-secret-namespace`
* `csi.storage.k8s.io/node-publish-secret-name`
* `csi.storage.k8s.io/node-publish-secret-namespace`
* `csi.storage.k8s.io/fstype`

If the PVC `VolumeMode` is set to `Filesystem`, and the value of `csi.storage.k8s.io/fstype` is specified, it is used to populate the `FsType` in `CreateVolumeRequest.VolumeCapabilities[x].AccessType` and the `AccessType` is set to `Mount`.

For more information on how secrets are handled see [Secrets & Credentials](secrets-and-credentials.md).

Example `StorageClass`:

```shell
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gold-example-storage
provisioner: exampledriver.example.com
parameters:
  disk-type: ssd
  csi.storage.k8s.io/fstype: ext4
  csi.storage.k8s.io/provisioner-secret-name: mysecret
  csi.storage.k8s.io/provisioner-secret-namespace: mynamespace
```

## Usage

CSI drivers that support dynamic volume provisioning should use this sidecar container, and advertise the CSI `CREATE_DELETE_VOLUME` controller capability.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-provisioner/blob/master/README.md](https://github.com/kubernetes-csi/external-provisioner/blob/master/README.md).

## Deployment

The CSI `external-provisioner` is deployed as a controller. See [deployment section](deploying.md) for more details.
