# Volume Cloning

## Status and Releases

Status | Min k8s Version | Max k8s version | external-provisioner Version
--|--|--|--
Alpha | 1.15 | - | 1.3

## Overview

A Clone is defined as a duplicate of an existing Kubernetes Volume.  For more information on cloning in Kubernetes see the concepts doc for [Volume Cloning](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#volume-cloning).  A storage provider that allows volume cloning as a create feature, may choose to implement volume cloning via a control-plan CSI RPC call.

For details regarding the kuberentes API for volume cloning, please see [kubernetes concepts](https://kubernetes.io/docs/concepts/storage/volume-pvc-datasource/).

## Cloning Restrictions

Clone operations assume the cloning of a volume is being performed by the storage device, often referred to as `smart cloning`.  Implementations that transfer data (ie creating a container, mounting volumes and performing a dd) are considered `Populators` and not cloning implementations.  In addition to the expectation that the actual clone operation is performed by the storage device, cloning is also restricted to a single storage class.  In other words, the destination volume *must* be in the same Storage Class as the volume specified in the `dataSource` parameter.  This may seem unnecessary for devices or plugins that manage multiple storage classes, and while the check could instead be on the `Provisioner` field of a storage class, allowing this would break how storage classes work.

One example of how this creates a problem is due to the way we use a storage class to define a file system type.  If for example a deployment includes a storage class for xfs and another for ext4, cloning from an xfs volume to an ext4 volume may work fine from the storage devices perspective, however a user ends up with an xfs formatted volume in the ext4 storage class.  There are other situations where the storage class defines specific characteristics for a volume that would likely be lost if cloning between them; block-mode, qos settings, credentials etcetera.

## Implementing Volume cloning functionality

To implement volume cloning the CSI driver MUST:

1. Implement checks for `csi.CreateVolumeRequest.VolumeContentSource` in the plugin's `CreateVolume` function implementation.
2. Implement `CLONE_VOLUME` controller capability.

It is the responsibility of the storage plugin to either implement an expansion after clone if a provision request size is greater than the source, or allow the external-resizer to handle it.  In the case that the plugin does not support resize capability and it does not have the capability to create a clone that is greater in size than the specified source volume, then the provision request should result in a failure.

## Deploying volume clone functionality

The Kubernetes CSI development team maintains the [external-provisioner](external-provisioner.md) which is responsible for detecting requests for a PVC DataSource and providing that information to the plugin via the `csi.CreateVolumeRequest`.  It's up to the plugin to check the `csi.CreateVolumeRequest` for a `VolumeContentSource` entry in the CreateVolumeRequest object.

There are no additional side-cars or add on components required.

## Enabling Cloning for CSI volumes in Kubernetes

Volume cloning for CSI volumes is an alpha feature (Kubernetes 1.15) and hence must be explicitly enabled via feature gate:

```
--feature-gates=VolumePVCDataSource=true
```

## Example implementation

A trivial example implementation can be found in the [csi-hostpath plugin](https://github.com/kubernetes-csi/csi-driver-host-path) in its implementation of `CreateVolume`.

