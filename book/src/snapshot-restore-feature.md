# Snapshot & Restore Feature

## Status

Status | Min K8s Version | Max K8s Version | snapshot-controller Version | CSI external-snapshotter sidecar Version | external-provisioner Version
--|--|--|--|--|--
Alpha | 1.12 | 1.12 | | 0.4.0 <= version < 1.0 | 0.4.1 <= version < 1.0
Alpha | 1.13 | 1.16 | | 1.0.1 <= version < 2.0 | 1.0.1 <= version < 1.5
Beta  | 1.17 | - | 2.0+ | 2.0+ | 1.5+

## Overview

Many storage systems provide the ability to create a "snapshot" of a persistent volume. A snapshot represents a point-in-time copy of a volume. A snapshot can be used either to provision a new volume (pre-populated with the snapshot data) or to restore the existing volume to a previous state (represented by the snapshot).

Kubernetes CSI currently enables CSI Drivers to expose the following functionality via the Kubernetes API:

1. Creation and deletion of volume snapshots via [Kubernetes native API](https://kubernetes.io/docs/concepts/storage/volume-snapshots/). 
2. Creation of new volumes pre-populated with the data from a snapshot via Kubernetes [dynamic volume provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/).

Note: Documentation under https://kubernetes.io/docs is for the latest Kubernetes release. Documentation for earlier releases are stored in different location. For example, this is the documentation location for [v1.16](https://v1-16.docs.kubernetes.io/docs/concepts/storage/volume-snapshots/).

## Implementing Snapshot & Restore Functionality in Your CSI Driver

To implement the snapshot feature, a CSI driver MUST:

* Implement the `CREATE_DELETE_SNAPSHOT` and, optionally, the `LIST_SNAPSHOTS` controller capabilities
* Implement `CreateSnapshot`, `DeleteSnapshot`, and, optionally, the `ListSnapshots`, controller RPCs.

For details,  see the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md).

## Sidecar Deployment

The Kubernetes CSI development team maintains the [external-snapshotter](external-snapshotter.md) Kubernetes CSI [Sidecar Containers](sidecar-containers.md). This sidecar container implements the logic for watching the Kubernetes API objects and issuing the appropriate CSI snapshot calls against a CSI endpoint. For more details, see [external-snapshotter documentation](external-snapshotter.md).

## Snapshot Beta
### Snapshot APIs

With the promotion of Volume Snapshot to beta, the feature is now enabled by default on standard Kubernetes deployments instead of being opt-in. This involves a revamp of volume snapshot APIs.

