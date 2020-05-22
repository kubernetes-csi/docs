# Skip Kubernetes Attach and Detach

## Status

| Status | Min K8s Version | Max K8s Version | cluster-driver-registrar Version |
| ------ | --------------- | --------------- | -------------------------------- |
| Alpha  | 1.12            | 1.12            | 0.4                              |
| Alpha  | 1.13            | 1.13            | 1.0                              |
| Beta   | 1.14            | 1.17            | n/a                              |
| GA     | 1.18            | -               | n/a                              |

## Overview

Volume drivers, like NFS, for example, have no concept of an attach (`ControllerPublishVolume`). However, Kubernetes always executes `Attach` and `Detach` operations even if the CSI driver does not implement an attach operation (i.e. even if the CSI Driver does not implement a `ControllerPublishVolume` call).

This was problematic because it meant *all* CSI drivers had to handle Kubernetes attachment. CSI Drivers that did not implement the `PUBLISH_UNPUBLISH_VOLUME` controller capability could work around this by deploying an [external-attacher](external-attacher.md) and the `external-attacher` would responds to Kubernetes attach operations and simply do a noop (because the CSI driver did not advertise the `PUBLISH_UNPUBLISH_VOLUME` controller capability).

Although the workaround works, it adds an unnecessary operation (round-trip) in the preparation of a volume for a container, and requires CSI Drivers to deploy an unnecessary sidecar container (`external-attacher`).

## Skip Attach with CSI Driver Object

The [CSIDriver Object](csi-driver-object.md) enables CSI Drivers to specify how Kubernetes should interact with it.

Specifically the `attachRequired` field instructs Kubernetes to skip any attach operation altogether.

For example, the existence of the following object would cause Kubernetes to skip attach operations for all CSI Driver `testcsidriver.example.com` volumes.

```shell
apiVersion: storage.k8s.io/v1
kind: CSIDriver
metadata:
  name: testcsidriver.example.com
spec:
  attachRequired: false
```

CSIDriver object should be manually included in the driver deployment manifests.

Previously, the [cluster-driver-registrar](cluster-driver-registrar.md) sidecar container could be deployed to automatically create the object. Once the flags to this container are configured correctly, it will automatically create a [CSIDriver Object](csi-driver-object.md) when it starts with the correct fields set.

## Alpha Functionality

In alpha, this feature was enabled via the [CSIDriver Object](csi-driver-object.md) CRD.

```shell
apiVersion: csi.storage.k8s.io/v1alpha1
kind: CSIDriver
metadata:
....
```
