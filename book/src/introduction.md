# Introduction

## Kubernetes Container Storage Interface (CSI) Documentation

This site documents how to develop, deploy, and test a [Container Storage Interface](https://github.com/container-storage-interface/spec/blob/master/spec.md) (CSI) driver on Kubernetes.

The [Container Storage Interface](https://github.com/container-storage-interface/spec/blob/master/spec.md) (CSI) is a standard for exposing arbitrary block and file storage systems to containerized workloads on Container Orchestration Systems (COs) like Kubernetes. Using CSI third-party storage providers can write and deploy plugins exposing new storage systems in Kubernetes without ever having to touch the core Kubernetes code.

The target audience for this site is third-party developers interested in developing CSI drivers for Kubernetes.

Kubernetes users interested in how to deploy or manage an existing CSI driver on Kubernetes should look at the documentation provided by the author of the CSI driver.

Kubernetes users interested in how to use a CSI driver should look at [kubernetes.io documentation](https://kubernetes.io/docs/concepts/storage/volumes/#csi).

## Kubernetes Releases
| Kubernetes | CSI Spec Compatibility                                                                                                                                               | Status |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| v1.9       | [v0.1.0](https://github.com/container-storage-interface/spec/releases/tag/v0.1.0)                                                                                    | Alpha  |
| v1.10      | [v0.2.0](https://github.com/container-storage-interface/spec/releases/tag/v0.2.0)                                                                                    | Beta   |
| v1.11      | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0)                                                                                    | Beta   |
| v1.13      | [v0.3.0](https://github.com/container-storage-interface/spec/releases/tag/v0.3.0), [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | GA     |

## Development and Deployment

### Minimum Requirements (for Developing and Deploying a CSI driver for Kubernetes)

Kubernetes is as minimally prescriptive about packaging and deployment of a CSI Volume Driver as possible.

The only requirements are around how Kubernetes (master and node) components find and communicate with a CSI driver.

Specifically, the following is dictated by Kubernetes regarding CSI:

* Kubelet to CSI Driver Communication
  * Kubelet directly issues CSI calls (like `NodeStageVolume`, `NodePublishVolume`, etc.) to CSI drivers via a Unix Domain Socket to mount and unmount volumes.
  * Kubelet discovers CSI drivers (and the Unix Domain Socket to use to interact with a CSI driver) via the [kubelet plugin registration mechanism](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/device-plugins/#device-plugin-registration).
  * Therefore, all CSI drivers deployed on Kubernetes MUST register themselves using the kubelet plugin registration mechanism on each supported node.
* Master to CSI Driver Communication
  * Kubernetes master components do not communicate directly (via a Unix Domain Socket or otherwise) with CSI drivers.
  * Kubernetes master components interact only with the Kubernetes API.
  * Therefore, CSI drivers that require operations that depend on the Kubernetes API (like volume create, volume attach, volume snapshot, etc.) MUST watch the Kubernetes API and trigger the appropriate CSI operations against it.

Because these requirements are minimally prescriptive, CSI driver developers are free to implement and deploy their drivers as they see fit.

_That said, to ease development and deployment, the mechanism described below is recommended._

## Recommended Mechanism (for Developing and Deploying a CSI driver for Kubernetes)

The Kubernetes development team has established a "Recommended Mechanism" for developing, deploying, and testing CSI Drivers on Kubernetes.
It aims to reduce boilerplate code and  simplify the overall process for CSI Driver developers.

This "Recommended Mechanism" makes use of the following components:

* Kubernetes CSI [Sidecar Containers](sidecar-containers.md)
* Kubernetes CSI [objects](csi-objects.md)
* CSI [Driver Testing](testing-drivers.md) tools

To implement a CSI driver using this mechanism, a CSI driver developer should:

1. Create a containerized application implementing the _Identity_, _Node_, and optionally the _Controller_ services described in the [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md#rpc-interface)  (the CSI driver container).
    * See [Developing CSI Driver](developing.md) for more information.
2. Unit test it using csi-sanity.
    * See [Driver - Unit Testing](unit-testing.md) for more information.
3. Define Kubernetes API YAML files that deploy the CSI driver container along with appropriate sidecar containers.
    * See [Deploying in Kubernetes](deploying.md) for more information.
4. Deploy the driver on a Kubernetes cluster and run end-to-end functional tests on it.
    * See [Driver - Functional Testing](functional-testing.md)

## Reference Links

* [Design Doc](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/storage/container-storage-interface.md)
