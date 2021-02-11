# Pod Inline Volume Support

## Status

### CSI Ephemeral Inline Volumes

Status | Min K8s Version | Max K8s Version
--|--|--
Alpha | 1.15 | 1.15
Beta | >=1.16 | -

### Generic Ephemeral Inline Volumes

Status | Min K8s Version | Max K8s Version
--|--|--
Alpha | 1.19 | -

## Overview
Traditionally, volumes that are backed by CSI drivers can only be used
with a `PersistentVolume` and `PersistentVolumeClaim` object
combination. Two different Kubernetes features allow volumes to follow
the Pod's lifecycle: CSI ephemeral volumes and generic ephemeral
volumes.

In both features, the volumes are specified directly in the pod
specification for ephemeral use cases.  At runtime, nested inline
volumes follow the ephemeral lifecycle of their associated pods where
Kubernetes and the driver handle all phases of volume operations as
pods are created and destroyed.

However, the two features are targeted at different use cases and thus
have different APIs and different implementations.

> See the [CSI inline
> volumes](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/596-csi-inline-volumes)
> and [generic ephemeral
> volumes](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1698-generic-ephemeral-volumes)
> enhancement proposals for design details. The user facing
> documentation for both features is in the [Kubernetes
> documentation](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/).


## Which feature should my driver support?

CSI ephemeral inline volumes are meant for simple, local volumes. All
parameters that determine the content of the volume can be specified
in the pod spec, and only there. Storage classes are not supported and
all parameters are driver specific.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: some-pod
spec:
  containers:
    ...
  volumes:
      - name: vol
        csi:
          driver: inline.storage.kubernetes.io
          volumeAttributes:
              foo: bar
```

A CSI driver is suitable for CSI ephemeral inline volumes if:
- it serves a special purpose and needs custom per-volume parameters,
  like drivers that provide secrets to a pod
- it can create volumes when running on a node
- fast volume creation is needed
- resource usage on the node is small and/or does not need to be exposed
  to Kubernetes
- rescheduling of pods onto a different node when storage capacity
  turns out to be insufficient is not needed
- none of the usual volume features (restoring from snapshot,
  cloning volumes, etc.) are needed
- ephemeral inline volumes have to be supported on Kubernetes clusters
  which do not support generic ephemeral volumes

A CSI driver is not suitable for CSI ephemeral inline volumes when:
- provisioning is not local to the node
- ephemeral volume creation requires volumeAttributes that should be restricted
  to an administrator, for example parameters that are otherwise set in a
  StorageClass or PV. Ephemeral inline volumes allow these attributes to be set
  directly in the Pod spec, and so are not restricted to an admin.

Generic ephemeral inline volumes make the normal volume API (storage
classes, `PersistentVolumeClaim`) usable for ephemeral inline
volumes.

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: some-pod
spec:
  containers:
     ...
  volumes:
    - name: scratch-volume
      ephemeral:
        volumeClaimTemplate:
          metadata:
            labels:
              type: my-frontend-volume
          spec:
            accessModes: [ "ReadWriteOnce" ]
            storageClassName: "scratch-storage-class"
            resources:
              requests:
                storage: 1Gi
```

A CSI driver is suitable for generic ephemeral inline volumes if it
supports dynamic provisioning of volumes. No other changes are needed
in the driver in that case. Such a driver can also support CSI
ephemeral inline volumes if desired.

## Implementing CSI ephemeral inline support

Drivers must be modified (or implemented specifically) to support CSI inline
ephemeral workflows. When Kubernetes encounters an inline CSI volume embedded
in a pod spec, it treats that volume differently. Mainly, the driver will only
receive `NodePublishVolume`, during the volume's mount phase, and `NodeUnpublishVolume` when
the pod is going away and the volume is unmounted.

Due to these requirements, ephemeral volumes will not be created using the [Controller
Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#controller-service-rpc),
but the [Node
Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#node-service-rpc),
instead. When the
[kubelet](https://github.com/kubernetes/kubernetes/blob/70132b0f130acc0bed193d9ba59dd186f0e634cf/pkg/volume/csi/csi_mounter.go#L329)
calls _NodePublishVolume_, it is the responsibility of the CSI driver to create the
volume during that call, then publish the volume to the specified location. When
the `kubelet` calls _NodeUnpublishVolume_, it is the responsibility of the CSI
driver to delete the volume.

To support inline, a driver must implement the followings:

- Identity service
- Node service

### CSI Extension Specification

#### [NodePublishVolume](https://github.com/container-storage-interface/spec/blob/master/spec.md#nodepublishvolume)

##### Arguments

* **`volume_id`**: Volume ID will be created by the Kubernetes and passed to the
  driver by the kubelet.
* **`volume_context["csi.storage.k8s.io/ephemeral"]`**: This value will be
  available and it will be equal to `"true"`.

##### Workflow

The driver will receive the appropriate arguments as defined above when an
ephemeral volume is requested. The driver will create and publish the volume
to the specified location as noted in the _NodePublishVolume_ request. Volume
size and any other parameters required will be passed in verbatim from the
inline manifest parameters to the `NodePublishVolumeRequest.volume_context`.

There is no guarantee that NodePublishVolume will be called again after a
failure, regardless of what the failure is. To avoid leaking resources, a CSI
driver must either always free all resources before returning from
NodePublishVolume on error or implement some kind of garbage collection.

#### [NodeUnpublishVolume](https://github.com/container-storage-interface/spec/blob/master/spec.md#nodeunpublishvolume)

##### Arguments

No changes

##### Workflow

The driver is responsible of deleting the ephemeral volume once it has
unpublished the volume. It MAY delete the volume before finishing the request,
or after the request to unpublish is returned.

### CSIDriver

Kubernetes 1.16 only allows using a CSI driver for an inline volume if
its [`CSIDriver`](csi-driver-object.md) object explicitly declares
that the driver supports that kind of usage in its
`volumeLifecycleModes` field. This is a safeguard against accidentally
[using a driver the wrong way](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/20190122-csi-inline-volumes.md#support-for-inline-csi-volumes).

### Feature gates

To use inline volume, Kubernetes 1.15 binaries must start with the `CSIInlineVolume` feature gate enabled:
```
--feature-gates=CSIInlineVolume=true
```

Kubernetes >= 1.16 no longer needs this as the feature is enabled by default.

## References

- [CSI Host Path
  driver ephemeral volumes support](https://github.com/kubernetes-csi/csi-driver-host-path/blob/9fdddc2061b9013286e01189b2bf3268276af99b/pkg/hostpath/nodeserver.go#L63-L82)
- [Issue 82507: Drop VolumeLifecycleModes field from CSIDriver API before
  GA](https://github.com/kubernetes/kubernetes/issues/82507)
- [Issue 75222: CSI Inline - Update CSIDriver to indicate driver
  mode](https://github.com/kubernetes/kubernetes/issues/75222)
- [CSIDriver support for ephemeral volumes](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#csidriver-v1-storage-k8s-io)
- [CSI Hostpath driver](https://github.com/kubernetes-csi/csi-driver-host-path) - an example driver that supports both modes and determines the mode on a case-by-case basis (for Kubernetes 1.16) or can be deployed with support for just one of the two modes (for Kubernetes 1.15).
- [Image populator plugin](https://github.com/kubernetes-csi/csi-driver-image-populator) - an example CSI driver plugin that uses a container image as a volume.
