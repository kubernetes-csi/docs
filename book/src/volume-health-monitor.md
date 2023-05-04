# Volume Health Monitoring Feature

## Status

Status | Min K8s Version | Max K8s Version | external-health-monitor-controller Version
--|--|--|--
Alpha | 1.21 | - | 0.8.0


## Overview

The External Health Monitor is part of Kubernetes implementation of [Container Storage Interface (CSI)](https://github.com/container-storage-interface/spec). It was introduced as an Alpha feature in Kubernetes v1.19. In Kubernetes 1.21, a second Alpha was done due to a design change which deprecated [External Health Monitor Agent](external-health-monitor-agent).

The [External Health Monitor](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1432-volume-health-monitor) is implemented as two components: `External Health Monitor Controller` and `Kubelet`.

- External Health Monitor Controller:
  - The external health monitor controller will be deployed as a sidecar together with the CSI controller driver, similar to how the external-provisioner sidecar is deployed.
  - Trigger controller RPC to check the health condition of the CSI volumes.
  - The external controller sidecar will also watch for node failure events. This component can be enabled via a flag.

- Kubelet:
  - In addition to existing volume stats collected already, Kubelet will also check volume's mounting conditions collected from the same CSI node RPC and log events to Pods if volume condition is abnormal.

The Volume Health Monitoring feature need to invoke the following CSI interfaces.

- External Health Monitor Controller:
  - ListVolumes (If both `ListVolumes` and `ControllerGetVolume` are supported, `ListVolumes` will be used)
  - ControllerGetVolume
- Kubelet:
  - NodeGetVolumeStats
  - This feature in Kubelet is controlled by an Alpha feature gate `CSIVolumeHealth`.

See [external-health-monitor-controller.md](external-health-monitor-controller.md) for more details on the CSI `external-health-monitor-controller` sidecar.
