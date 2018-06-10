# Usage
There are two main models of how to use storage in Kubernetes with CSI drivers. These models include either the usage of pre-provisioned volumes or dynamic provisioned volumes. Please check the documentation of your specific driver for more information.

### Pre-provisioned volumes
Pre-provisioned drivers work just as they did before, where the administrator would create a [_PersistentVolume_](https://kubernetes.io/docs/concepts/storage/persistent-volumes) specification which would describe the volume to be used. The PersistentVolume specification would need to be setup according to your driver, the difference here is that there is a new section called _csi_ which needs to be setup accordingly. Please see [Kubernetes Documentation on CSI Volumes][csi-volume].

Here is an example of a _PersistentVolume_ specification of a pre-provisioned volume managed by a CSI driver:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: manually-created-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  csi:
    driver: com.example.team/csi-driver
    volumeHandle: existingVolumeName
    readOnly: false
```

### Dynamic Provisioning
To setup the system for dynamic provisioning, the administrator needs to setup a [_StorageClass_](https://kubernetes.io/docs/concepts/storage/storage-classes) pointing to the CSI driver’s external-provisioner and specifying any parameters required by the driver. Here is an example of a StorageClass:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage
provisioner: com.example.team/csi-driver
parameters:
  type: pd-ssd
```

Where,

* _provisioner_: Must be set to the name of the CSI driver
* _parameters_: Must contain any parameters specific to the CSI driver.

The user can then create a _PersistentVolumeClaim_ utilizing this StorageClass as follows:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: request-for-storage
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: fast-storage
```

[csi-volume]: https://kubernetes.io/docs/concepts/storage/volumes/#csi


#### CSI Provisioner Parameters

The CSI dynamic provisioner makes `CreateVolumeRequest` and `DeleteVolumeRequest` calls to CSI drivers.
The `controllerCreateSecrets` and `controllerDeleteSecrets` fields in those requests can be populated 
with data from a Kubernetes `Secret` object by setting `csiProvisionerSecretName` and `csiProvisionerSecretNamespace`
parameters in the `StorageClass`. For example:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage
provisioner: com.example.team/csi-driver
parameters:
  type: pd-ssd
  csiProvisionerSecretName: fast-storage-provision-key
  csiProvisionerSecretNamespace: pd-ssd-credentials
```

The `csiProvisionerSecretName` and `csiProvisionerSecretNamespace` parameters
may specify literal values, or a template containing the following variables:
* `${pv.name}` - replaced with the name of the PersistentVolume object being provisioned

Once the CSI volume is created, a corresponding Kubernetes `PersistentVolume` object is created.
The `controllerPublishSecretRef`, `nodeStageSecretRef`, and `nodePublishSecretRef` fields in the 
`PersistentVolume` object can be populated via the following storage class parameters:

* `controllerPublishSecretRef` in the PersistentVolume is populated by setting these StorageClass parameters:
  * `csiControllerPublishSecretName`
  * `csiControllerPublishSecretNamespace`
* `nodeStageSecretRef` in the PersistentVolume is populated by setting these StorageClass parameters:
  * `csiNodeStageSecretName`
  * `csiNodeStageSecretNamespace`
* `nodePublishSecretRef` in the PersistentVolume is populated by setting these StorageClass parameters:
  * `csiNodePublishSecretName`
  * `csiNodePublishSecretNamespace`

The `csiControllerPublishSecretName`, `csiNodeStageSecretName`, and `csiNodePublishSecretName` parameters
may specify a literal secret name, or a template containing the following variables:
* `${pv.name}` - replaced with the name of the PersistentVolume
* `${pvc.name}` - replaced with the name of the PersistentVolumeClaim
* `${pvc.namespace}` - replaced with the namespace of the PersistentVolumeClaim
* `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`) - replaced with the value of the specified annotation in the PersistentVolumeClaim

The `csiControllerPublishSecretNamespace`, `csiNodeStageSecretNamespace`, and `csiNodePublishSecretNamespace` parameters
may specify a literal namespace name, or a template containing the following variables:
* `${pv.name}` - replaced with the name of the PersistentVolume
* `${pvc.namespace}` - replaced with the namespace of the PersistentVolumeClaim

As an example, consider this StorageClass:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage
provisioner: com.example.team/csi-driver
parameters:
  type: pd-ssd

  csiProvisionerSecretName: fast-storage-provision-key
  csiProvisionerSecretNamespace: pd-ssd-credentials

  csiControllerPublishSecretName: ${pv.name}-publish
  csiControllerPublishSecretNamespace: pd-ssd-credentials

  csiNodeStageSecretName: ${pv.name}-stage
  csiNodeStageSecretNamespace: pd-ssd-credentials

  csiNodePublishSecretName: ${pvc.annotations['com.example.team/key']}
  csiNodePublishSecretNamespace: ${pvc.namespace}
```

This StorageClass instructs the CSI provisioner to do the following:
* send the data in the `fast-storage-provision-key` secret in the `pd-ssd-credentials` namespace as part of the create request to the CSI driver
* create a PersistentVolume with:
  * a per-volume controller publish and node stage secret, both in the `pd-ssd-credentials` (those secrets would need to be created separately in response to the PersistentVolume creation before the PersistentVolume could be attached/mounted)
  * a node publish secret in the same namespace as the PersistentVolumeClaim that triggered the provisioning, with a name specified as an annotation on the PersistentVolumeClaim. This could be used to give the creator of the PersistentVolumeClaim the ability to specify a secret containing a decryption key they have control over.
