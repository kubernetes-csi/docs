# Import Existing Snapshot

## Overview

When you have an existing snapshot in your underlying storage system
and you want it accessible inside your Kubernetes cluster,
you can import it into a _VolumeSnapshot_ by manually making the paired
_VolumeSnapshotContent_ object, and then referencing the _VolumeSnapshotContent_
and _VolumeSnapshot_ to each other.

You will likely still only interact with the _VolumeSnapshot_ as normal, this is just
needed to bootstrap the external snapshot into the _VolumeSnapshot_.

## Example

This is an example using the AWS implementation of EBS snapshots.

```yaml
---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: my-snapshot-from-existing-source
spec:
  volumeSnapshotClassName: my-snapshot-classname
  source:
    volumeSnapshotContentName: my-snapshot-from-existing-source-content
---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotContent
metadata:
  name: my-snapshot-from-existing-source-content
spec:
  volumeSnapshotRef:
    kind: VolumeSnapshot
    name: my-snapshot-from-existing-source
    namespace: my-ns
  driver: ebs.csi.aws.com # TODO: Change to your driver, needs to match your volumeSnapshotClassName
  volumeSnapshotClassName: my-snapshot-classname
  deletionPolicy: Retain # Note: This much match the deletionPolicy of your volumeSnapshotClassName
  source:
    snapshotHandle: snap-656e8fe7f6b68a4d1 # Snapshot ID from AWS
```