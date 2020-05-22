# Pod Info on Mount

## Status

| Status | Min K8s Version | Max K8s Version | cluster-driver-registrar Version |
| ------ | --------------- | --------------- | -------------------------------- |
| Alpha  | 1.12            | 1.12            | 0.4                              |
| Alpha  | 1.13            | 1.13            | 1.0                              |
| Beta   | 1.14            | 1.17            | n/a                              |
| GA     | 1.18            | -               | n/a                              |

## Overview

CSI avoids encoding Kubernetes specific information in to the specification, since it aims to support multiple orchestration systems (beyond just Kubernetes).

This can be problematic because some CSI drivers require information about the workload (e.g. which pod is referencing this volume), and CSI does not provide this information natively to drivers.

## Pod Info on Mount with CSI Driver Object

The [CSIDriver Object](csi-driver-object.md) enables CSI Drivers to specify how Kubernetes should interact with it.

Specifically the `podInfoOnMount` field instructs Kubernetes that the CSI driver requires additional pod information (like podName, podUID, etc.) during mount operations.

For example, the existence of the following object would cause Kubernetes to add pod information at mount time to the `NodePublishVolumeRequest.volume_context` map.

```shell
apiVersion: storage.k8s.io/v1
kind: CSIDriver
metadata:
  name: testcsidriver.example.com
spec:
  podInfoOnMount: true
```

If the `podInfoOnMount` field is set to `true`, during mount, Kubelet will add the following key/values to the `volume_context` field in the CSI `NodePublishVolumeRequest`:

* `csi.storage.k8s.io/pod.name: {pod.Name}`
* `csi.storage.k8s.io/pod.namespace: {pod.Namespace}`
* `csi.storage.k8s.io/pod.uid: {pod.UID}`
* `csi.storage.k8s.io/serviceAccount.name: {pod.Spec.ServiceAccountName}`

The CSIDriver object should be manually included in the driver manifests.

Previously, the [cluster-driver-registrar](cluster-driver-registrar.md) sidecar container could be used to create the object. Once the flags to this container are configured correctly, it will automatically create a [CSIDriver Object](csi-driver-object.md) when it starts with the correct fields set.

## Alpha Functionality

In alpha, this feature was enabled by setting the `podInfoOnMountVersion` field in the `CSIDriver` Object CRD to to `v1`.

```shell
apiVersion: csi.storage.k8s.io/v1alpha1
kind: CSIDriver
metadata:
  name: testcsidriver.example.com
spec:
  podInfoOnMountVersion: v1
```
