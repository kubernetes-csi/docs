# Unit Testing

The [CSI `sanity`](https://github.com/kubernetes-csi/csi-test/tree/master/pkg/sanity) package from [csi-test](https://github.com/kubernetes-csi/csi-test) can be used for unit testing your CSI driver.

It contains a set of basic tests that all CSI drivers should pass (for example, `NodePublishVolume should fail when no volume id is provided`, etc.).

This package can be used in two modes:

* Via a Golang test framework (`sanity` package is imported as a dependency)
* Via a command line against your driver binary.

Read the [documentation of the `sanity` package](https://github.com/kubernetes-csi/csi-test/blob/master/pkg/sanity/README.md) for more details.
