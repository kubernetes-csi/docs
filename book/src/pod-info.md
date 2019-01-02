# Pod Info on Mount

**Status:** Alpha

# Problem

CSI avoids encoding Kubernetes specific information in to the specification, since it aims to support multiple orchestration systems (beyond just Kubernetes).

This can be problematic because some CSI drivers require information about the workload (e.g. which pod is referencing this volume), and CSI does not provide this information natively to drivers.

# Pod Info on Mount with CSI Driver Object

The [CSIDriver Object](csi-driver-object.md) enables CSI Drivers to specify how Kubernetes should interact with it.

Specifically the `podInfoOnMountVersion` field instructs Kubernetes that the CSI driver requires additional pod information (like podName, podUID, etc.) during mount operations.

For example, the existence of the following object would cause Kubernetes to add pod information at mount time to the `NodePublishVolumeRequest.volume_context` map.

```
apiVersion: csi.storage.k8s.io/v1alpha1
kind: CSIDriver
metadata:
  name: testcsidriver.example.com
spec:
  podInfoOnMountVersion: v1
```

There is only one `podInfoOnMountVersion` version currently supported: `v1`.

The value `v1` for `podInfoOnMountVersion` will result in the following key/values being added to `publish_context`:

* `csi.storage.k8s.io/pod.name: {pod.Name}`
* `csi.storage.k8s.io/pod.namespace: {pod.Namespace}`
* `csi.storage.k8s.io/pod.uid: {pod.UID}`


The easiest way to use this feature is to deploy the [cluster-driver-registrar](cluster-driver-registrar.md) sidecar container. Once the flags to this container are configured correctly, it will automatically create a [CSIDriver Object](csi-driver-object.md) when it starts with the correct fields set.
