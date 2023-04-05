# Volume Group Snapshot Feature

## Status

Status | Min K8s Version | Max K8s Version | snapshot-controller Version | snapshot-validation-webhook Version | CSI external-snapshotter sidecar Version | external-provisioner Version
--|--|--|--|--|--|--
Alpha  | 1.27 | - | 7.0+ | 7.0+ | 7.0+ | 3.5+

## Overview

Some storage systems provide the ability to create a crash consistent snapshot of
multiple volumes. A group snapshot represents “copies” from multiple volumes that
are taken at the same point-in-time. A group snapshot can be used either to rehydrate
new volumes (pre-populated with the snapshot data) or to restore existing volumes to
a previous state (represented by the snapshots).

Kubernetes CSI currently enables CSI Drivers to expose the following functionality via the Kubernetes API:

1. Creation and deletion of volume group snapshots via [Kubernetes native API](https://github.com/kubernetes-csi/external-snapshotter/tree/master/client/apis/volumegroupsnapshot/v1alpha1). 
2. Creation of new volumes pre-populated with the data from a snapshot that is part of the volume group snapshot via Kubernetes [dynamic volume provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/).

## Implementing Volume Group Snapshot Functionality in Your CSI Driver

To implement the volume group snapshot feature, a CSI driver MUST:

* Implement a new group controller service.
* Implement group controller RPCs: `CreateVolumeGroupSnapshot`, `DeleteVolumeGroupSnapshot`, and `GetVolumeGroupSnapshot`.
* Add group controller capability `CREATE_DELETE_GET_VOLUME_GROUP_SNAPSHOT`.

For details,  see the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md).

## Sidecar Deployment

The Kubernetes CSI development team maintains the [external-snapshotter](external-snapshotter.md) Kubernetes CSI [Sidecar Containers](sidecar-containers.md). This sidecar container implements the logic for watching the Kubernetes API objects and issuing the appropriate CSI volume group snapshot calls against a CSI endpoint. For more details, see [external-snapshotter documentation](external-snapshotter.md).

## Volume Group Snapshot APIs

With the introduction of Volume Group Snapshot, the user can create and delete a group snapshot using Kubernetes APIs. 

The schema definition for the custom resources (CRs) can be found [here](https://github.com/kubernetes-csi/external-snapshotter/tree/master/client/config/crd). The CRDs should be installed by the Kubernetes distributions.

There are 3 APIs:

`VolumeGroupSnapshot`
: Created by a Kubernetes user (or perhaps by your own automation) to request
creation of a volume group snapshot for multiple volumes.
It contains information about the volume group snapshot operation such as the
timestamp when the volume group snapshot was taken and whether it is ready to use.
The creation and deletion of this object represents a desire to create or delete a
cluster resource (a group snapshot).

`VolumeGroupSnapshotContent`
: Created by the snapshot controller for a dynamically created VolumeGroupSnapshot.
It contains information about the volume group snapshot including the volume group
snapshot ID.
This object represents a provisioned resource on the cluster (a group snapshot).
The VolumeGroupSnapshotContent object binds to the VolumeGroupSnapshot for which it
was created with a one-to-one mapping.

`VolumeGroupSnapshotClass`
: Created by cluster administrators to describe how volume group snapshots should be
created. including the driver information, the deletion policy, etc.

## Controller

* The controller logic for volume group snapshot is added to the snapshot controller and the CSI external-snapshotter sidecar.

The snapshot controller is deployed by the Kubernetes distributions and is responsible for watching the VolumeGroupSnapshot CRD objects and manges the creation and deletion lifecycle of volume group snapshots.

The CSI external-snapshotter sidecar watches Kubernetes VolumeGroupSnapshotContent CRD objects and triggers CreateVolumeGroupSnapshot/DeleteVolumeGroupSnapshot against a CSI endpoint.

## Snapshot Validation Webhook

The validating webhook server is updated to validate volume group snapshot objects. This SHOULD be installed by the Kubernetes distros along with the snapshot-controller, not end users. It SHOULD be installed in all Kubernetes clusters that has the volume group snapshot feature enabled. See [Snapshot Validation Webhook](snapshot-validation-webhook.md) for more details on how to use the webhook.

## Kubernetes Cluster Setup

See the Deployment section of [Snapshot Controller](snapshot-controller.md) on how to set up the snapshot controller and CRDs.

See the Deployment section of [Snapshot Validation Webhook](snapshot-validation-webhook.md) for more details on how to use the webhook.

## Test Volume Group Snapshot Feature

To test volume group snapshot version, use the following [example yaml files](https://github.com/kubernetes-csi/external-snapshotter/tree/master/examples/kubernetes).

Create a _StorageClass_:
```
kubectl create -f storageclass.yaml
```

Create _PVC_:
```
kubectl create -f pvc.yaml
kubectl create -f pvc2.yaml
```

Add a label to _PVC_:
```
kubectl label pvcs <your-pvc-name> group:my-apps
```

Create a _VolumeGroupSnapshotClass_:
```
kubectl create -f group-snapshot-class.yaml
```

Create a _VolumeGroupSnapshot_:
```
kubectl create -f group-snapshot.yaml
```

Create a _PVC_ from a _VolumeSnapshot_ that is part of the group snapshot:
```
kubectl create -f restore-from-snapshot-in-group.yaml
```

## Examples

See the [Drivers](drivers.md) for a list of CSI drivers that implement the snapshot feature.
