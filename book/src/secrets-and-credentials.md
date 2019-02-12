# Secrets and Credentials

## CSI Driver Secrets

Some drivers may require a secret in order to issue operations against a backend (a service account, for example).
If this secret is required at the "per driver" granularity (and not different "per CSI operation" or "per volume"), the secret may be injected in to CSI driver pods via [standard Kubernetes secret distribution mechanisms](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/).

## CSI Operation Secrets

The CSI spec also accepts secrets in each of the following protos:

* `CreateVolumeRequest`
* `DeleteVolumeRequest`
* `ControllerPublishVolumeRequest`
* `ControllerUnpublishVolumeRequest`
* `CreateSnapshotRequest`
* `DeleteSnapshotRequest`
* `ControllerExpandVolumeRequest`
* `NodeStageVolumeRequest`
* `NodePublishVolumeRequest`

These enable CSI drivers to accept/require "per CSI operation" or "per volume" secrets (a volume encryption key, for example).

The CSI [external-provisioner](external-provisioner.md) enables Kubernetes cluster admins to populate the secret fields for these protos with data from Kubernetes `Secret` objects. For example:

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

### Create/Delete Volume Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/provisioner-secret-name`
* `csi.storage.k8s.io/provisioner-secret-namespace`

The value of both parameters refers to the name and namespace of the `Secret` object in the Kubernetes API.

The value of both parameters may be a literal or a template containing the following variable that are automatically replaced by the `external-provisioner` at provision time:

    * `${pv.name}`
      * Automatically replaced with the name of the `PersistentVolume` object being provisioned at provision.

If specified, the CSI `external-provisioner` will attempt to fetch the secret before provisioning and deletion.

If no such secret exists in the Kubernetes API, or the provisioner is unable to fetch it, the provision or delete operation fails.

If the secret is retrieved successfully, the provisioner passes it to the CSI driver in the `CreateVolumeRequest.secrets` or `DeleteVolumeRequest.secrets` field.

### Controller Publish/Unpublish Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/controller-publish-secret-name`
* `csi.storage.k8s.io/controller-publish-secret-namespace`

The value of both parameters refers to the name and namespace of the `Secret` object in the Kubernetes API.

The value of both parameters may be a literal or a template containing the following variables that are automatically replaced by the `external-provisioner` at provision time:

  * `${pv.name}`
    * Automatically replaced with the name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Automatically replaced with the namespace of the `PersistentVolumeClaim` object being provisioned.

The value of `csi.storage.k8s.io/controller-publish-secret-namespace` also supports the following template variables which are automatically replaced by the `external-provisioner` at provision time:

  * `${pvc.name}`
    * Automatically replaced with the name of the `PersistentVolumeClaim` object being provisioned.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Automatically replaced with the value of the specified annotation from the `PersistentVolumeClaim` object being provisioned.

If specified, once provisioning is successful, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.ControllerPublishSecretRef` field in the new `PersistentVolume` object to refer to this secret.

If specified, the CSI `external-attacher` attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.ControllerPublishSecretRef` before an attach or detach operation.

If no such secret exists in the Kubernetes API, or the `external-attacher` is unable to fetch it, the attach or detach operation fails.

If the secret is retrieved successfully, the `external-attacher` passes it to the CSI driver in the `ControllerPublishVolumeRequest.secrets` or `ControllerUnpublishVolumeRequest.secrets` field.

### Node Stage Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/node-stage-secret-name`
* `csi.storage.k8s.io/node-stage-secret-namespace`

The value of both parameters refers to the name and namespace of the `Secret` object in the Kubernetes API.

The value of both parameters may be a literal or a template containing the following variables that are automatically replaced by the `external-provisioner` at provision time:

  * `${pv.name}`
    * Automatically replaced with the name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Automatically replaced with the namespace of the `PersistentVolumeClaim` object being provisioned.

The value of `csi.storage.k8s.io/node-stage-secret-namespace` also supports the following template variables which are automatically replaced by the `external-provisioner` at provision time:

  * `${pvc.name}`
    * Automatically replaced with the name of the `PersistentVolumeClaim` object being provisioned.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Automatically replaced with the value of the specified annotation from the `PersistentVolumeClaim` object being provisioned.

