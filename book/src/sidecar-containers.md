# Kubernetes CSI Sidecar Containers

Kubernetes CSI Sidecar Containers are a set of standard containers that aim to simplify the development and deployment of CSI Drivers on Kubernetes.

These containers contain common logic to watch the Kubernetes API, trigger appropriate operations against the “CSI volume driver” container, and update the Kubernetes API as appropriate.

The containers are intended to be bundled with third-party CSI driver containers and deployed together as pods.

The containers are developed and maintained by the Kubernetes Storage community.

Use of the containers is strictly optional, but highly recommended.

Benefits of these sidecar containers include:

* Reduction of "boilerplate" code.
  * CSI Driver developers do not have to worry about complicated, "Kubernetes specific" code.
* Separation of concerns.
  * Code that interacts with the Kubernetes API is isolated from (and in a different container then) the code that implements the CSI interface.

The Kubernetes development team maintains the following Kubernetes CSI Sidecar Containers:

* [external-provisioner](external-provisioner.md)
* [external-attacher](external-attacher.md)
* [external-snapshotter](external-snapshotter.md)
* [external-resizer](external-resizer.md)
* [node-driver-registrar](node-driver-registrar.md)
* [cluster-driver-registrar](cluster-driver-registrar.md)
* [livenessprobe](livenessprobe.md)


## Versioning

Every sidecar has a minimum, maximum and recommended Kubernetes version.

### Minimum Version

Minimum version specifies the lowest Kubernetes version where the sidecar will
function with the most basic functionality, and no additional features added later.
Generally, this aligns with the Kubernetes version where that CSI spec version was added.

### Maximum Version

Similarly, the max Kubernetes version generally aligns with when support for
that CSI spec version was removed or if a particular Kubernetes API or feature
was deprecated and removed.

### Recommended Version

It is important to note that any new features added to the sidecars may have
dependencies on Kubernetes versions greater than the minimum Kubernetes version.
The recommended Kubernetes version specifies the lowest Kubernetes version
needed where all features of a sidecar will function correctly. Trying to use a
new sidecar feature on a Kubernetes cluster below the recommended Kubernetes
version may fail to function correctly. For that reason, it is encouraged to
stay as close to the recommended Kubernetes version as possible.

For more details on which features are supported with which Kubernetes versions
and their corresponding sidecars, please see each feature's individual page.

### Support

Kubernetes community supports CSI sidecar container versions that cover at
least one
[supported Kubernetes version](https://kubernetes.io/docs/setup/release/version-skew-policy/#supported-versions)
between their minimum and maximum versions.

### Alpha Features

It is also important to note that alpha features are subject to break or be
removed across Kubernetes and sidecar releases. There is no guarantee alpha
features will continue to function if upgrading the Kubernetes cluster or
upgrading a sidecar.
