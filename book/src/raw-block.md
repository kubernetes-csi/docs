# Raw Block Volume Feature

## Status

| Status | Min K8s Version | Max K8s Version | external-provisioner Version | external-attacher Version |
| ------ | --------------- | --------------- | ---------------------------- | ------------------------- |
| Alpha  | 1.11            | 1.13            | 0.4                          | 0.4                       |
| Alpha  | 1.13            | 1.13            | 1.0                          | 1.0                       |
| Beta   | 1.14            | -               | 1.1+                         | 1.1+                      |

## Overview

This page documents how to implement raw block volume support to a CSI Driver.

A *block volume* is a volume that will appear as a block device inside the container.
A *mounted (file) volume* is volume that will be mounted using a specified file system and appear as a directory inside the container.

The [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md) supports both block and mounted (file) volumes.

## Implementing Raw Block Volume Support in Your CSI Driver

CSI doesn't provide a capability query for block volumes, so COs will simply pass through requests for
block volume creation to CSI plugins, and plugins are allowed to fail with the `InvalidArgument` GRPC
error code if they don't support block volumes. Kubernetes doesn't make any assumptions about which CSI
plugins support blocks and which don't, so users have to know if any given storage class is capable of
creating block volumes.

The difference between a request for a mounted (file) volume and a block volume is the `VolumeCapabilities`
field of the request. Note that this field is an array and the created volume must support ALL of the
capabilities requested, or else return an error. If the `AccessType` method of a `VolumeCapability`
`VolumeCapability_Block`, then the capability is requesting a raw block volume. Unlike mount volumes, block
volumes don't have any specific capabilities that need to be validated, although access modes still
apply.

Block volumes are much more likely to support multi-node flavors of `VolumeCapability_AccessMode_Mode`
than mount volumes, because there's no file system state stored on the node side that creates any technical
impediments to multi-attaching block volumes. While there may still be good reasons to prevent
multi-attaching block volumes, and there may be implementations that are not capable of supporting
multi-attach, you should think carefully about what makes sense for your driver.

CSI plugins that support both mount and block volumes must be sure to check the capabilities of all CSI RPC
requests and ensure that the capability of the request matches the capability of the volume, to avoid trying
to do file-system-related things to block volumes and block-related things to file system volumes. The
following RPCs specify capabilities that must be validated:

* `CreateVolume()` (multiple capabilities)
* `ControllerPublishVolume()`
* `ValidateVolumeCapabilities()` (multiple capabilities)
* `GetCapacity()` (see below)
* `NodeStageVolume()`
* `NodePublishVolume()`

Also, CSI plugins that implement the optional `GetCapacity()` RPC should note that that RPC includes
capabilities too, and if the capacity for mount volumes is not the same as the capacity for block
volumes, that needs to be handled in the implementation of that RPC.

Q: Can CSI plugins support only block volumes and not mount volumes?
A: Yes! This is just the reverse case of supporting mount volumes only. Plugins may return `InvalidArgument`
for any creation request with an `AccessType` of `VolumeCapability_Mount`.

## Differences Between Block and Mount Volumes

The main difference between block volumes and mount volumes is the expected result of the `NodePublish()`.
For mount volumes, the CO expects the result to be a mounted directory, at `TargetPath`. For block volumes,
the CO expects there to be a device file at `TargetPath`. The device file can by a bind-mounted device from
the hosts `/dev` file system, or it can be a device node created at that location using `mknod()`.

It's desirable but not required to expose an unfiltered device node. For example, CSI plugins based on
technologies that implement SCSI protocols should expect that pods consuming the block volumes they create
may want to send SCSI commands to the device. This is something that should "just work" by default (subject
to container capabilities) so CSI plugins should avoid anything that would break this kind of use case. The
only hard requirement is that the device implements block reading/writing however.

For plugins with the `RPC_STAGE_UNSTAGE_VOLUME` capability, the CO doesn't care exactly what is placed at
the `StagingTargetPath`, but it's worth noting that some CSI RPCs are allowed to pass the plugin either
a staging path or a publish path, so it's important to think carefully about how `NodeStageVolume()` is
implemented, knowing that either path could get used by the CO to refer to the volume later on. This is
made more challenging because the CSI spec says that `StagingTargetPath` is always a directory even for
block volumes.

## Sidecar Deployment

The raw block feature requires the
[external-provisioner](external-provisioner.md) and
[external-attacher](external-attacher.md) sidecars to be deployed.

## Kubernetes Cluster Setup

The `BlockVolume` and `CSIBlockVolume` feature gates need to be enabled on
all Kubernetes masters and nodes.

```shell
--feature-gates=BlockVolume=true,CSIBlockVolume=true...
```

* TODO: detail how Kubernetes API raw block fields get mapped to CSI methods/fields.
