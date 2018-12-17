# Setup
This document has been updated for the latest version of Kubernetes v1.12.  This document outlines the features that are available for CSI.  To get step by step instructions on how to run an example CSI driver, you can read the [Example](./Example.md) section.

## Enabling features
Some of the features discussed here may be at different stages (alpha, beta, or GA).  Ensure that the feature you want to try is enabled for the Kubernetes release you are using.  To avoid version mismatch, you can enable all of the features discussed here for both kubelet and kube-apiserver with:

```
--feature-gates=VolumeSnapshotDataSource=true,KubeletPluginsWatcher=true,CSINodeInfo=true,CSIDriverRegistry=true
```


## Enable privileged Pods

To use CSI drivers, your Kubernetes cluster must allow privileged pods (i.e. `--allow-privileged` flag must be set to `true` for both the API server and the kubelet). This is the default in some environments (e.g. GCE, GKE, `kubeadm`).

Ensure your API server are started with the privileged flag:

```shell
$ ./kube-apiserver ...  --allow-privileged=true ...
```

```shell
$ ./kubelet ...  --allow-privileged=true ...
```

## Enabling mount propagation
Another feature that CSI depends on is mount propagation.  It allows the sharing of volumes mounted by one container with other containers in the same pod, or even to other pods on the same node.  For mount propagation to work, the Docker daemon for the cluster must allow shared mounts. See the [mount propagation docs][mount-propagation-docs] to find out how to enable this feature for your cluster.  [This page][docker-shared-mount] explains how to check if shared mounts are enabled and how to configure Docker for shared mounts.

## Enable raw block volume support (alpha)

Kubernetes now has [raw block volume Support][rawsupport] as an alpha implementation. If you want to use the 
[CSI raw block volume support][rawvol], you must enable the feature (for your Kubernetes binaries including apiserver, kubelet, controller manager, etc) with the  `feature-gates` flag as follow:

```
$ kube<binary> --feature-gates=BlockVolume=true,CSIBlockVolume=true ...
```

## CSIDriver custom resource (alpha)
Starting with version 1.12, the `CSIDriver` custom resource definition (or CRD) has been introduced as a way to represent the CSI drivers running in a cluster. An admin can update the attributes of this object to modify the configuration of its associated driver at runtime. 

>You can see the full definition of this CRD [here](https://github.com/kubernetes/csi-api/blob/master/pkg/crd/crd.go). 


The alpha release of `CSIDriver` exposes three main configuration settings:

```yaml
apiVersion: v1
items:
- apiVersion: csi.storage.k8s.io/v1alpha1
  kind: CSIDriver
  metadata:
    name: csi-hostpath
  spec:
    attachRequired: true
    podInfoOnMountVersion: "v1"
```

Where:
- `metadata:name` - the identifying name of the CSI driver.  That name must be unique in the cluster as it is the name that is used to identify the CSI cluster.
- `attachRequired` - indicates that the CSI volume driver requires a volume attach operation.  This will cause Kubernetes to call make a `CSI.ControllerPublishVolume()` call and wait for completion before proceeding to mount.
- `podInfoOnMountVersion` - this value indicates that the associated CSI volume driver requires additional pod information (like podName, podUID, etc.) during mount. Leave value empty if you do not want pod info to be transmitted.  Or, provide a value of `v1` which will cause the Kubelet to send the followings pod information during NodePublishVolume() calls to the driver as `VolumeAttributes`:
```
csi.storage.k8s.io/pod.name: pod.Name
csi.storage.k8s.io/pod.namespace: pod.Namespace
csi.storage.k8s.io/pod.uid: string(pod.UID)
```

### Enabling CSIDriver
If you want to use the `CSIDriver` CRD and get a preview of how configuration will work at runtime, do the followings:

1) Ensure the feature gate is enabled with `--feature-gates=CSIDriverRegistry=true`
2) Install the `CSIDriver` CRD on the Kubernetes cluster with the following command:
```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csidriver.yaml --validate=false
```

### Listing registered CSI drivers
Using the`CSIDriver` CRD, it is now possible to query Kubernetes to get a list of registered drivers running in the cluster as shown below:

```
$> kubectl get csidrivers.csi.storage.k8s.io
NAME           AGE
csi-hostpath   2m
```
Or get a more detail view of your registered driver with:
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

## CSINodeInfo custom resource (alpha)
Object `CSINodeInfo` is a resource designed to carry binding information between a CSI driver and a cluster node where its volume storage will land.  In the first release, object  `CSINodeInfo` is used to establish the link between a node, its driver, and the topology keys used for scheduling volume storage.  

>You can see the full definition of this CRD [here](https://github.com/kubernetes/csi-api/blob/master/pkg/crd/crd.go). 



The following snippet shows a sample `CSIDriverInfo` which is usually created by Kubernetes:

```yaml
apiVersion: v1
items:
- apiVersion: csi.storage.k8s.io/v1alpha1
  kind: CSINodeInfo
  metadata:
    name: 127.0.0.1
  csiDrivers:
  - driver: csi-hostpath
    nodeID: 127.0.0.1
    topologyKeys: []
...    
```

Where:
- `csiDrivers` - list of CSI drivers running on the node and their properties.
- `driver` - the CSI driver that this object refers to.
- `nodeID` - the assigned identifier for the node as determined by the driver.
- `topologyKeys` - A list of topology keys assigned to the node as supported by the driver.

### Enabling CSINodeInfo
If you want to use the `CSINodeInfo` CRD and get a preview of how configuration will work at runtime, do the followings:

1) Ensure the feature gate is enabled with `--feature-gates=CSINodeInfo=true`
2) Install the `CSINodeInfo` CRD on the Kubernetes cluster with the following command:
```
$> kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csinodeinfo.yaml --validate=false
```


