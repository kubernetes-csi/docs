# Example

The [Hostpath CSI driver](https://github.com/kubernetes-csi/csi-driver-host-path) is a simple sample driver that provisions a directory on the host. It can be used as an example to get started writing a driver, however it is not meant for production use.
The [deployment example](https://github.com/kubernetes-csi/csi-driver-host-path#deployment) shows how to deploy and use that driver in Kubernetes.

The example deployment uses the original RBAC rule files that are maintained together with sidecar apps and deploys into the default namespace. A real production should copy the RBAC files and customize them as explained in the comments of those files.

The Hostpath CSI driver only supports the [Changed Block Tracking](./changed-block-tracking.md) feature for
PersistentVolumes with `Block` VolumeMode.
The support is not enabled by default, but requires additional configuration when deploying the driver.
When enabled, the
[external-snapshot-metadata](./external-snapshot-metadata.md)
sidecar will also be deployed, and the additional RBAC policies needed will get created.
See the [docs/example-snapshot-metadata.md](https://github.com/kubernetes-csi/csi-driver-host-path/blob/master/docs/example-snapshot-metadata.md)
document for details.

If you encounter any problems, please check the [Troubleshooting page](troubleshooting.html).
