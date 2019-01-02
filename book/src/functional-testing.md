# Functional Testing

Some functional testing of your CSI driver can be done via the CLI mode of the [CSI `sanity`](https://github.com/kubernetes-csi/csi-test/tree/master/pkg/sanity) package.

Drivers should also be functionally "end-to-end" tested while deployed in a Kubernetes cluster. Currently how to do this and what tests to run is left up to driver authors. In the future, a project (currently in development) aims to enable use of a pre-built `kubernetes/e2e/e2e.test` binary containing a standard set of Kubernetes CSI end-to-end tests to be imported and run by third party CSI drivers. This documentation will be updated with more information once that is ready to use.

The CSI community is also looking in to establishing an official "CSI Conformance Suite" to recognize "officially certified CSI drivers".  This documentation will be updated with more information once that process has been defined.
