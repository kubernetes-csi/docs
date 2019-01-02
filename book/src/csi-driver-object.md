# CSI CRD: `CSIDriver` Object

## Status

Alpha

## What is the `CSIDriver` object?

The `CSIDriver` Kubernetes API object serves two purposes:

1. Simplify driver discovery
  * If a CSI driver creates a `CSIDriver` object, Kubernetes users can easily discover the CSI Drivers installed on their cluster (simply by issuing `kubectl get CSIDriver`)
2. Customizing Kubernetes behavior
  * Kubernetes has a default set of behaviors when dealing with CSI Drivers (for example, it calls the `Attach`/`Detach` operations by default). This object allows CSI drivers to specify how Kubernetes should interact with it.

## What fields does the `CSIDriver` object have?

Here is an example of a v1alpha1 `CSIDriver` object:

```YAML
apiVersion: csi.storage.k8s.io/v1alpha1
kind: CSIDriver
metadata:
  name: mycsidriver.example.com
spec:
  attachRequired: true
  podInfoOnMountVersion: v1
```

There are three important fields:

* `name`
  * This should correspond to the full name of the CSI driver.
* `attachRequired`
  * Indicates this CSI volume driver requires an attach operation (because it implements the CSI `ControllerPublishVolume` method), and that Kubernetes should call attach and wait for any attach operation to complete before proceeding to mounting.
  * If a `CSIDriver` object does not exist for a given CSI Driver, the default is `true` -- meaning attach will be called.
  * If a `CSIDriver` object exists for a given CSI Driver, but this field is not specified, it also defaults to `true` -- meaning attach will be called.
  * For more information see [Skip Attach](skip-attach.md).
* `podInfoOnMountVersion`
  * Indicates this CSI volume driver requires additional pod information (like pod name, pod UID, etc.) during mount operations.
  * If value is not specified, pod information will not be passed on mount.
  * If value is set to a valid version, Kubelet will pass pod information as `volume_context` in CSI `NodePublishVolume` calls.
  * Supported versions:
    * Version "v1" will pass the following additional fields in `volume_context`:
	  * `"csi.storage.k8s.io/pod.name": pod.Name`
	  * `csi.storage.k8s.io/pod.namespace": pod.Namespace`
	  * `csi.storage.k8s.io/pod.uid": string(pod.UID)`
  * For more information see [Pod Info on Mount](pod-info.md).

## What creates the `CSIDriver` object?

CSI drivers do not need to create the `CSIDriver` object directly. Instead they may use the [cluster-driver-registrar](cluster-driver-registrar.md) sidecar container (customizing it as needed with startup parameters) -- when deployed with a CSI driver it automatically creates a `CSIDriver` CR representing the driver.

### Enabling `CSIDriver`

The `CSIDriver` object is available as alpha starting with Kubernetes v1.12. Because it is an alpha feature, it is disabled by default.
It is planned to be moved to beta in Kubernetes v1.14 and enabled by default.

To enable the use of `CSIDriver` on Kubernetes, do the following:

1) Ensure the feature gate is enabled via the following Kubernetes feature flag: `--feature-gates=CSIDriverRegistry=true`
2) Either ensure the `CSIDriver` CRD is automatically installed via the [Kubernetes Storage CRD addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/storage-crds) OR manually install the `CSIDriver` CRD on the Kubernetes cluster with the following command:
```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csidriver.yaml
```

### Listing registered CSI drivers
Using the `CSIDriver` CRD, it is now possible to query Kubernetes to get a list of registered drivers running in the cluster as shown below:

```
$> kubectl get csidrivers.csi.storage.k8s.io
NAME           AGE
csi-hostpath   2m
```
Or get a more detailed view of your registered driver with:
```
$> kubectl describe csidrivers.csi.storage.k8s.io
Name:         csi-hostpath
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  csi.storage.k8s.io/v1alpha1
Kind:         CSIDriver
Metadata:
  Creation Timestamp:  2018-10-04T21:15:30Z
  Generation:          1
  Resource Version:    390
  Self Link:           /apis/csi.storage.k8s.io/v1alpha1/csidrivers/csi-hostpath
  UID:                 9f854aa6-c81a-11e8-bdce-000c29e88ff1
Spec:
  Attach Required:            true
  Pod Info On Mount Version:
Events:                       <none>
```

