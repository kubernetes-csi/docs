# CSI Topology Feature

> ## *This page is still under active development.*

**Status:** Alpha

Some storage systems expose volumes that are not equally accessible by all nodes in a Kubernetes cluster. Instead volumes may be constrained to some subset of node(s) in the cluster. The cluster may be segmented into, for example, “racks” or “regions” and “zones” or some other grouping, and a given volume may be accessible only from one of those groups.

To enable orchestration systems, like Kubernetes, to work well with storage systems which expose volumes that are not equally accessible by all nodes, the [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md) enables:

1. Ability for a CSI Driver to opaquely specify where a particular node exists (e.g. "node A" is in "zone 1").
2. Ability for Kubernetes (users or components) to influence where a volume is provisioned (e.g. provision new volume in either "zone 1" or "zone 2").
3. Ability for a CSI Driver to opaquely specify where a particular volume exists (e.g. "volume X" is accessible by all nodes in "zone 1" and "zone 2").

Kubernetes and the Kubernetes CSI [Sidecar Containers](sidecar-containers.md) use these abilities to make intelligent scheduling and provisioning decisions (that Kubernetes can both influence and act on topology information for each volume),

## Implementing Topology

TODO: Explain the CSI calls and capabilities that must be implemented.
TODO: Explain what CSI CRDs the feature depends on.

## Usage

In order to support topology-aware dynamic provisioning mechanisms available in Kubernetes, the *external-provisioner* must have the Topology feature enabled:

```
--feature-gates=Topology=true
```

In addition, in the *Kubernetes cluster* the `CSINodeInfo` alpha feature must be enabled (refer to the [CSINodeInfo Object](csi-node-info-object.md) section for more info):

```
--feature-gates=CSINodeInfo=true
```

The `KubeletPluginsWatcher` feature must also be enabled (GA and enabled by default in Kubernetes 1.13).

## Storage Internal Topology

Note that a storage system may also have an "internal topology" different from (independent of) the topology of the cluster where workloads are scheduled. Meaning volumes exposed by the storage system are equally accessible by all nodes in the Kubernetes cluster, but the storage system has some internal topology that may influence, for example, the performance of a volume from a given node.

CSI does not currently expose a first class mechanism to influence such storage system internal topology on provisioning. Therefore, Kubernetes can not programmatically influence such topology. However, a CSI Driver may expose the ability to specify internal storage topology during volume provisioning using an opaque parameter in the `CreateVolume` CSI call (CSI enables CSI Drivers to expose an arbitrary set of configuration options during dynamic provisioning by allowing opaque parameters to be passed from cluster admins to the storage plugins) -- this would enable cluster admins to be able to control the storage system internal topology during provisioning.