If specified, once provisioning is successful, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.NodeStageSecretRef` field in the new `PersistentVolume` object to refer to this secret.

If specified, the Kubernetes kubelet, attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.NodeStageSecretRef` field before a mount device operation.

If no such secret exists in the Kubernetes API, or the kubelet is unable to fetch it, the mount device operation fails.

If the secret is retrieved successfully, the kubelet passes it to the CSI driver in the `NodeStageVolumeRequest.secrets` field.

### Node Publish Secret

The CSI `external-provisioner` (v1.0.1+) looks for the following keys in `StorageClass.parameters`:

* `csi.storage.k8s.io/node-publish-secret-name`
* `csi.storage.k8s.io/node-publish-secret-namespace`

The value of both parameters refers to the name and namespace of the `Secret` object in the Kubernetes API.

The value of both parameters may be a literal or a template containing the following variables that are automatically replaced by the `external-provisioner` at provision time:

  * `${pv.name}`
    * Automatically replaced with the name of the `PersistentVolume` object being provisioned.
  * `${pvc.namespace}`
    * Automatically replaced with the namespace of the `PersistentVolumeClaim` object being provisioned.

The value of `csi.storage.k8s.io/node-publish-secret-namespace` also supports the following template variables which are automatically replaced by the `external-provisioner` at provision time:

  * `${pvc.name}`
    * Automatically replaced with the name of the `PersistentVolumeClaim` object being provisioned.
  * `${pvc.annotations['<ANNOTATION_KEY>']}` (e.g. `${pvc.annotations['example.com/key']}`)
    * Automatically replaced with the value of the specified annotation from the `PersistentVolumeClaim` object being provisioned.

If specified, once provisioning is successful, the CSI `external-provisioner` sets the `CSIPersistentVolumeSource.NodePublishSecretRef` field in the new `PersistentVolume` object to refer to this secret.

If specified, the Kubernetes kubelet, attempts to fetch the secret referenced by the `CSIPersistentVolumeSource.NodePublishSecretRef` field before a mount operation.

If no such secret exists in the Kubernetes API, or the kubelet is unable to fetch it, the mount operation fails.

If the secret is retrieved successfully, the kubelet passes it to the CSI driver in the `NodePublishVolumeRequest.secrets` field.

For example, consider this `StorageClass`:

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast-storage
provisioner: csi-driver.team.example.com
parameters:
  type: pd-ssd
  csiNodePublishSecretName: ${pvc.annotations['team.example.com/key']}
  csiNodePublishSecretNamespace: ${pvc.namespace}
```

This StorageClass instructs the CSI provisioner to do the following:
* Create a `PersistentVolume` with:
  * a "node publish secret" in the same namespace as the `PersistentVolumeClaim` that triggered the provisioning, with a name specified as an annotation on the `PersistentVolumeClaim`. This could be used to give the creator of the `PersistentVolumeClaim` the ability to specify a secret containing a decryption key they have control over.

## Handling Sensitive Information

CSI Drivers that accept secrets SHOULD handle this data carefully. It may contain sensitive information and MUST be treated as such (e.g. not logged).

To make it easier to handle secret fields (e.g. strip them from CSI protos when logging), the CSI spec defines a decorator (`csi_secret`) on all fields containing sensitive information. Any fields decorated with `csi_secret` MUST be treated as if they contain sensitive information (e.g. not logged, etc.).

The Kubernetes CSI development team also provides a GO lang package called `protosanitizer` that CSI driver developers may be used to remove values for all fields in a gRPC messages decorated with `csi_secret`. The library can be found in [kubernetes-csi/csi-lib-utils/protosanitizer](https://github.com/kubernetes-csi/csi-lib-utils/tree/master/protosanitizer). The Kubernetes CSI [Sidecar Containers](sidecar-containers.md) and sample drivers use this library to ensure no sensitive information is logged.