The schema definition for the custom resources (CRs) can be found [here](https://github.com/kubernetes-csi/external-snapshotter/blob/release-2.0/pkg/apis/volumesnapshot/v1beta1/types.go). The CRDs are no longer automatically deployed by the sidecar. They should be installed by the Kubernetes distributions.

#### Hightlights in the snapshot v1beta1 APIs

* DeletionPolicy is a required field in both VolumeSnapshotClass and VolumeSnapshotContent. This way the user has to explicitly specify it, leaving no room for confusion.
* VolumeSnapshotSpec has a required Source field. Source may be either a PersistentVolumeClaimName (if dynamically provisioning a snapshot) or VolumeSnapshotContentName (if pre-provisioning a snapshot).
* VolumeSnapshotContentSpec has a required Source field. This Source may be either a VolumeHandle (if dynamically provisioning a snapshot) or a SnapshotHandle (if pre-provisioning volume snapshots).
* VolumeSnapshot contains a Status to indicate the current state of the volume snapshot. It has a field BoundVolumeSnapshotContentName to indicate the VolumeSnapshot object is bound to a VolumeSnapshotContent.
* VolumeSnapshotContent contains a Status to indicate the current state of the volume snapshot content. It has a field SnapshotHandle to indicate that the VolumeSnapshotContent represents a snapshot on the storage system.

### Controller Split

* The CSI external-snapshotter sidecar is split into two controllers, a snapshot controller and a CSI external-snapshotter sidecar.

The snapshot controller is deployed by the Kubernetes distributions and is responsible for watching the VolumeSnapshot CRD objects and manges the creation and deletion lifecycle of snapshots.

The CSI external-snapshotter sidecar watches Kubernetes VolumeSnapshotContent CRD objects and triggers CreateSnapshot/DeleteSnapshot against a CSI endpoint.

### Kubernetes Cluster Setup

Volume snapshot is promoted to beta in Kubernetes 1.17 so the `VolumeSnapshotDataSource` feature gate is enabled by default.

See the Deployment section of [Snapshot Controller](snapshot-controller.md) on how to set up the snapshot controller and CRDs.

### Test Snapshot Feature

To test snapshot Beta version, use the following [example yaml files](https://github.com/kubernetes-csi/external-snapshotter/tree/release-2.0/examples/kubernetes).

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

#### PersistentVolumeClaim not Bound

If a `PersistentVolumeClaim` is not bound, the attempt to create a volume snapshot from that `PersistentVolumeClaim` will fail. No retries will be attempted. An event will be logged to indicate that the `PersistentVolumeClaim` is not bound.

Note that this could happen if the `PersistentVolumeClaim` spec and the `VolumeSnapshot` spec are in the same YAML file. In this case, when the `VolumeSnapshot` object is created, the `PersistentVolumeClaim` object is created but volume creation is not complete and therefore the `PersistentVolumeClaim` is not yet bound. You must wait until the `PersistentVolumeClaim` is bound and then create the snapshot.


## Snapshot Alpha
### Snapshot APIs

Similar to the API for managing [Kubernetes Persistent Volumes](https://v1-16.docs.kubernetes.io/docs/concepts/storage/persistent-volumes/), the Kubernetes Volume Snapshots introduce three new API objects for managing snapshots: `VolumeSnapshot`, `VolumeSnapshotContent`, and `VolumeSnapshotClass`. See [Kubernetes Snapshot documentation](https://v1-16.docs.kubernetes.io/docs/concepts/storage/volume-snapshots/) for more details.

Unlike the core Kubernetes Persistent Volume objects, these Snapshot objects are defined as [Custom Resource Definitions](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRDs). This is because the Kubernetes project is moving away from having resource types pre-defined in the API server. This allows the API server to be reused for projects other than Kubernetes, and consumers (like Kubernetes) simply install the resource types they require as CRDs. Because the Snapshot API types are not built in to Kubernetes, they must be installed prior to use.

The CRDs are [automatically deployed](https://github.com/kubernetes-csi/external-snapshotter/blob/release-1.2/cmd/csi-snapshotter/create_crd.go#L29) by the CSI external-snapshotter sidecar. See Alpha section of the sidecar doc [here](external-snapshotter.md).

The schema definition for the custom resources (CRs) can be found [here](https://github.com/kubernetes-csi/external-snapshotter/blob/release-1.2/pkg/apis/volumesnapshot/v1alpha1/types.go).

In addition to these new CRD objects, a new, alpha `DataSource` field has been added to the `PersistentVolumeClaim` object. This new field enables dynamic provisioning of new volumes that are automatically pre-populated with data from an existing snapshot.

### Kubernetes Cluster Setup

Since volume snapshot is an alpha feature in Kubernetes v1.12 to v1.16, you need to enable a new alpha feature gate called `VolumeSnapshotDataSource` in the Kubernetes master.

```
--feature-gates=VolumeSnapshotDataSource=true
```

### Test Snapshot Feature

To test snapshot Alpha version, use the following [example yaml files](https://github.com/kubernetes-csi/external-snapshotter/tree/release-1.2/examples/kubernetes).

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

#### PersistentVolumeClaim not Bound

If a `PersistentVolumeClaim` is not bound, the attempt to create a volume snapshot from that `PersistentVolumeClaim` will fail. No retries will be attempted. An event will be logged to indicate that the `PersistentVolumeClaim` is not bound.

Note that this could happen if the `PersistentVolumeClaim` spec and the `VolumeSnapshot` spec are in the same YAML file. In this case, when the `VolumeSnapshot` object is created, the `PersistentVolumeClaim` object is created but volume creation is not complete and therefore the `PersistentVolumeClaim` is not yet bound. You must wait until the `PersistentVolumeClaim` is bound and then create the snapshot.

## Examples

See the [Drivers](drivers.md) for a list of CSI drivers that implement the snapshot feature.
