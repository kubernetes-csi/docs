# CSINode Object

## Status

Status | Min K8s Version | Max K8s Version
--|--|--
Alpha | 1.12 | 1.13
Beta | 1.14 | 1.16
GA   | 1.17 | -

## What is the CSINode object?

CSI drivers generate node specific information. Instead of storing this in the Kubernetes `Node` API Object, a new CSI specific Kubernetes `CSINode` object was created.

It serves the following purposes:

1. Mapping Kubernetes node name to CSI Node name.

* The CSI `GetNodeInfo` call returns the name by which the storage system refers to a node. Kubernetes must use this name in future `ControllerPublishVolume` calls. Therefore, when a new CSI driver is registered, Kubernetes stores the storage system node ID in the `CSINode` object for future reference.

2. Driver availability

* A way for kubelet to communicate to the kube-controller-manager and kubernetes scheduler whether the driver is available (registered) on the node or not.

3. Volume topology

* The CSI `GetNodeInfo` call returns a set of keys/values labels identifying the topology of that node. Kubernetes uses this information to do topology-aware provisioning (see [PVC Volume Binding Modes](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode) for more details). It stores the key/values as labels on the Kubernetes node object. In order to recall which `Node` label keys belong to a specific CSI driver, the kubelet stores the keys in the `CSINode` object for future reference.

## What fields does the CSINode object have?

Here is an example of a v1 `CSINode` object:

```YAML
apiVersion: storage.k8s.io/v1
kind: CSINode
metadata:
  name: node1
spec:
  drivers:
  - name: mycsidriver.example.com
    nodeID: storageNodeID1
    topologyKeys: ['mycsidriver.example.com/regions', "mycsidriver.example.com/zones"]
```

What the fields mean:

* `drivers` - list of CSI drivers running on the node and their properties.
* `name` - the CSI driver that this object refers to.
* `nodeID` - the assigned identifier for the node as determined by the driver.
* `topologyKeys` - A list of topology keys assigned to the node as supported by the driver.

## What creates the CSINode object?

CSI drivers do not need to create the `CSINode` object directly. Kubelet manages the object when a CSI driver registers through the kubelet plugin registration mechanism. The [node-driver-registrar](node-driver-registrar.md) sidecar container helps with this registration.

## Changes from Alpha to Beta

### CRD to Built in Type

The alpha object was called `CSINodeInfo`, whereas the beta object is called
`CSINode`. The alpha `CSINodeInfo` object was also defined as a [Custom Resource Definition](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRD). As part of the promotion to beta the object has been moved to the built-in Kubernetes API.

In the move from alpha to beta, the API Group for this object changed from `csi.storage.k8s.io/v1alpha1` to `storage.k8s.io/v1beta1`.

There is no automatic update of existing CRDs and their CRs during Kubernetes update to the new build-in type.

### Enabling CSINodeInfo on Kubernetes

In Kubernetes v1.12 and v1.13, because the feature was alpha, it was disabled by default. To enable the use of `CSINodeInfo` on these versions, do the following:

1. Ensure the feature gate is enabled with `--feature-gates=CSINodeInfo=true`
2. Either ensure the `CSIDriver` CRD is automatically installed via the [Kubernetes Storage CRD addon](https://github.com/kubernetes/kubernetes/tree/release-1.13/cluster/addons/storage-crds) OR manually install the `CSINodeInfo` CRD on the Kubernetes cluster with the following command:

```shell
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csinodeinfo.yaml
```

Kubernetes v1.14+, uses the same Kubernetes feature flag, but because the feature is beta, it is enabled by default. And since the API type (as of beta) is built in to the Kubernetes API, installation of the CRD is no longer required.
