# Kubernetes Cluster Controllers

The Kubernetes cluster controllers are responsible for managing snapshot objects and operations across multiple CSI drivers, so they should be bundled and deployed by the Kubernetes distributors as part of their Kubernetes cluster management process (independent of any CSI Driver).

The Kubernetes development team maintains the following Kubernetes cluster controllers:

* [snapshot-controller](snapshot-controller.md)
