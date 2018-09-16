# Implement Snapshot Feature

To implement the snapshot feature, a CSI driver needs to support additional controller capabilities CREATE_DELETE_SNAPSHOT and LIST_SNAPSHOTS, and implement additional controller RPCs CreateSnapshot, DeleteSnapshot, and ListSnapshots. For details,  see the CSI spec [here](https://github.com/container-storage-interface/spec/blob/master/spec.md).

Here are some example CSI plugins that have implemented the snapshot feature:
* [GCE PD CSI driver](https://github.com/kubernetes-sigs/gcp-compute-persistent-disk-csi-driver)
* [OpenSDS CSI driver](https://github.com/opensds/nbp/tree/master/csi/server)
* [Ceph RBD CSI driver](https://github.com/ceph/ceph-csi/tree/master/pkg/rbd)

You can find more sample and production CSI drivers [here](https://kubernetes-csi.github.io/docs/Drivers.html). Please note that drivers may or may not have implemented the snapshot feature.

## Snapshot APIs

The volume snapshot APIs are implemented as CRDs [here](https://github.com/kubernetes-csi/external-snapshotter/tree/master/pkg/apis/volumesnapshot/v1alpha1). Once you deploy the CSI driver which includes the external snapshotter in your cluster, the external-snapshotter will pre-install the Snapshot CRDs.

## Enable VolumeSnapshotDataSource Feature Gate

Since volume snapshot is an alpha feature in Kubernetes v1.12, you need to enable a new alpha feature gate called VolumeSnapshotDataSource in API server binary.
```
--feature-gates=VolumeSnapshotDataSource=true
```

## Deploy External-Snapshotter with CSI Driver

The snapshot controller is implemented as a sidecar helper container called [External-Snapshotter](https://github.com/kubernetes-csi/external-snapshotter). _External-Snapshotter_ watches _VolumeSnapshot_ and _VolumeSnapshotContent_ API objects and triggers _CreateSnapshot_ and _DeleteSnapshot_ operations.

It is recommended that sidecar containers _External-Snapshotter_ and _External-Provisioner_ be deployed together with CSI driver in a StatefulSet. See this [example yaml file](https://github.com/kubernetes-csi/external-snapshotter/tree/master/deploy/kubernetes/setup-csi-snapshotter.yaml) which deploys _External-Snapshotter_ and _External-Provisioner_ with the Hostpath CSI driver. Run the following command to start the sidecar containers and the CSI driver:
```
kubectl create -f setup-csi-snapshotter.yaml
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

### PVC not Bound

If a PVC is not bound, the attempt to create a volume snapshot from that PVC will fail. No retries will be attempted. An event will be logged to indicate that the PVC is not bound.

Note that this could happen if the PVC spec and the VolumeSnapshot spec are in the same yaml file. In this case, when the VolumeSnapshot object is created, the PVC object is created but volume creation is not complete and therefore PVC is not bound yet. You need to wait until the PVC is bound and try again.
