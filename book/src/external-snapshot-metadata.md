# CSI external-snapshot-metadata

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshot-metadata](https://github.com/kubernetes-csi/external-snapshot-metadata)

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version) |
--|--|--|--|--|--|--|--
*Unavailable* | *Unavailable* | [v1.10.0](https://github.com/container-storage-interface/spec/releases/tag/v1.10.0) | - |*Unavailable* | v1.32 | - | v1.32


## Alpha

### Description
The sidecar securely serves snapshot metadata to Kubernetes clients through the
[Kubernetes SnapshotMetadata gRPC Service](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api).
It handles all aspects of Kubernetes client authentication and authorization necessary, with minimal load on the Kubernetes API server.

See [The External Snapshot Metadata Sidecar](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-external-snapshot-metadata-sidecar)
section in the CSI Changed Block Tracking KEP
for additional details on the sidecar.


### Usage
Backup applications communicate with the sidecar using the
[Kubernetes SnapshotMetadata](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api)
gRPC service.
To support mutual authentication and authorization, the backup application must trust the CA certificate used by the sidecar and must use the Kubernetes 
[TokenRequest](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-request-v1/)
API with the sidecar's audience string to obtain an authentication token.

The sidecar audience string and CA certificate should be obtained from the
[Snapshot Metadata Service CR](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#snapshot-metadata-service-custom-resource)
named for the CSI driver that provisions the PersistentVolumes involved.

The sidecar authenticates and authorizes each backup application
request, and then acts as a proxy as it fetches the desired metadata from
the CSI driver for that request, and streams it to the requesting application.

### Deployment
The CSI `external-snapshot-metadata` sidecar should be deployed by
CSI drivers that support the
[Changed Block Tracking](./changed-block-tracking.md) feature.
The sidecar must be deployed in the same pod as the CSI driver and
will communicate with its CSI [SnapshotMetadata](https://github.com/container-storage-interface/spec/blob/master/spec.md#snapshot-metadata-service-rpcs)
and [Identity](https://github.com/container-storage-interface/spec/blob/master/spec.md#identity-service-rpc) gRPC services
over a UNIX domain socket.

The sidecar should be configured to run under the authority of its
CSI driver ServiceAccount, which must be authorized as described
in the 
[Risks and Mitigations](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#risks-and-mitigations)
section of the CSI Changed Block Tracking KEP.
In particular, this requires the ability to
use the Kubernetes
[TokenReview](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-review-v1/)
and
[SubjectAccessReview](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/subject-access-review-v1/)
APIs.

A Service object must be created for the TCP based [Kubernetes SnapshotMetadata](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api)
gRPC service implemented by the sidecar.

A [SnapshotMetadataService CR](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#snapshot-metadata-service-custom-resource),
named for the CSI driver, must be created to advertise the
availability of this optional feature.
The CR contains the CA certificate and Service endpoint address
of the sidecar and the audience string needed for the client
authentication token.

