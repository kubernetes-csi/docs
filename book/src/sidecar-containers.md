# Kubernetes CSI Sidecar Containers

Kubernetes CSI Sidecar Containers are a set of standard containers that aim to
simplify the development and deployment of CSI Drivers on Kubernetes.

These containers contain common logic to watch the Kubernetes API, trigger
appropriate operations against the “CSI volume driver” container, and update the
Kubernetes API as appropriate.

The containers are intended to be bundled with third-party CSI driver containers and deployed together as pods.

The containers are developed and maintained by the Kubernetes Storage community.

Use of the containers is strictly optional, but highly recommended.

Benefits of these sidecar containers include:

* Reduction of "boilerplate" code.
  * CSI Driver developers do not have to worry about complicated, "Kubernetes specific" code.
* Separation of concerns.
  * Code that interacts with the Kubernetes API is isolated from (and in a different container than) the code that implements the CSI interface.

The Kubernetes development team maintains the following Kubernetes CSI Sidecar Containers:

* [external-provisioner](external-provisioner.md)
* [external-attacher](external-attacher.md)
* [external-snapshotter](external-snapshotter.md)
* [external-resizer](external-resizer.md)
* [node-driver-registrar](node-driver-registrar.md)
* [cluster-driver-registrar](cluster-driver-registrar.md) (deprecated)
* [livenessprobe](livenessprobe.md)
