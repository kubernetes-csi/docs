# CSI external-health-monitor-agent

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-health-monitor](https://github.com/kubernetes-csi/external-health-monitor)

**Status:** Deprecated

### Unsupported Versions
Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image
--|--|--|--|--
[external-health-monitor-agent v0.2.0](https://github.com/kubernetes-csi/external-health-monitor/releases/tag/v0.2.0) | [release-0.2](https://github.com/kubernetes-csi/external-health-monitor/tree/release-0.2) | [v1.3.0](https://github.com/container-storage-interface/spec/releases/tag/v1.3.0) | - | registry.k8s.io/sig-storage/csi-external-health-monitor-agent:v0.2.0

## Description

*Note*: This sidecar has been deprecated and replaced with the CSIVolumeHealth feature
in Kubernetes.

The CSI `external-health-monitor-agent` is a sidecar container that is deployed together with the CSI node driver, similar to how the CSI `node-driver-registrar` sidecar is deployed. It calls the CSI node RPC `NodeGetVolumeStats` to check the health condition of the CSI volumes and report events on `Pod` if the condition of a volume is `abnormal`.

## Usage

CSI drivers that support `VOLUME_CONDITION` and `NODE_GET_VOLUME_STATS` node capabilities should use this sidecar container.

For detailed information (binary parameters, RBAC rules, etc.), see [https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md](https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md).

## Deployment

The CSI `external-health-monitor-agent` is deployed as a DaemonSet. See [https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md](https://github.com/kubernetes-csi/external-health-monitor/blob/master/README.md) for more details.
