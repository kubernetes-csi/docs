# Secrets and Credentials

Some drivers may require a secret in order to complete operations.

## CSI Driver Secrets

If a CSI Driver requires secrets for a backend (a service account, for example), and this secret is required at the "per driver" granularity (not different "per CSI operation" or "per volume"), then the secret SHOULD be injected directly in to CSI driver pods via [standard Kubernetes secret distribution mechanisms](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/) during deployment.

## CSI Operation Secrets

If a CSI Driver requires secrets "per CSI operation" or "per volume" or "per storage pool", the CSI spec allows secrets to be passed in for various CSI operations (including `CreateVolumeRequest`, `ControllerPublishVolumeRequest`, and more).

Cluster admins can populate such secrets by creating Kubernetes `Secret` objects and specifying the keys in the `StorageClass` or `SnapshotClass` objects.

The CSI sidecar containers facilitate the handling of secrets between Kubernetes and the CSI Driver. For more details see:
* [StorageClass Secrets](secrets-and-credentials-storage-class.md)
* [VolumeSnapshotClass Secrets](secrets-and-credentials-volume-snapshot-class.md)

### Secret RBAC Rules

For reducing RBAC permissions as much as possible, secret rules are disabled in each sidecar repository by default.

Please add or update RBAC rules if secret is expected to use.

To set proper secret permission, uncomment related lines defined in `rbac.yaml` (e.g. [external-provisioner/deploy/kubernetes/rbac.yaml](https://github.com/kubernetes-csi/external-provisioner/blob/22bb6401d2484ee3ca18a23d75c3864c774e5f32/deploy/kubernetes/rbac.yaml#L24))

## Handling Sensitive Information

CSI Drivers that accept secrets SHOULD handle this data carefully. It may contain sensitive information and MUST be treated as such (e.g. not logged).

To make it easier to handle secret fields (e.g. strip them from CSI protos when logging), the CSI spec defines a decorator (`csi_secret`) on all fields containing sensitive information. Any fields decorated with `csi_secret` MUST be treated as if they contain sensitive information (e.g. not logged, etc.).

The Kubernetes CSI development team also provides a GO lang package called `protosanitizer` that CSI driver developers may be used to remove values for all fields in a gRPC messages decorated with `csi_secret`. The library can be found in [kubernetes-csi/csi-lib-utils/protosanitizer](https://github.com/kubernetes-csi/csi-lib-utils/tree/master/protosanitizer). The Kubernetes CSI [Sidecar Containers](sidecar-containers.md) and sample drivers use this library to ensure no sensitive information is logged.
