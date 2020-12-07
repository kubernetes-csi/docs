# Storage Capacity Tracking

## Status

Status | Min K8s Version | Max K8s Version
--|--|--
Alpha | 1.19 | -

## Overview

Storage capacity tracking allows the Kubernetes scheduler to make more
informed choices about where to start pods which depend on unbound
volumes with late binding (aka "wait for first consumer"). Without
storage capacity tracking, a node is chosen without knowing whether
those volumes can be made available for the node. Volume creation is
attempted and if that fails, the pod has to be rescheduled,
potentially landing on the same node again. With storage capacity
tracking, the scheduler filters our nodes which do not have enough
capacity.

> For design information, see the [enhancement
> proposal](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1472-storage-capacity-tracking).

## Usage

To support rescheduling of a pod, a CSI driver deployment must:
- return the `ResourceExhausted` gRPC status code in `CreateVolume` if
  capacity is exhausted
- use external-provisioner >= 1.6.0 because older releases did not
  properly support rescheduling after a `ResourceExhausted` error

To support storage capacity tracking, a CSI driver deployment must:
- implement the `GetCapacity` call
- use external-provisioner >= 2.0.0
- enable producing of storage capacity objects as explained in the
  [external-provisioner
  documentation](https://github.com/kubernetes-csi/external-provisioner/tree/release-2.0#capacity-support)
- enable usage of that information by setting the
  [`CSIDriverSpec.StorageCapacity`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#csidriverspec-v1-storage-k8s-io)
  field to `True`
- run on a cluster where the storage capacity API is
  [enabled](https://kubernetes.io/docs/concepts/storage/storage-capacity/#enabling-storage-capacity-tracking)

> Further information can be found in the [Kubernetes
> documentation](https://kubernetes.io/docs/concepts/storage/storage-capacity/).
