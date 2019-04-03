# Example

The [Hostpath CSI driver](https://github.com/kubernetes-csi/csi-driver-host-path) is a simple sample driver that provisions a directory on the host. It can be used as an example to get started writing a driver, however it is not meant for production use.
The [deployment example](https://github.com/kubernetes-csi/csi-driver-host-path#deployment) shows how to deploy and use that driver in Kubernetes.

The example deployment uses the original RBAC rule files that are maintained together with sidecar apps and deploys into the default namespace. A real production should copy the RBAC files and customize them as explained in the comments of those files.

If you encounter any problems, please check the [Troubleshooting page](troubleshooting.html).
