# CSIDriver Object

## Status

* Kubernetes 1.12 - 1.13: Alpha
* Kubernetes 1.14: Beta

## What is the CSIDriver object?

The `CSIDriver` Kubernetes API object serves two purposes:

1. Simplify driver discovery
  * If a CSI driver creates a `CSIDriver` object, Kubernetes users can easily discover the CSI Drivers installed on their cluster (simply by issuing `kubectl get CSIDriver`)
2. Customizing Kubernetes behavior
  * Kubernetes has a default set of behaviors when dealing with CSI Drivers (for example, it calls the `Attach`/`Detach` operations by default). This object allows CSI drivers to specify how Kubernetes should interact with it.

## What fields does the `CSIDriver` object have?

Here is an example of a v1beta1 `CSIDriver` object:

```YAML
apiVersion: storage.k8s.io/v1beta1
kind: CSIDriver
metadata:
  name: mycsidriver.example.com
spec:
  attachRequired: true
  podInfoOnMount: true
```

There are three important fields:

* `name`
  * This should correspond to the full name of the CSI driver.
* `attachRequired`
  * Indicates this CSI volume driver requires an attach operation (because it implements the CSI `ControllerPublishVolume` method), and that Kubernetes should call attach and wait for any attach operation to complete before proceeding to mounting.
  * If a `CSIDriver` object does not exist for a given CSI Driver, the default is `true` -- meaning attach will be called.
  * If a `CSIDriver` object exists for a given CSI Driver, but this field is not specified, it also defaults to `true` -- meaning attach will be called.
  * For more information see [Skip Attach](skip-attach.md).
* `podInfoOnMount`
  * Indicates this CSI volume driver requires additional pod information (like pod name, pod UID, etc.) during mount operations.
  * If value is not specified or `false`, pod information will not be passed on mount.
  * If value is set to `true`, Kubelet will pass pod information as `volume_context` in CSI `NodePublishVolume` calls:
    * `"csi.storage.k8s.io/pod.name": pod.Name`
    * `"csi.storage.k8s.io/pod.namespace": pod.Namespace`
    * `"csi.storage.k8s.io/pod.uid": string(pod.UID)`
  * For more information see [Pod Info on Mount](pod-info.md).

## What creates the CSIDriver object?

To install, a CSI driver's deployment manifest must contain a `CSIDriver`
object as shown in the example above.

>NOTE: The cluster-driver-registrar side-car which was used to create CSIDriver
>objects in Kubernetes 1.13 is being redesigned for Kubernetes 1.15 and
>therefore not available for Kubernetes 1.14.

### Listing registered CSI drivers
Using the `CSIDriver` object, it is now possible to query Kubernetes to get a list of registered drivers running in the cluster as shown below:

```
$> kubectl get csidrivers.storage.k8s.io
NAME           AGE
csi-hostpath   2m
```
Or get a more detailed view of your registered driver with:
```
$> kubectl describe csidrivers.storage.k8s.io
Name:         csi-hostpath
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  storage.k8s.io/v1beta1
Kind:         CSIDriver
Metadata:
  Creation Timestamp:  2018-10-04T21:15:30Z
  Generation:          1
  Resource Version:    390
  Self Link:           /apis/storage.k8s.io/v1beta1/csidrivers/csi-hostpath
  UID:                 9f854aa6-c81a-11e8-bdce-000c29e88ff1
Spec:
  Attach Required:            true
  Pod Info On Mount:          false
Events:                       <none>
```

## Changes from Alpha to Beta
### CRD to Built in Type
During alpha development, the `CSIDriver` object was also defined as a [Custom Resource Definition](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRD). As part of the promotion to beta the object has been moved to the built-in Kubernetes API.

In the move from alpha to beta, the API Group for this object changed from `csi.storage.k8s.io/v1alpha1` to `storage.k8s.io/v1beta1`.

There is no automatic update of existing CRDs and their CRs during Kubernetes update to the new build-in type.

### Enabling CSIDriver on Kubernetes
In Kubernetes v1.12 and v1.13, because the feature was alpha, it was disabled by default. To enable the use of `CSIDriver` on these versions, do the following:

1. Ensure the feature gate is enabled via the following Kubernetes feature flag: `--feature-gates=CSIDriverRegistry=true`
2. Either ensure the `CSIDriver` CRD is automatically installed via the [Kubernetes Storage CRD addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/storage-crds) OR manually install the `CSIDriver` CRD on the Kubernetes cluster with the following command:

```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csidriver.yaml
```
Kubernetes v1.14+, uses the same Kubernetes feature flag, but because the feature is beta, it is enabled by default. And since the API type (as of beta) is built in to the Kubernetes API, installation of the CRD is no longer required.
