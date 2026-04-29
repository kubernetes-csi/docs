# Changed Block Tracking

## Status

Status | Min K8s Version | Max K8s Version | Min CSI Version | Max CSI Version |
-------|-----------------|-----------------|-----------------|-----------------|
Beta   | 1.36            | -               | [v1.12.0](https://github.com/container-storage-interface/spec/releases/tag/v1.12.0) | -


## Overview

This optional feature provides a secure mechanism to obtain metadata
on the allocated blocks of a CSI VolumeSnapshot, or the changed blocks between two arbitrary pairs of CSI VolumeSnapshot objects of the same PersistentVolume.
See [Kubernetes Enhancement Proposal 3314](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking) 
for full details.

A CSI driver must advertise its support for this feature by specifying the
`SNAPSHOT_METADATA_SERVICE` capability in the response of the
[GetPluginCapabilities](https://github.com/container-storage-interface/spec/blob/master/spec.md#getplugincapabilities)
RPC (part of the
[CSI Identity Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#identity-service-rpc)),
and must implement the
[CSI SnapshotMetadata Service](https://github.com/container-storage-interface/spec/blob/master/spec.md#snapshot-metadata-service-rpcs).

CSI drivers that implement this feature should deploy the
[external-snapshot-metadata](./external-snapshot-metadata.md)
sidecar and create the associated 
[Snapshot Metadata Service CR](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#snapshot-metadata-service-custom-resource).
The related [SnapshotMetadataService CRD](https://github.com/kubernetes-csi/external-snapshot-metadata/blob/3a139dd44d4ffa01343a91bed40996b1db56fd38/client/config/crd/cbt.storage.k8s.io_snapshotmetadataservices.yaml)
should be installed by the Kubernetes distribution or the cluster
administrator, and must exist prior to installing the CSI driver.

The `external-snapshot-metadata` sidecar implements the server side of the
[Kubernetes SnapshotMetadata Service API](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api).
Backup applications obtain VolumeSnapshot metadata directly from the sidecar
through this API, bypassing the Kubernetes API server for the most part.
Backup application developers should refer to the [Usage](external-snapshot-metadata.md#usage)
and [Resources](external-snapshot-metadata.md#resources)
sections of the sidecar documentation for details.
