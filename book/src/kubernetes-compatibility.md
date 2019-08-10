# Kubernetes and CSI Sidecar Compatibility

Every version of a sidecar has a minimum, maximum and recommended Kubernetes version
that it is compatible with.

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

### Alpha Features

It is also important to note that alpha features are subject to break or be
removed across Kubernetes and sidecar releases. There is no guarantee alpha
features will continue to function if upgrading the Kubernetes cluster or
upgrading a sidecar.
