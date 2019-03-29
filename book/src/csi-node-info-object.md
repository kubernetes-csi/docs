# CSINodeInfo Object

## Status

* Kubernetes 1.12 - 1.13: Alpha
* Kubernetes 1.14: Beta

## What is the CSINodeInfo object?

CSI drivers generate node specific information. Instead of storing this in the Kubernetes `Node` API Object, a new CSI specific Kubernetes `CSINodeInfo` object was created.

It serves the following purposes:

1. Mapping Kubernetes node name to CSI Node name,
  * The CSI `GetNodeInfo` call returns the name by which the storage system refers to a node. Kubernetes must use this name in future `ControllerPublishVolume` calls. Therefore, when a new CSI driver is registered, Kubernetes stores the storage system node ID in the `CSINodeInfo` object for future reference. 
2. Driver availability
  * A way for kubelet to communicate to the kube-controller-manager and kubernetes scheduler whether the driver is available (registered) on the node or not.
3. Volume topology
  * The CSI `GetNodeInfo` call returns a set of keys/values labels identifying the topology of that node. Kubernetes uses this information to to do topology-aware provisioning (see [PVC Volume Binding Modes](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode) for more details). It stores the key/values as labels on the Kubernetes node object. In order to recall which `Node` label keys belong to a specific CSI driver, the kubelet stores the keys in the `CSINodeInfo` object for future reference.
	

## What fields does the CSINodeInfo object have?

Here is an example of a v1alpha1 `CSINodeInfo` object:

```YAML
apiVersion: storage.k8s.io/v1beta1
kind: CSINodeInfo
metadata:
  name: node1
spec:
  drivers:
  - name: mycsidriver.example.com
    available: true
    volumePluginMechanism: csi-plugin
status:
  drivers:
  - name: mycsidriver.example.com
    nodeID: storageNodeID1
    topologyKeys: ['mycsidriver.example.com/regions', "mycsidriver.example.com/zones"]
```

Where the fields mean:

- `csiDrivers` - list of CSI drivers running on the node and their properties.
- `driver` - the CSI driver that this object refers to.
- `nodeID` - the assigned identifier for the node as determined by the driver.
- `topologyKeys` - A list of topology keys assigned to the node as supported by the driver.

## What creates the CSINodeInfo object?

CSI drivers do not need to create the `CSINodeInfo` object directly. Instead they should use the [node-driver-registrar](node-driver-registrar.md) sidecar container. This sidecar container will interact with kubelet via the kubelet plugin registration mechanism to automatically populate the `CSINodeInfo` object on behalf of the the CSI driver.

## Changes from Alpha to Beta
### CRD to Built in Type
During alpha development, the `CSINodeInfo` object was also defined as a [Custom Resource Definition](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRD). As part of the promotion to beta the object has been moved to the built-in Kubernetes API.

In the move from alpha to beta, the API Group for this object changed from `csi.storage.k8s.io/v1alpha1` to `storage.k8s.io/v1beta1`.

There is no automatic update of existing CRDs and their CRs during Kubernetes update to the new build-in type.

### Enabling CSINodeInfo on Kubernetes
In Kubernetes v1.12 and v1.13, because the feature was alpha, it was disabled by default. To enable the use of `CSIDriver` on these versions, do the following:

1. Ensure the feature gate is enabled with `--feature-gates=CSINodeInfo=true`
2. Either ensure the `CSIDriver` CRD is automatically installed via the [Kubernetes Storage CRD addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/storage-crds) OR manually install the `CSINodeInfo` CRD on the Kubernetes cluster with the following command:

```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csinodeinfo.yaml
```
Kubernetes v1.14+, uses the same Kubernetes feature flag, but because the feature is beta, it is enabled by default. And since the API type (as of beta) is built in to the Kubernetes API, installation of the CRD is no longer required.
