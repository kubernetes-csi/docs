# StorageClass Secrets

The CSI [external-provisioner](external-provisioner.md) sidecar container facilitates the handling of secrets for the following operations:
* `CreateVolumeRequest`
* `DeleteVolumeRequest`
* `ControllerPublishVolumeRequest`
* `ControllerUnpublishVolumeRequest`
* `ControllerExpandVolumeRequest`
* `NodeStageVolumeRequest`
* `NodePublishVolumeRequest`

CSI `external-provisioner` v1.0.1+ supports the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/provisioner-secret-name`
* `csi.storage.k8s.io/provisioner-secret-namespace`
* `csi.storage.k8s.io/controller-publish-secret-name`
* `csi.storage.k8s.io/controller-publish-secret-namespace`
* `csi.storage.k8s.io/node-stage-secret-name`
* `csi.storage.k8s.io/node-stage-secret-namespace`
* `csi.storage.k8s.io/node-publish-secret-name`
* `csi.storage.k8s.io/node-publish-secret-namespace`

CSI `external-provisioner` v1.2.0+ adds support for the following keys in `StorageClass.parameters`:
* `csi.storage.k8s.io/controller-expand-secret-name`
* `csi.storage.k8s.io/controller-expand-secret-namespace`

Cluster admins can populate the secret fields for the operations listed above with data from Kubernetes `Secret` objects by specifying these keys in the `StorageClass` object.

## Examples

### Basic Provisioning Secret

In this example, the external-provisioner will fetch Kubernetes `Secret` object `fast-storage-provision-key` in the namespace `pd-ssd-credentials` and pass the credentials to the CSI driver named `csi-driver.team.example.com` in the `CreateVolume` CSI call.

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage
provisioner: csi-driver.team.example.com
parameters:
  type: pd-ssd
  csi.storage.k8s.io/provisioner-secret-name: fast-storage-provision-key
  csi.storage.k8s.io/provisioner-secret-namespace: pd-ssd-credentials
```

All volumes provisioned using this `StorageClass` use the same secret.

### Per Volume Secrets
In this example, the external-provisioner will generate the name of the Kubernetes `Secret` object and namespace for the `NodePublishVolume` CSI call, based on the PVC namespace and annotations, at volume provision time.

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage
provisioner: csi-driver.team.example.com
parameters:
  type: pd-ssd
  csi.storage.k8s.io/node-publish-secret-name: ${pvc.annotations['team.example.com/key']}
  csi.storage.k8s.io/node-publish-secret-namespace: ${pvc.namespace}
```

This StorageClass will result in the creation of a `PersistentVolume` API object referencing a "node publish secret" in the same namespace as the `PersistentVolumeClaim` that triggered the provisioning and with a name specified as an annotation on the `PersistentVolumeClaim`. This could be used to give the creator of the `PersistentVolumeClaim` the ability to specify a secret containing a decryption key they have control over.

### Multiple Operation Secrets
A drivers may support secret keys for multiple operations. In this case, you can provide secrets references for each operation:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage-all
provisioner: csi-driver.team.example.com
parameters:
  type: pd-ssd
  csi.storage.k8s.io/provisioner-secret-name: ${pvc.name}
  csi.storage.k8s.io/provisioner-secret-namespace: ${pvc.namespace}-fast-storage
  csi.storage.k8s.io/node-publish-secret-name: ${pvc.name}-${pvc.annotations['team.example.com/key']}
  csi.storage.k8s.io/node-publish-secret-namespace: ${pvc.namespace}-fast-storage
  
```

## Operations
Details for each secret supported by the external-provisioner can be found below.

### Create/Delete Volume Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`.

* `csi.storage.k8s.io/provisioner-secret-name`
* `csi.storage.k8s.io/provisioner-secret-namespace`

The values of both of these parameters, together, refer to the name and namespace of a `Secret` object in the Kubernetes API.

If specified, the CSI `external-provisioner` will attempt to fetch the secret before provisioning and deletion.

If the secret is retrieved successfully, the provisioner passes it to the CSI driver in the `CreateVolumeRequest.secrets` or `DeleteVolumeRequest.secrets` field.

If no such secret exists in the Kubernetes API, or the provisioner is unable to fetch it, the provision operation will fail.

Note, however, that the delete operation will continue even if the secret is not found (because, for example, the entire namespace containing the secret was deleted). In this case, if the driver requires a secret for deletion, then the volume and PV may need to be manually cleaned up.

The values of these parameters may be "templates". The `external-provisioner` will automatically resolve templates at volume provision time, as detailed below:

* `csi.storage.k8s.io/provisioner-secret-name`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.
    * Support added in CSI `external-provisioner` v1.2.0+
  * `${pvc.name}`
    * Replaced with the name of the `PersistentVolumeClaim` object that triggered provisioning.
    * Support added in CSI `external-provisioner` v1.2.0+
