# Snapshot & Restore Feature

**Status:** Alpha

Many storage systems provide the ability to create a "snapshot" of a persistent volume. A snapshot represents a point-in-time copy of a volume. A snapshot can be used either to provision a new volume (pre-populated with the snapshot data) or to restore the existing volume to a previous state (represented by the snapshot).

Kubernetes CSI currently enables CSI Drivers to expose the following functionality via the Kubernetes API:

1. Creation and deletion of volume snapshots via [Kubernetes native API](https://kubernetes.io/docs/concepts/storage/volume-snapshots/). 
2. Creation of new volumes pre-populated with the data from a snapshot via Kubernetes [dynamic volume provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/).

## Implementing Snapshot & Restore Functionality

To implement the snapshot feature, a CSI driver MUST:

* Implement the `CREATE_DELETE_SNAPSHOT` and, optionally, the `LIST_SNAPSHOTS` controller capabilities
* Implement `CreateSnapshot`, `DeleteSnapshot`, and, optionally, the `ListSnapshots`, controller RPCs.

For details,  see the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md).

## Deploying Snapshot & Restore Functionality

The Kubernetes CSI development team maintains the [external-snapshotter](external-snapshotter.md) Kubernetes CSI [Sidecar Containers](sidecar-containers.md). This sidecar container implements the logic for watching the Kubernetes API for snapshot objects and issuing the appropriate CSI snapshot calls against a CSI endpoint. For more details, see [external-snapshotter documentation](external-snapshotter.md).

## Snapshot APIs

Similar to the API for managing [Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/), the Kubernetes Volume Snapshots introduce three new API objects for managing snapshots: `VolumeSnapshot`, `VolumeSnapshotContent`, and `VolumeSnapshotClass`. See [Kubernetes Snapshot documentation](https://kubernetes.io/docs/concepts/storage/volume-snapshots/) for more details.

Unlike the core Kubernetes Persistent Volume objects, these Snapshot objects are defined as [Custom Resource Definitions](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRDs). This is because the Kubernetes project is moving away from having resource types pre-defined in the API server. This allows the API server to be reused for projects other than Kubernetes, and consumers (like Kubernetes) simply install the resource types they require as CRDs. Because the Snapshot API types are not built in to Kubernetes, they must be installed prior to use.

The CRDs are [automatically deployed](https://github.com/kubernetes-csi/external-snapshotter/blob/master/cmd/csi-snapshotter/create_crd.go#L29) by the CSI [external-snapshotter](external-snapshotter.md) sidecar.

The schema definition for the custom resources (CRs) can be found here: https://github.com/kubernetes-csi/external-snapshotter/blob/master/pkg/apis/volumesnapshot/v1alpha1/types.go

In addition to these new CRD objects, a new, alpha `DataSource` field has been added to the `PersistentVolumeClaim` object. This new field enables dynamic provisioning of new volumes that are automatically pre-populated with data from an existing snapshot.

Since volume snapshot is an alpha feature in Kubernetes v1.12, you need to enable a new alpha feature gate called `VolumeSnapshotDataSource` in the Kubernetes API server binary.

```
--feature-gates=VolumeSnapshotDataSource=true
```

## Test Snapshot Feature

Use the following [example yaml files](https://github.com/kubernetes-csi/external-snapshotter/tree/master/examples/kubernetes) to test the snapshot feature.

Create a _StorageClass_:
```
kubectl create -f storageclass.yaml
```

Create a _PVC_:
```
kubectl create -f pvc.yaml
```

Create a _VolumeSnapshotClass_:
```
kubectl create -f snapshotclass.yaml
```

Create a _VolumeSnapshot_:
```
kubectl create -f snapshot.yaml
```

Create a _PVC_ from a _VolumeSnapshot_:
```
kuberctl create -f restore.yaml
```

### PersistentVolumeClaim not Bound

If a `PersistentVolumeClaim` is not bound, the attempt to create a volume snapshot from that `PersistentVolumeClaim` will fail. No retries will be attempted. An event will be logged to indicate that the `PersistentVolumeClaim` is not bound.

Note that this could happen if the `PersistentVolumeClaim` spec and the `VolumeSnapshot` spec are in the same YAML file. In this case, when the `VolumeSnapshot` object is created, the `PersistentVolumeClaim` object is created but volume creation is not complete and therefore the `PersistentVolumeClaim` is not yet bound. You must wait until the `PersistentVolumeClaim` is bound and then create the snapshot.

## Examples

See the [Drivers](drivers.md) for a list of CSI drivers that implement the snapshot feature.
