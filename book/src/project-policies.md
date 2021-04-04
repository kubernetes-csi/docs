# Versioning, Support, and Kubernetes Compatibility

## Versioning

Each Kubernetes CSI component version is expressed as *x.y.z*, where *x* is the
major version, *y* is the minor version, and *z* is the patch version,
following [Semantic Versioning](https://semver.org/).

Patch version releases only contain bug fixes that do not break any backwards
compatibility.

Minor version releases may contain new functionality that do not
break any backwards compatibility (except for alpha features).

Major version releases may contain new functionality or fixes that may break
backwards compatibility with previous major releases. Changes that require a
major version increase include: removing or changing API, flags, or behavior, new
RBAC requirements that are not opt-in, new Kubernetes minimum version
requirements.

A litmus test for not breaking compatibility is to replace the image of a
component in an existing deployment without changing that deployment in any
other way.

To minimize the number of branches we need to support, we do not have a general
policy for releasing new minor versions on older majors. We will make exceptions
for work related to meeting production readiness requirements. Only the previous
major version will be eligible for these exceptions, so long as the time between
the previous major version and the current major version is under six months.
For example, if "X.0.0" and "X+1.0.0" were released under six months apart,
"X.0.0" would be eligible for new minor releases.

## Support

The Kubernetes CSI project follows the broader Kubernetes project on support.
Every minor release branch will be supported with patch releases on an as-needed
basis for at least 1 year,
starting with the first release of that minor version. In addition, the minor
release branch will be supported for at least 3 months after the next minor
version is released, to allow time to integrate with the latest release.

### Alpha Features

Alpha features are subject to break or be
removed across Kubernetes and CSI component releases. There is no guarantee alpha
features will continue to function if upgrading the Kubernetes cluster or
upgrading a CSI sidecar or controller.

## Kubernetes Compatibility

Each release of a CSI component has a minimum, maximum and recommended Kubernetes version
that it is compatible with.

### Minimum Version

Minimum version specifies the lowest Kubernetes version where the component will
function with the most basic functionality, and no additional features added later.
Generally, this aligns with the Kubernetes version where that CSI spec version was added.

### Maximum Version

The maximum Kubernetes version specifies the last working Kubernetes version for
all beta and GA features that the component supports. This generally aligns with one
Kubernetes release before support for the CSI spec version was removed or if a particular
Kubernetes API or feature was removed.

### Recommended Version

Note that any new features added may have
dependencies on Kubernetes versions greater than the minimum Kubernetes version.
The recommended Kubernetes version specifies the lowest Kubernetes version
needed where all its supported features will function correctly. Trying to use a
new sidecar feature on a Kubernetes cluster below the recommended Kubernetes
version may fail to function correctly. For that reason, it is encouraged to
stay as close to the recommended Kubernetes version as possible.

For more details on which features are supported with which Kubernetes versions
and their corresponding CSI components, please see each feature's individual page.