## CSI driver discovery (beta)

The CSI driver discovery uses the [Kubelet Plugin Watcher][plugin-watcher] feature which allows Kubelet to discover deployed CSI drivers automatically.  The registrar sidecar container exposes an internal registration server via a Unix domain socket path. The Kubelet monitors its `registration` directory to detect new registration requests. Once detected, the Kubelet contacts the registrar sidecar to query driver information.  The retrieved CSI driver information (including the driver's own socket path) will be used for further interaction with the driver.

> This replaces the previous driver registration mechanism, where the driver-registrar sidecar, rather than kubelet, handles registration.

Using this discovery feature, instead of the prior registration mechanism, will not have any effect on how drivers behave, however, this will be the way CSI works internally in coming releases.


### Registrar sidecar configuration
The registrar sidecar container provides configuration functionalities to its associated driver. For instance, using the registrar container, an admin can specify how the driver should behave during volume attachment operations.  Some CLI arguments provided to the registrar container will be used to create the CSIDriver and CSIDriverInfo custom resources discussed earlier. 

To configure your driver using the registrar sidecar, you can configure the container as shown in the snippet below:

```yaml
- name: driver-registrar
    args:
    - --v=5
    - --csi-address=/csi/csi.sock
    - --mode=node-register
    - --driver-requires-attachment=true
    - --pod-info-mount-version="v1"
    - --kubelet-registration-path=/var/lib/kubelet/plugins/csi-hostpath/csi.sock
    env:
    - name: KUBE_NODE_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: spec.nodeName
    image: quay.io/k8scsi/driver-registrar:v0.4.1
    imagePullPolicy: Always
    volumeMounts:
    - mountPath: /csi
      name: socket-dir
    volumeMounts:
    - name: registration-dir
      mountPath: /registration
...
volumes:
  name: socket-dir
  - hostPath:
      path: /var/lib/kubelet/plugins/csi-hostpath
      type: DirectoryOrCreate
  name: registration-dir
  - hostPath:
      path: /var/lib/kubelet/plugins_registry
      type: Directory
```
Where:

- `--csi-address` - specifies the Unix domain socket path, on the host, for the CSI driver. It allows the registrar sidecar to communicate with the driver for discovery information.  Mount path `/csi` is mapped to HostPath entry `socket-dir` which is mapped to directory `/var/lib/kubelet/plugins/csi-hostpath`

- `--mode` - this flag specifies how the registar binary will function in either 

- `--driver-requires-attachment` - indicates that this CSI volume driver requires an attach operation (because it implements the CSI `ControllerPublishVolume()` method), and that Kubernetes should call attach and wait for any attach operation to complete before proceeding to mounting. If value is not specified, default is false meaning attach will not be called.

- `--pod-info-mount-version="v1"` - this indicates that the associated CSI volume driver requires additional pod information (like podName, podUID, etc.) during mount. A version of value \"v1\" will cause the Kubelet send the followings pod information during `NodePublishVolume()` calls to the driver as VolumeAttributes:
```
  csi.storage.k8s.io/pod.name: pod.Name
  csi.storage.k8s.io/pod.namespace: pod.Namespace
  csi.storage.k8s.io/pod.uid: string(pod.UID)
```

- `--kubelet-registration-path` - specifies the fully-qualified path of the Unix domain socket for the CSI driver on the host. This path is constructed using the path from HostPath `socket-dir` and the additional suffix `csi.sock`.  The registrar sidecar will provide this path to core CSI components for subsequent volume operations.

- VolumeMount `/csi` - is mapped to HostPath `/var/lib/kubelet/plugins/csi-hostpath`.  It is the root location where the CSI driver's Unix Domain socket file is mounted on the host.

- VolumeMount `/registration` is mapped to HostPath ` /var/lib/kubelet/plugins_registry`.  It is the root location where Kubelet watcher scans for new plugin registration.

### The Kubelet root directory
In the configuration above, notice that all paths starts with `/var/lib/kubelet/plugin` That is because the discovery mechanism relies on the Kubelet's root directory (which is by default) `/var/lib/kubelet`.  Ensure that this path value matches the value specified in the Kubelet's `--root-dir` argument.

#### CSI Volume Snapshot support

[CSI volume snapshot support][snapshot-spec]: To enable support for Kubernetes volume
snapshotting, you must set the following feature gate on Kubernetes v1.12 (disabled
by default for alpha):

```
--feature-gates=VolumeSnapshotDataSource=true
```

## Topology (alpha)
In order to support topology-aware dynamic provisioning mechanisms available in Kubernetes, the *external-provisioner* must have the Topology feature enabled:

```
--feature-gates=Topology=true
```

In addition, in the *Kubernetes cluster* the `CSINodeInfo` alpha feature must be enabled (refer to the [CSINodeInfo custom resource]{csinodeinfo-custom-resource-alpha} section for more info):

```
--feature-gates=CSINodeInfo=true
```
as well as the `KubeletPluginsWatcher` beta feature (currently enabled by default).

## Archives

Please visit the [Archives](Archive.html) for setup instructions on previous versions of Kubernetes.

[mount-propagation-docs]: https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
[docker-shared-mount]: https://docs.portworx.com/knowledgebase/shared-mount-propagation.html
[rawvol]: https://kubernetes.io/docs/concepts/storage/volumes/#csi-raw-block-volume-support
[rawsupport]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#raw-block-volume-support
[plugin-watcher]: https://docs.google.com/document/d/1dtHpGY-gPe9sY7zzMGnm8Ywo09zJfNH-E1KEALFV39s/edit#heading=h.7fe6spexljh6
[snapshot-spec]: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/storage/csi-snapshot.md
