# CSI external-snapshot-metadata

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshot-metadata](https://github.com/kubernetes-csi/external-snapshot-metadata)

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version) |
--|--|--|--|--|--|--|--
v0.1.0 | [v0.1.0](https://github.com/kubernetes-csi/external-snapshot-metadata/releases/tag/v0.1.0) | [v1.10.0](https://github.com/container-storage-interface/spec/releases/tag/v1.10.0) | - | registry.k8s.io/sig-storage/csi-snapshot-metadata:v0.1.0 | v1.32 | - | v1.32


## Alpha

### Description
This sidecar securely serves snapshot metadata to Kubernetes clients through the
[Kubernetes SnapshotMetadata Service API](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api).
This API is similar to the
[CSI SnapshotMetadata Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#snapshot-metadata-service-rpcs)
but is designed to be used by Kuberetes authenticated and authorized backup applications.
Its [protobuf specification](https://github.com/kubernetes-csi/external-snapshot-metadata/tree/main/proto/schema.proto)
is available in the sidecar repository. 

The sidecar authenticates and authorizes each Kubernetes backup application request made through the
Kubernetes SnapshotMetadata Service API.
It then acts as a proxy as it fetches the desired metadata from the CSI driver and
streams it directly to the requesting application with no load on the Kubernetes API server.

See ["The External Snapshot Metadata Sidecar"](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-external-snapshot-metadata-sidecar)
section in the CSI Changed Block Tracking KEP for additional details on the sidecar.

### Usage
Backup applications, identified by their authorized ServiceAccount objects,
directly communicate with the sidecar using the
[Kubernetes SnapshotMetadata Service API](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api).
The authorization needed is described in the 
["Risks and Mitigations"](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#risks-and-mitigations)
section of the CSI Changed Block Tracking KEP.
In particular, this requires the ability to use the Kubernetes
[TokenRequest](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-request-v1/)
API and to access the objects required to use the API.

The availability of this optional feature is advertised to backup applications by the presence of a
[Snapshot Metadata Service CR](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#snapshot-metadata-service-custom-resource)
that is named for the CSI driver that provisioned the PersistentVolume and VolumeSnapshot objects involved.
The CR contains a gRPC service endpoint and CA certificate, and an audience string for authentication.
A backup application must use the Kubernetes
[TokenRequest](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-request-v1/)
API with the audience string to obtain a Kubernetes authentication token for use in the
Kubernetes SnapshotMetadata Service API call.
The backup application should establish trust for the CA certificate before making the gRPC call
to the service endpoint.

The Kubernetes SnapshotMetadata Service API uses a gRPC stream to return VolumeSnapshot metadata
to the backup application. Metadata can be lengthy, so the API supports
restarting an interrupted metadata request from an intermediate point in case of failure.
The [Resources](external-snapshot-metadata.md#resources) section below describes the
programming artifacts available to support backup application use of this API.

### Deployment
The CSI `external-snapshot-metadata` sidecar should be deployed by
CSI drivers that support the
[Changed Block Tracking](./changed-block-tracking.md) feature.
The sidecar must be deployed in the same pod as the CSI driver and
will communicate with its gRPC [CSI SnapshotMetadata Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#snapshot-metadata-service-rpcs)
and [CSI Identity Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#identity-service-rpc)
over a UNIX domain socket.

The sidecar should be configured to run under the authority of its
CSI driver ServiceAccount, which must be authorized as described in the 
["Risks and Mitigations"](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#risks-and-mitigations)
section of the CSI Changed Block Tracking KEP.
In particular, this requires the ability to use the Kubernetes
[TokenReview](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-review-v1/)
and
[SubjectAccessReview](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/subject-access-review-v1/)
APIs.

A Service object must be created to expose the endpoints of the
[Kubernetes SnapshotMetadata Service API](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api)
gRPC server implemented by the sidecar.

A [SnapshotMetadataService CR](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#snapshot-metadata-service-custom-resource),
named for the CSI driver, must be created to advertise the
availability of this optional feature to Kubernetes backup application clients.
The CR contains the CA certificate and Service endpoint address
of the sidecar and the audience string needed for the client
authentication token.

### Resources

The [external-snapshot-metadata repository](https://github.com/kubernetes-csi/external-snapshot-metadata) contains
the [protobuf specification](https://github.com/kubernetes-csi/external-snapshot-metadata/tree/main/proto/schema.proto)
of the
[Kubernetes SnapshotMetadata Service API](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api).

In addition, the repository has a number of useful artifacts to support Go language programs:

- The
[Go client interface](https://github.com/kubernetes-csi/external-snapshot-metadata/tree/main/client)
for the Kubernetes SnapshotMetadata Service API.

- The
[pkg/iterator](https://github.com/kubernetes-csi/external-snapshot-metadata/tree/main/pkg/iterator)
client helper package.
This may be used by backup applications instead of working directly with the 
Kubernetes SnapshotMetadata Service gRPC client interfaces.
The
[snapshot-metadata-lister](https://github.com/kubernetes-csi/external-snapshot-metadata/tree/main/examples/snapshot-metadata-lister)
example Go command illustrates the use of this helper package.

- Go language
[CSI SnapshotMetadataService API client mocks](https://github.com/kubernetes-csi/external-snapshot-metadata/tree/main/pkg/csiclientmocks).

The sample [Hostpath CSI driver](example.md) has been extended to support the
[Changed Block Tracking](./changed-block-tracking.md) feature
and provides an illustration on how to deploy a CSI driver.
