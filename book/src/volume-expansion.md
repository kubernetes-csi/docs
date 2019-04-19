# Volume Expansion

## Status

* Kubernetes 1.14: Alpha

## Overview

A storage provider that allows volume expansion after creation, may choose to implement volume expansion either via a
control-plane CSI RPC call or via node CSI RPC call or both as a two step process.

## Implementing Volume expansion functionality

To implement volume expansion the CSI driver MUST:

1. Implement `VolumeExpansion` plugin capability.
2. Implement `EXPAND_VOLUME` controller capability or implement `EXPAND_VOLUME` node capability or both.

`ControllerExpandVolume` RPC call can be made when volume is `ONLINE` or `OFFLINE` depending on `VolumeExpansion` plugin
capability. Where `ONLINE` and `OFFLINE` means:

1. *ONLINE* : Volume is currently published or available on a node.
2. *OFFLINE* : Volume is currently not published or available on a node.

`NodeExpandVolume` RPC call on the other hand - *always* requires volume to be published or staged on a node (and hence `ONLINE`).
For block storage file systems - `NodeExpandVolume` is typically used for expanding the file system on the node, but it can be also
used to perform other volume expansion related housekeeping operations on the node.

For details,  see the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md).

## Deploying volume expansion functionality

The Kubernetes CSI development team maintains [external-resizer](external-resizer.md) Kubernetes CSI [Sidecar Containers](sidecar-containers.md).
This sidecar container implements the logic for watching the Kubernetes API for Persistent Volume claim edits and issuing `ControllerExpandVolume` RPC call against a CSI endpoint and updating `PersistentVolume` object to reflect new size.

This sidecar is needed even if CSI driver does not have `EXPAND_VOLUME` controller capability, in this case it performs a NO-OP expansion and updates `PersistentVolume` object. `NodeExpandVolume` is always called by Kubelet on the node.

For more details, see [external-resizer](external-resizer.md).


## Enabling Volume expansion for CSI volumes in Kubernetes

To expand a volume if permitted by the [storage class](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#expanding-persistent-volumes-claims), users just need to edit the persistent volume claim object and request more storage. Volume expansion for CSI volumes is an alpha feature and hence
also must be explicitly enabled via feature gate:

```
--feature-gates=ExpandCSIVolumes=true
```

To enable online expansion of CSI persistent volumes, we also need to enable online expansion feature gate:

```
--feature-gates=ExpandInUsePersistentVolumes=true
```

It is expected that external-resizer and kubelet will add appropriate events and conditions to persistent volume claim object to indicate
progress of volume expansion operation.
