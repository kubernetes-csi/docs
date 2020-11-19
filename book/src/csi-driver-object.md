# CSIDriver Object

## Status

- Kubernetes 1.12 - 1.13: Alpha
- Kubernetes 1.14: Beta
- Kubernetes 1.18: GA

## What is the CSIDriver object?

The `CSIDriver` Kubernetes API object serves two purposes:

1. Simplify driver discovery

- If a CSI driver creates a `CSIDriver` object, Kubernetes users can easily discover the CSI Drivers installed on their cluster (simply by issuing `kubectl get CSIDriver`)

2. Customizing Kubernetes behavior

- Kubernetes has a default set of behaviors when dealing with CSI Drivers (for example, it calls the `Attach`/`Detach` operations by default). This object allows CSI drivers to specify how Kubernetes should interact with it.

## What fields does the `CSIDriver` object have?

Here is an example of a v1 `CSIDriver` object:

```yaml
apiVersion: storage.k8s.io/v1
kind: CSIDriver
metadata:
  name: mycsidriver.example.com
spec:
  attachRequired: true
  podInfoOnMount: true
  fsGroupPolicy: File # added in Kubernetes 1.19, this field is beta as of Kubernetes 1.20
  volumeLifecycleModes: # added in Kubernetes 1.16, this field is beta
    - Persistent
    - Ephemeral
  tokenRequests: # added in Kubernetes 1.20, this field is alpha
    - audience: "gcp"
    - audience: "" # empty string means defaulting to the `--api-audiences` of kube-apiserver
      expirationSeconds: 3600
  requiresRepublish: true # added in Kubernetes 1.20, this field is alpha
```

These are the important fields:

- `name`
  - This should correspond to the full name of the CSI driver.
- `attachRequired`
  - Indicates this CSI volume driver requires an attach operation (because it implements the CSI `ControllerPublishVolume` method), and that Kubernetes should call attach and wait for any attach operation to complete before proceeding to mounting.
  - If a `CSIDriver` object does not exist for a given CSI Driver, the default is `true` -- meaning attach will be called.
  - If a `CSIDriver` object exists for a given CSI Driver, but this field is not specified, it also defaults to `true` -- meaning attach will be called.
  - For more information see [Skip Attach](skip-attach.md).
- `podInfoOnMount`
  - Indicates this CSI volume driver requires additional pod information (like pod name, pod UID, etc.) during mount operations.
  - If value is not specified or `false`, pod information will not be passed on mount.
  - If value is set to `true`, Kubelet will pass pod information as `volume_context` in CSI `NodePublishVolume` calls:
    - `"csi.storage.k8s.io/pod.name": pod.Name`
    - `"csi.storage.k8s.io/pod.namespace": pod.Namespace`
    - `"csi.storage.k8s.io/pod.uid": string(pod.UID)`
    - `"csi.storage.k8s.io/serviceAccount.name": pod.Spec.ServiceAccountName`
  - For more information see [Pod Info on Mount](pod-info.md).
- `fsGroupPolicy`
  - This field was added in Kubernetes 1.19 and cannot be set when using an older Kubernetes release.
  - This field is beta in Kubernetes 1.20.
  - Controls if this CSI volume driver supports volume ownership and permission changes when volumes are mounted.
  - The following modes are supported, and if not specified the default is `ReadWriteOnceWithFSType`:
    - `None`: Indicates that volumes will be mounted with no modifications, as the CSI volume driver does not support these operations.
    - `File`: Indicates that the CSI volume driver supports volume ownership and permission change via fsGroup, and Kubernetes may use fsGroup to change permissions and ownership of the volume to match user requested fsGroup in the pod's SecurityPolicy regardless of fstype or access mode.
    - `ReadWriteOnceWithFSType`: Indicates that volumes will be examined to determine if volume ownership and permissions should be modified to match the pod's security policy.
      Changes will only occur if the `fsType` is defined and the persistent volume's `accessModes` contains `ReadWriteOnly`.
      This is the default behavior if no other FSGroupPolicy is defined.
  - For more information see [CSI Driver fsGroup Support](support-fsgroup.md).
