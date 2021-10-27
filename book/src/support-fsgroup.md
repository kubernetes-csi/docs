# CSI Driver fsGroup Support

# Status

Status | Min K8s Version | Max K8s Version 
--|--|--
Alpha | 1.19 | 1.19
Beta | 1.20 | 1.22
GA | 1.23 | -

# Overview

CSI Drivers can indicate whether or not they support modifying a volume's ownership or permissions when the volume is being mounted. This can be useful if the CSI Driver does not support the operation, or wishes to re-use volumes with constantly changing permissions.

> See the [design document](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1682-csi-driver-skip-permission) for further information.

# Example Usage
When creating the CSI Driver object, `fsGroupPolicy` is defined in the driver's spec. The following shows the hostpath driver with `None` included, indicating that the volumes should not be modified when mounted:

```yaml
apiVersion: storage.k8s.io/v1
kind: CSIDriver
metadata:
  name: hostpath.csi.k8s.io
spec:
  # Supports persistent and ephemeral inline volumes.
  volumeLifecycleModes:
  - Persistent
  - Ephemeral
  # To determine at runtime which mode a volume uses, pod info and its
  # "csi.storage.k8s.io/ephemeral" entry are needed.
  podInfoOnMount: true
  fsGroupPolicy: None
```

## Supported Modes

  * The following modes are supported:
    * `None`: Indicates that volumes will be mounted with no modifications, as the CSI volume driver does not support these operations.
    * `File`: Indicates that the CSI volume driver supports volume ownership and permission change via fsGroup, and Kubernetes may use fsGroup to change permissions and ownership of the volume to match user requested fsGroup in the pod's SecurityPolicy regardless of fstype or access mode.
    * `ReadWriteOnceWithFSType`: Indicates that volumes will be examined to determine if volume ownership and permissions should be modified to match the pod's security policy. 
      Changes will only occur if the `fsType` is defined and the persistent volume's `accessModes` contains `ReadWriteOnce`. .

If undefined, `fsGroupPolicy` will default to `ReadWriteOnceWithFSType`, keeping the previous behavior.

## Feature Gates
To use this field, Kubernetes 1.19 binaries must start with the `CSIVolumeFSGroupPolicy` feature gate enabled:
```
--feature-gates=CSIVolumeFSGroupPolicy=true
```
This is enabled by default on 1.20 and higher.
