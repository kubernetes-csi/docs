# Volume Health Monitoring Feature

## Status

Status | CSI external-health-monitor-controller sidecar Version | CSI external-health-monitor-agent sidecar Version
--|--|--
Alpha | 0.1.0 | 0.1.0

## Overview

The External Health Monitor is part of Kubernetes implementation of [Container Storage Interface (CSI)](https://github.com/container-storage-interface/spec). It was introduced as an Alpha feature in Kubernetes v1.19.

The [External Health Monitor](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1432-volume-health-monitor) is impelmeted as two components: `External Health Monitor Controller` and `External Health Monitor Agent`.

- External Health Monitor Controller:
  - The external health monitor controller will be deployed as a sidecar together with the CSI controller driver, similar to how the external-provisioner sidecar is deployed.
  - Trigger controller RPC to check the health condition of the CSI volumes.
  - The external controller sidecar will also watch for node failure events. This component can be enabled by setting the `enable-node-watcher` flag to `true`. This will only have effects on local PVs now. When a node failure event is detected, an event will be reported on the PVC to indicate that pods using this PVC are on a failed node.

- External Health Monitor Agent:
  - The external health monitor agent will be deployed as a sidecar together with the CSI node driver on every Kubernetes worker node.
  - Trigger node RPC to check volume's mounting conditions.

The External Health Monitor needs to invoke the following CSI interfaces

- External Health Monitor Controller:
  - ListVolumes
  - ControllerGetVolume
- External Health Monitor Agent:
  - NodeGetVolumeStats

The External Health Monitor Controller calls either `ListVolumes` or `ControllerGetVolume` CSI RPC and reports `VolumeConditionAbnormal` events with messages on PVCs if abnormal volume conditions are detected.

The External Health Monitor Agent calls `NodeGetVolumeStats` CSI RPC and reports `VolumeConditionAbnormal` events with messages on Pods if abnormal volume conditions are detected.

See [external-health-monitor-controller.md](external-health-monitor-controller.md) for more details on the CSI `external-health-monitor-controller` sidecar.

See [external-health-monitor-agent.md](external-health-monitor-agent.md) for more details on the CSI `external-health-monitor-agent` sidecar.
