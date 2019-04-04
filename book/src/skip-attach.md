# Skip Kubernetes Attach and Detach

**Status:** Beta

The "Skip Kubernetes Attach and Detach" feature was introduced as alpha in Kubernetes v1.12. It was promoted to beta in Kubernetes 1.14.

# Problem

Volume drivers, like NFS, for example, have no concept of an attach (`ControllerPublishVolume`). However, Kubernetes always executes `Attach` and `Detach` operations even if the CSI driver does not implement an attach operation (i.e. even if the CSI Driver does not implement a `ControllerPublishVolume` call).

This was problematic because it meant *all* CSI drivers had to handle Kubernetes attachment. CSI Drivers that did not implement the `PUBLISH_UNPUBLISH_VOLUME` controller capability could work around this by deploying an [external-attacher](external-attacher.md) and the `external-attacher` would responds to Kubernetes attach operations and simply do a noop (because the CSI driver did not advertise the `PUBLISH_UNPUBLISH_VOLUME` controller capability).

Although the workaround works, it adds an unnecessary operation (round-trip) in the preparation of a volume for a container, and requires CSI Drivers to deploy an unnecessary sidecar container (`external-attacher`).

# Skip Attach with CSI Driver Object

The [CSIDriver Object](csi-driver-object.md) enables CSI Drivers to specify how Kubernetes should interact with it.

Specifically the `attachRequired` field instructs Kubernetes to skip any attach operation altogether.

For example, the existence of the following object would cause Kubernetes to skip attach operations for all CSI Driver `testcsidriver.example.com` volumes.

```
apiVersion: storage.k8s.io/v1beta1
kind: CSIDriver
metadata:
  name: testcsidriver.example.com
spec:
  attachRequired: false
```

The easiest way to use this feature is to deploy the [cluster-driver-registrar](cluster-driver-registrar.md) sidecar container. Once the flags to this container are configured correctly, it will automatically create a [CSIDriver Object](csi-driver-object.md) when it starts with the correct fields set.

## Alpha Functionality
In alpha, this feature was enabled via the [CSIDriver Object](csi-driver-object.md) CRD.

```
apiVersion: csi.storage.k8s.io/v1alpha1
kind: CSIDriver
metadata:
....
```
