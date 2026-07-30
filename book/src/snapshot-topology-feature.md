# Volume Snapshot Topology Feature

## Status

<!--
TODO BEFORE MERGE: sidecar versions below are the anticipated next minor releases and
are provisional. The external-snapshotter and external-provisioner changes are still
under review upstream and not yet merged/tagged; update these once the releases carrying
this feature are cut.
-->
Status | Min K8s Version | snapshot-controller Version | CSI external-snapshotter sidecar Version | external-provisioner Version | scheduler-plugins Version
--|--|--|--|--|--
Alpha | 1.37 | 8.7+ | 8.7+ | 5.4+ | TBD

## Overview

Some storage systems expose snapshots that are not equally accessible from all
nodes in a Kubernetes cluster. For example, in a multi-zone cluster where storage
is not shared across zones, a snapshot of a volume in one zone is only usable from
that same zone: volumes restored from the snapshot can only be created and attached
where the snapshot data actually resides.

Before this feature, Kubernetes had no way to record or honor where a snapshot is
usable from. A volume restored from a snapshot could be provisioned in a topology
segment where the snapshot data does not exist, leaving the volume unschedulable or
the restore failing at the storage layer.

The Volume Snapshot Topology feature (KEP-5943) lets a CSI driver report where a
snapshot is usable from, records it on the `VolumeSnapshotContent` object, and honors
it when provisioning a volume from the snapshot.

A snapshot is "usable from" a topology segment if a volume created from that snapshot
is accessible there.

## Implementing Snapshot Topology in your CSI Driver

To support snapshot topology, a CSI driver MUST:

* Advertise the `SNAPSHOT_ACCESSIBILITY_CONSTRAINTS` plugin capability.
* Populate `accessible_topology` on the `Snapshot` message returned from
  `CreateSnapshot`, describing where the snapshot is usable from.

The driver MAY also honor `accessibility_requirements` passed in the
`CreateSnapshotRequest` when the storage system can choose where a snapshot is
created. `accessibility_requirements` reuses the existing `TopologyRequirement`
`requisite`/`preferred` semantics from volume provisioning so there is no separate
negotiation mechanism.

For details, see the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md).

## API

When the feature is enabled, `VolumeSnapshotContent.spec` gains a `nodeAffinity`
field (`[]TopologySelectorTerm`) describing where the snapshot is usable from. The
field is optional and mutable.

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotContent
metadata:
  name: snapcontent-72d9a349-aacd-42d2-a240-d775650d2455
spec:
  deletionPolicy: Delete
  driver: hostpath.csi.k8s.io
  source:
    volumeHandle: ee0cfb94-f8d4-11e9-b2d8-0242ac110002
  volumeSnapshotClassName: csi-hostpath-snapclass
  volumeSnapshotRef:
    name: new-snapshot-test
    namespace: default
  nodeAffinity:
    - matchLabelExpressions:
        - key: topology.kubernetes.io/zone
          values:
            - us-east-1a
```

A cluster administrator can request where dynamically created snapshots should be
usable from by setting `allowedTopologies` on the `VolumeSnapshotClass`:

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: csi-hostpath-snapclass
driver: hostpath.csi.k8s.io
deletionPolicy: Delete
allowedTopologies:
  - matchLabelExpressions:
      - key: topology.kubernetes.io/zone
        values:
          - us-east-1a
          - us-east-1b
```

## Controller

* The csi-snapshotter sidecar forwards `VolumeSnapshotClass.allowedTopologies` to the
  driver as `CreateSnapshotRequest.accessibility_requirements`, and records the
  driver-returned `accessible_topology` on `VolumeSnapshotContent.spec.nodeAffinity`.

When provisioning a volume from a snapshot, `VolumeSnapshotContent.spec.nodeAffinity`
is used to place the restored volume where the snapshot data is accessible:

* For `Immediate` binding, the external-provisioner intersects the snapshot's
  `nodeAffinity` with `StorageClass.allowedTopologies` and provisions in the
  intersection. If the intersection is empty, provisioning fails fast with an event
  rather than creating a volume in an inaccessible segment.
* For `WaitForFirstConsumer` binding, the scheduler restricts the pod (and therefore
  the volume) to nodes that satisfy the snapshot's `nodeAffinity`, using the
  out-of-tree `SnapshotTopology` scheduler plugin.

## Feature Gate

The feature is alpha and disabled by default. Enable the `VolumeSnapshotTopology`
feature gate on the csi-snapshotter and external-provisioner sidecars:

```
--feature-gates=VolumeSnapshotTopology=true
```

When the gate is off, `VolumeSnapshotContent.spec.nodeAffinity` is never populated
and is ignored by the external-provisioner, preserving prior behavior.

## Scheduler Plugin

`Immediate`-binding enforcement is handled entirely by the external-provisioner and
needs no extra components. `WaitForFirstConsumer` enforcement, however, happens at
scheduling time and requires the out-of-tree `SnapshotTopology` scheduler plugin from
[kubernetes-sigs/scheduler-plugins](https://github.com/kubernetes-sigs/scheduler-plugins).

The plugin implements the `PreFilter` and `Filter` extension points: it resolves a
pod's snapshot-sourced PVC to its `VolumeSnapshotContent`, reads the recorded
`nodeAffinity`, and filters out nodes that do not satisfy it, so the volume is
provisioned only where the snapshot data is accessible.

To use it, run a scheduler built with the `SnapshotTopology` plugin enabled in its
profile (either as your cluster's scheduler or as a second scheduler), and set
`schedulerName` on the pods that restore from topology-constrained snapshots. See the
[scheduler-plugins installation guide](https://github.com/kubernetes-sigs/scheduler-plugins/blob/master/doc/install.md)
for how to deploy and configure a scheduler-plugins scheduler.

Unlike the sidecars, the scheduler plugin is not toggled by the
`VolumeSnapshotTopology` feature gate; enforcement is controlled by whether the plugin
is present in the scheduler profile.

## Kubernetes Cluster Setup

See the Deployment section of [Snapshot Controller](snapshot-controller.md) on how
to set up the snapshot controller and CRDs.

## Examples

See the [Drivers](drivers.md) for a list of CSI drivers that implement the snapshot
feature.
