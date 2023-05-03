# CSI external-health-monitor-controller

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-health-monitor](https://github.com/kubernetes-csi/external-health-monitor)

**Status:** Alpha 

### Supported Versions
Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image
--|--|--|--|--
[external-health-monitor-controller v0.8.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.8.0) | [release-0.8](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.8) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-controller:v0.8.0
[external-health-monitor-controller v0.7.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.7.0) | [release-0.7](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.7) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-controller:v0.7.0
[external-health-monitor-controller v0.6.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.6.0) | [release-0.6](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.6) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-controller:v0.6.0

### Unsupported Versions
Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image
--|--|--|--|--
[external-health-monitor-controller v0.4.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.4.0) | [release-0.4](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.4) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-controller:v0.4.0
[external-health-monitor-controller v0.3.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.3.0) | [release-0.3](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.3) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-controller:v0.3.0
[external-health-monitor-controller v0.2.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.2.0) | [release-0.2](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.2) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-controller:v0.2.0

## Description

The CSI `external-health-monitor-controller` is a sidecar container that is deployed together with the CSI controller driver, similar to how the CSI `external-provisioner` sidecar is deployed. It calls the CSI controller RPC `ListVolumes` or `ControllerGetVolume` to check the health condition of the CSI volumes and report events on `PersistentVolumeClaim` if the condition of a volume is `abnormal`.

The CSI `external-health-monitor-controller` also watches for node failure events. This component can be enabled by setting the `enable-node-watcher` flag to `true`. This will only have effects on local PVs now. When a node failure event is detected, an event will be reported on the PVC to indicate that pods using this PVC are on a failed node.

## Usage

CSI drivers that support `VOLUME_CONDITION` and `LIST_VOLUMES` or `VOLUME_CONDITION` and `GET_VOLUME` controller capabilities should use this sidecar container.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md](https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md).

## Deployment

The CSI `external-health-monitor-controller` is deployed as a controller. See [https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md](https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md) for more details.
