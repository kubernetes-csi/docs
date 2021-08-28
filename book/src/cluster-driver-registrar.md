# CSI cluster-driver-registrar

## Deprecated

This sidecar container was not updated since Kubernetes 1.13. As of Kubernetes
1.16, this side car container is officially deprecated.

The purpose of this side car container was to automatically register
a _CSIDriver_ object containing information about the driver with Kubernetes.
Without this side car, developers and CSI driver vendors will now have to add
a CSIDriver object in their installation manifest or any tool that installs
their CSI driver.

Please see [CSIDriver](csi-driver-object.md) for more information.

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/cluster-driver-registrar](https://github.com/kubernetes-csi/cluster-driver-registrar)

**Status:** Alpha

Latest stable release | Branch | Compatible with CSI Version | Container Image | Min k8s Version | Max k8s version
--|--|--|--|--|--
[cluster-driver-registrar v1.0.1](https://github.com/kubernetes-csi/cluster-driver-registrar/releases/tag/v1.0.1) | [release-1.0](https://github.com/kubernetes-csi/cluster-driver-registrar/tree/release-1.0) |  [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | quay.io/k8scsi/csi-cluster-driver-registrar:v1.0.1 | v1.13 | -
[driver-registrar v0.4.2](https://github.com/kubernetes-csi/driver-registrar/releases/tag/v0.4.2) | [release-0.4](https://github.com/kubernetes-csi/driver-registrar/tree/release-0.4) | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0) | quay.io/k8scsi/driver-registrar:v0.4.2 | v1.10 | -

## Description

The CSI `cluster-driver-registrar` is a sidecar container that registers a CSI Driver with a Kubernetes cluster by creating a [CSIDriver Object](csi-driver-object.md) which enables the driver to customize how Kubernetes interacts with it.

## Usage

CSI drivers that use one of the following Kubernetes features should use this sidecar container:

* [Skip Attach](skip-attach.md)
  * For drivers that don't support [`ControllerPublishVolume`](https://github.com/container-storage-interface/spec/blob/master/spec.md#controllerpublishvolume), this indicates to Kubernetes to skip the attach operation and eliminates the need to deploy the `external-attacher` sidecar.
* [Pod Info on Mount](pod-info.md)
  * This causes Kubernetes to pass metadata such as Pod name and namespace to the `NodePublishVolume` call.

If you are not using one of these features, this sidecar container (and the creation of the [CSIDriver Object](csi-driver-object.md)) is not required. However, it is still recommended, because the [CSIDriver Object](csi-driver-object.md) makes it easier for users to easily discover the CSI drivers installed on their clusters.

For detailed information (binary parameters, etc.), see the README of the relevant branch.

## Deployment

The CSI `cluster-driver-registrar` is deployed as a controller. See [deployment section](deploying.md) for more details.
