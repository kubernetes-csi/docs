# CSI Topology Feature

## Status

Status | Min K8s Version | Max K8s Version | external-provisioner Version
--|--|--|--
Alpha | 1.12 | 1.12 | 0.4
Alpha | 1.13 | 1.13 | 1.0
Beta | 1.14 | 1.16 | 1.1-1.4
GA   | 1.17 | - | 1.5+

## Overview
Some storage systems expose volumes that are not equally accessible by all nodes in a Kubernetes cluster. Instead volumes may be constrained to some subset of node(s) in the cluster. The cluster may be segmented into, for example, “racks” or “regions” and “zones” or some other grouping, and a given volume may be accessible only from one of those groups.

To enable orchestration systems, like Kubernetes, to work well with storage systems which expose volumes that are not equally accessible by all nodes, the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md) enables:

1. Ability for a CSI Driver to opaquely specify where a particular node exists (e.g. "node A" is in "zone 1").
2. Ability for Kubernetes (users or components) to influence where a volume is provisioned (e.g. provision new volume in either "zone 1" or "zone 2").
3. Ability for a CSI Driver to opaquely specify where a particular volume exists (e.g. "volume X" is accessible by all nodes in "zone 1" and "zone 2").

Kubernetes and the [external-provisioner](external-provisioner.md) use these abilities to make intelligent scheduling and provisioning decisions (that Kubernetes can both influence and act on topology information for each volume),

## Implementing Topology in your CSI Driver

To support topology in a CSI driver, the following must be implemented:

* The `PluginCapability` must support `VOLUME_ACCESSIBILITY_CONSTRAINTS`.
* The plugin must fill in `accessible_topology` in `NodeGetInfoResponse`.
  This information will be used to populate the Kubernetes [CSINode object](csi-node-object.md) and add the topology labels to the Node object.
* During `CreateVolume`, the topology information will get passed in through `CreateVolumeRequest.accessibility_requirements`.

In the StorageClass object, both `volumeBindingMode` values of `Immediate` and
`WaitForFirstConsumer` are supported.

* If `Immediate` is set, then the
  external-provisioner will pass in all available topologies in the cluster for
  the driver.
* If `WaitForFirstConsumer` is set, then the external-provisioner will wait for
  the scheduler to pick a node. The topology of that selected node will then be
  set as the first entry in `CreateVolumeRequest.accessibility_requirements.preferred`.
  All remaining topologies are still included in the `requisite` and `preferred`
  fields to support storage systems that span across multiple topologies.

## Sidecar Deployment

The topology feature requires the
[external-provisioner](external-provisioner.md) sidecar with the
Topology feature gate enabled:

```
--feature-gates=Topology=true
```

## Kubernetes Cluster Setup

### Beta

In the *Kubernetes cluster* the `CSINodeInfo` feature must be enabled on both the Kubernetes control plane and nodes (refer to the [CSINode Object](csi-node-object.md) section for more info):

```
--feature-gates=CSINodeInfo=true
```

In order to fully function properly, the Kubernetes control plane and all nodes must be on at least
Kubernetes 1.14. If a selected node is on a lower version, topology is ignored and not
passed to the driver during `CreateVolume`.

### Alpha

The alpha feature in the external-provisioner is not compatible across
Kubernetes versions. In addition, Kubernetes control plane and node version skew and
upgrades are not supported.

The `CSINodeInfo`, `VolumeScheduling`, and `KubeletPluginsWatcher` feature gates
must be enabled on both the Kubernetes control plane and nodes.

The [CSINodeInfo](csi-node-object.md) CRDs also have to be manually installed in the
cluster.

## Storage Internal Topology

Note that a storage system may also have an "internal topology" different from (independent of) the topology of the cluster where workloads are scheduled. Meaning volumes exposed by the storage system are equally accessible by all nodes in the Kubernetes cluster, but the storage system has some internal topology that may influence, for example, the performance of a volume from a given node.

CSI does not currently expose a first class mechanism to influence such storage system internal topology on provisioning. Therefore, Kubernetes can not programmatically influence such topology. However, a CSI Driver may expose the ability to specify internal storage topology during volume provisioning using an opaque parameter in the `CreateVolume` CSI call (CSI enables CSI Drivers to expose an arbitrary set of configuration options during dynamic provisioning by allowing opaque parameters to be passed from cluster admins to the storage plugins) -- this would enable cluster admins to be able to control the storage system internal topology during provisioning.
