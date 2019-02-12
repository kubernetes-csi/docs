# CSINodeInfo Object

## Status

Alpha

## What is the CSINodeInfo object?

CSI drivers generate node specific information. Instead of storing this in the Kubernetes `Node` API Object, a new CSI specific Kubernetes CRD was created, the `CSINodeInfo` CRD.

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
apiVersion: csi.storage.k8s.io/v1alpha1
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

CSI drivers do not need to create the `CSINodeInfo` object directly. As long as they use the [node-driver-registrar](node-driver-registrar.md) sidecar container, the kubelet will automatically populate the `CSINodeInfo` object for the CSI driver as part of kubelet plugin registration.

### Enabling CSINodeInfo

The `CSINodeInfo` object is available as alpha starting with Kubernetes v1.12. Because it is an alpha feature, it is disabled by default.

To enable use of `CSINodeInfo` on Kubernetes, do the following:

1) Ensure the feature gate is enabled with `--feature-gates=CSINodeInfo=true`
2) Either ensure the `CSIDriver` CRD is automatically installed via the [Kubernetes Storage CRD addon](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/storage-crds) OR manually install the `CSINodeInfo` CRD on the Kubernetes cluster with the following command:
```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csinodeinfo.yaml
```