- `volumeLifecycleModes`
  - This field was added in Kubernetes 1.16 and cannot be set when using an older Kubernetes release.
  - This field is beta.
  - It informs Kubernetes about the volume modes that are supported by the driver.
    This ensures that the driver [is not used incorrectly](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/20190122-csi-inline-volumes.md#support-for-inline-csi-volumes) by users.
    The default is `Persistent`, which is the normal PVC/PV mechanism. `Ephemeral` enables
    [inline ephemeral volumes](ephemeral-local-volumes.md) in addition (when both
    are listed) or instead of normal volumes (when it is the only entry in the list).
- `tokenRequests`
  - This field was added in Kubernetes 1.20 and cannot be set when using an older Kubernetes release.
  - This field is alpha. Please make sure the feature gate is enabled via flag `--feature-gates=CSIServiceAccountToken=true`.
  - If this field is specified, Kubelet will plumb down the bound service acocunt tokens of the pod as `volume_context` in the `NodePublishVolume`:
    - `"csi.storage.k8s.io/serviceAccount.tokens": {"gcp":{"token":"<token>","expirationTimestamp":"<expiration timestamp in RFC3339>"}}`
    - If CSI driver doesn't find token recorded in the `volume_context`, it should return error in `NodePublishVolume` to inform Kubelet to retry.
    - Audiences should be distinct, otherwise the validation will fail. If the audience is "", it means the issued token has the same audience as kube-apiserver.
- `requiresRepublish`
  - This field was added in Kubernetes 1.20 and cannot be set when using an older Kubernetes release.
  - This field is alpha. Please make sure the feature gate is enabled via flag `--feature-gates=CSIServiceAccountToken=true`.
  - If this field is `true`, Kubelet will periodically call `NodePublishVolume`. This is useful in the following scenarios:
    - If the volume mounted by CSI driver is short-lived.
    - If CSI driver requires valid service account tokens (enabled by the field `tokenRequests`) repeatedly.
  - CSI drivers should only atomically update the contents of the volume. Mount point change will not be seen by a running container.

## What creates the CSIDriver object?

To install, a CSI driver's deployment manifest must contain a `CSIDriver`
object as shown in the example above.

> NOTE: The cluster-driver-registrar side-car which was used to create CSIDriver
> objects in Kubernetes 1.13 has been deprecated for Kubernetes 1.16. No
> cluster-driver-registrar has been released for Kubernetes 1.14 and later.

`CSIDriver` instance should exist for whole lifetime of all pods that use
volumes provided by corresponding CSI driver, so [Skip Attach](skip-attach.md)
and [Pod Info on Mount](pod-info.md) features work correctly.

### Listing registered CSI drivers

Using the `CSIDriver` object, it is now possible to query Kubernetes to get a list of registered drivers running in the cluster as shown below:

```
$> kubectl get csidrivers.storage.k8s.io
NAME                  CREATED AT
hostpath.csi.k8s.io   2019-09-13T09:58:43Z
```

Or get a more detailed view of your registered driver with:

```
$> kubectl describe csidrivers.storage.k8s.io
Name:         hostpath.csi.k8s.io
Namespace:
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"storage.k8s.io/v1","kind":"CSIDriver","metadata":{"annotations":{},"name":"hostpath.csi.k8s.io"},"spec":{"podInfoOnMou...
API Version:  storage.k8s.io/v1
Kind:         CSIDriver
Metadata:
  Creation Timestamp:  2019-09-13T09:58:43Z
  Resource Version:    341
  Self Link:           /apis/storage.k8s.io/v1/csidrivers/hostpath.csi.k8s.io
  UID:                 1860f2a1-85f8-4357-a933-c45e54f0c8e0
Spec:
  Attach Required:    true
  Pod Info On Mount:  true
  Volume Lifecycle Modes:
    Persistent
    Ephemeral
Events:  <none>
```

## Changes from Alpha to Beta

### CRD to Built in Type

During alpha development, the `CSIDriver` object was also defined as a [Custom Resource Definition](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRD). As part of the promotion to beta the object has been moved to the built-in Kubernetes API.

In the move from alpha to beta, the API Group for this object changed from `csi.storage.k8s.io/v1alpha1` to `storage.k8s.io/v1beta1`.

There is no automatic update of existing CRDs and their CRs during Kubernetes update to the new build-in type.

### Enabling CSIDriver on Kubernetes

In Kubernetes v1.12 and v1.13, because the feature was alpha, it was disabled by default. To enable the use of `CSIDriver` on these versions, do the following:

1. Ensure the feature gate is enabled via the following Kubernetes feature flag: `--feature-gates=CSIDriverRegistry=true`
2. Either ensure the `CSIDriver` CRD is automatically installed via the [Kubernetes Storage CRD addon](https://github.com/kubernetes/kubernetes/tree/release-1.13/cluster/addons/storage-crds) OR manually install the `CSIDriver` CRD on the Kubernetes cluster with the following command:

```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csidriver.yaml
```

Kubernetes v1.14+, uses the same Kubernetes feature flag, but because the feature is beta, it is enabled by default. And since the API type (as of beta) is built in to the Kubernetes API, installation of the CRD is no longer required.
