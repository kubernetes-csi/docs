# Usage
There are two main models of how to use storage in Kubernetes with CSI drivers. These models include either the usage of pre-provisioned volumes or dynamic provisioned volumes. Please check the documentation of your specific driver for more information.

### Pre-provisioned volumes
Pre-provisioned drivers work just as they did before, where the administrator would create a [_PersistentVolume_](https://kubernetes.io/docs/concepts/storage/persistent-volumes) specification which would describe the volume to be used. The PersistentVolume specification would need to be setup according to your driver, the difference here is that there is a new section called _csi_ which needs to be setup accordingly. Please see Kubernetes Documentation on CSI Volumes (**LINK TBD**).

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



