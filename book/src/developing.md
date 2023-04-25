# Developing CSI Driver for Kubernetes

## Remain Informed

All developers of CSI drivers should watch the repository [https://github.com/container-storage-interface/spec](https://github.com/container-storage-interface/spec) to remain informed about changes to CSI or Kubernetes that may affect existing CSI drivers.

## Overview

The first step to creating a CSI driver is writing an application implementing the [gRPC](https://grpc.io/docs/) services described in the [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md#rpc-interface)

At a minimum, CSI drivers must implement the following CSI services:

* CSI `Identity` service
  * Enables callers (Kubernetes components and CSI sidecar containers) to identify the driver and what optional functionality it supports.
* CSI `Node` service
  * Only `NodePublishVolume`, `NodeUnpublishVolume`, and `NodeGetCapabilities` are required.
  * Required methods enable callers to make a volume available at a specified path and discover what optional  functionality the driver supports.

All CSI services may be implemented in the same CSI driver application. The CSI driver application should be containerized to make it easy to deploy on Kubernetes. Once containerized, the CSI driver can be paired with CSI [Sidecar Containers](sidecar-containers.md) and deployed in node and/or controller mode as appropriate.

## Capabilities

If your driver supports additional features, CSI "capabilities" can be used to advertise the optional methods/services it supports, for example:

* `CONTROLLER_SERVICE` (`PluginCapability`)
  * The entire CSI `Controller` service is optional. This capability indicates the driver implement one or more of the methods in the CSI `Controller` service.
* `VOLUME_ACCESSIBILITY_CONSTRAINTS` (`PluginCapability`)
  * This capability indicates the volumes for this driver may not be equally accessible from all nodes in the cluster, and that the driver will return additional topology related information that Kubernetes can use to schedule workloads more intelligently or influence where a volume will be provisioned.
* `VolumeExpansion` (`PluginCapability`)
  * This capability indicates the driver supports resizing (expanding) volumes after creation.
* `CREATE_DELETE_VOLUME` (`ControllerServiceCapability`)
  * This capability indicates the driver supports dynamic volume provisioning and deleting.
* `PUBLISH_UNPUBLISH_VOLUME` (`ControllerServiceCapability`)
  * This capability indicates the driver implements `ControllerPublishVolume` and `ControllerUnpublishVolume` -- operations that correspond to the Kubernetes volume attach/detach operations. This may, for example, result in a "volume attach" operation against the Google Cloud control plane to attach the specified volume to the specified node for the Google Cloud PD CSI Driver.
* `CREATE_DELETE_SNAPSHOT` (`ControllerServiceCapability`)
  * This capability indicates the driver supports provisioning volume snapshots and the ability to provision new volumes using those snapshots.
* `CLONE_VOLUME` (`ControllerServiceCapability`)
  * This capability indicates the driver supports cloning of volumes.
* `STAGE_UNSTAGE_VOLUME` (`NodeServiceCapability`)
  * This capability indicates the driver implements `NodeStageVolume` and `NodeUnstageVolume` -- operations that correspond to the Kubernetes volume device mount/unmount operations. This may, for example, be used to create a global (per node) volume mount of a block storage device.

This is an partial list, please see the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md) for a complete list of capabilities.
Also see the [Features](features.md) section to understand how a feature integrates with Kubernetes.
