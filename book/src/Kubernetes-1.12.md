# CSI with Kubernetes 1.12

In addition to the flags added in Kubernetes 1.9 to enable CSI support, a
VolumeSnapshotDataSource feature gate was added in Kubernetes 1.12 to
support restoring a volume from a volume snapshot.

To enable support for restoring a volume from a volume snapshot, the following
flags must be set explictly:

* API Server binary:

```
--allow-privileged=true
--feature-gates=CSIPersistentVolume=true,MountPropagation=true,VolumeSnapshotDataSource=true
--runtime-config=storage.k8s.io/v1alpha1=true
```

* Controller-manager binary

```
--feature-gates=CSIPersistentVolume=true,VolumeSnapshotDataSource=true
```
