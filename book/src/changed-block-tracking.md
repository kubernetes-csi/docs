# Changed Block Tracking

## Status

Status | Min K8s Version | Max K8s Version | external-provisioner Version
-------|-----------------|-----------------|-----------------------------
Alpha  | 1.32            | -               | *Unknown*


## Overview

This optional feature provides a secure mechanism to obtain metadata
on the allocated blocks of a CSI VolumeSnapshot, or the changed blocks between two arbitrary pairs of CSI VolumeSnapshot objects of the same PersistentVolume.

Snapshot metadata must be fetched directly with the
[Kuberenets SnapshotMetadata](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking#the-kubernetes-snapshotmetadata-service-api)
gRPC service from an [external-snapshot-metadata](./external-snapshot-metadata.md) 
sidecar configured by the CSI driver.
This bypasses the Kubernetes API server for the most part: the API
server is used only to fetch the Kubernetes objects needed for secure, authorized and mutually authenticated communication.

> See the [Kubernetes Enhancement Proposal](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/3314-csi-changed-block-tracking) 
> for details of the Changed Block Tracking feature.