* `csi.storage.k8s.io/provisioner-secret-namespace`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.

### Controller Publish/Unpublish Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/controller-publish-secret-name`
* `csi.storage.k8s.io/controller-publish-secret-namespace`

The values of both of these parameters, together, refer to the name and namespace of a `Secret` object in the Kubernetes API.

If specified, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.ControllerPublishSecretRef` field in the new `PersistentVolume` object to refer to this secret once provisioning is successful.

The CSI `external-attacher` then attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.ControllerPublishSecretRef`, if specified, before an attach or detach operation.

If no such secret exists in the Kubernetes API, or the `external-attacher` is unable to fetch it, the attach or detach operation fails.

If the secret is retrieved successfully, the `external-attacher` passes it to the CSI driver in the `ControllerPublishVolumeRequest.secrets` or `ControllerUnpublishVolumeRequest.secrets` field.

The values of these parameters may be "templates". The `external-provisioner` will automatically resolve templates at volume provision time, as detailed below:

* `csi.storage.k8s.io/controller-publish-secret-name`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.name}`
    * Replaced with the name of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Replaced with the value of the specified annotation from the `PersistentVolumeClaim` object that triggered provisioning
* `csi.storage.k8s.io/controller-publish-secret-namespace`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.


### Node Stage Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/node-stage-secret-name`
* `csi.storage.k8s.io/node-stage-secret-namespace`

The value of both parameters, together, refer to the name and namespace of the `Secret` object in the Kubernetes API.

If specified, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.NodeStageSecretRef` field in the new `PersistentVolume` object to refer to this secret once provisioning is successful.

The Kubernetes kubelet then attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.NodeStageSecretRef` field, if specified, before a mount device operation.

If no such secret exists in the Kubernetes API, or the kubelet is unable to fetch it, the mount device operation fails.

If the secret is retrieved successfully, the kubelet passes it to the CSI driver in the `NodeStageVolumeRequest.secrets` field.

The values of these parameters may be "templates". The `external-provisioner` will automatically resolve templates at volume provision time, as detailed below:

* `csi.storage.k8s.io/node-stage-secret-name`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.name}`
    * Replaced with the name of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Replaced with the value of the specified annotation from the `PersistentVolumeClaim` object that triggered provisioning
* `csi.storage.k8s.io/node-stage-secret-namespace`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.

### Node Publish Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/node-publish-secret-name`
* `csi.storage.k8s.io/node-publish-secret-namespace`

The value of both parameters, together, refer to the name and namespace of the `Secret` object in the Kubernetes API.

If specified, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.NodePublishSecretRef` field in the new `PersistentVolume` object to refer to this secret once provisioning is successful.

The Kubernetes kubelet, attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.NodePublishSecretRef` field, if specified, before a mount operation.

If no such secret exists in the Kubernetes API, or the kubelet is unable to fetch it, the mount operation fails.

If the secret is retrieved successfully, the kubelet passes it to the CSI driver in the `NodePublishVolumeRequest.secrets` field.

The values of these parameters may be "templates". The `external-provisioner` will automatically resolve templates at volume provision time, as detailed below:

* `csi.storage.k8s.io/node-publish-secret-name`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.name}`
    * Replaced with the name of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Replaced with the value of the specified annotation from the `PersistentVolumeClaim` object that triggered provisioning
* `csi.storage.k8s.io/node-publish-secret-namespace`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.

### Controller Expand (Volume Resize) Secret

The CSI `external-provisioner` (v1.2.0+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/controller-expand-secret-name`
* `csi.storage.k8s.io/controller-expand-secret-namespace`

The value of both parameters, together, refer to the name and namespace of the `Secret` object in the Kubernetes API.

If specified, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.ControllerExpandSecretRef` field in the new `PersistentVolume` object to refer to this secret once provisioning is successful.

The `external-resizer` (v0.2.0+), attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.ControllerExpandSecretRef` field, if specified, before starting a volume resize (expand) operation.

If no such secret exists in the Kubernetes API, or the `external-resizer` is unable to fetch it, the resize (expand) operation fails.

If the secret is retrieved successfully, the `external-resizer` passes it to the CSI driver in the `ControllerExpandVolumeRequest.secrets` field.

The values of these parameters may be "templates". The `external-provisioner` will automatically resolve templates at volume provision time, as detailed below:

* `csi.storage.k8s.io/controller-expand-secret-name`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.name}`
    * Replaced with the name of the `PersistentVolumeClaim` object that triggered provisioning.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Replaced with the value of the specified annotation from the `PersistentVolumeClaim` object that triggered provisioning
* `csi.storage.k8s.io/controller-expand-secret-namespace`
  * `${pv.name}`
    * Replaced with name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Replaced with namespace of the `PersistentVolumeClaim` object that triggered provisioning.
