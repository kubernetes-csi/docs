# Deploying CSI Driver on Kubernetes

This page describes to CSI driver developers how to deploy their driver onto a Kubernetes cluster.

## Overview

A CSI driver is typically deployed in Kubernetes as two components:
a controller component and a per-node component.

### Controller Plugin

The controller component can be deployed as a Deployment or StatefulSet on
any node in the cluster. It consists of the CSI driver that implements the
CSI Controller service and one or more
[sidecar containers](sidecar-containers.md). These controller
sidecar containers typically interact with Kubernetes objects and make calls
to the driver's CSI Controller service.

It generally does not need direct access to the host and can perform all its
operations through the Kubernetes API and external control plane services.
Multiple copies of the controller component can be deployed for HA, however
it is recommended to use leader election to ensure there is only one active
controller at a time.

Controller sidecars include the external-provisioner, external-attacher,
external-snapshotter, and external-resizer. Including a sidecar in the
deployment may be optional.  See each sidecar's page for more details.

#### Communication with Sidecars
[![sidecar-container](images/sidecar-container.png)](https://docs.google.com/a/greatdanedata.com/drawings/d/1JExJ_98dt0NAsJ7iI0_9loeTn2rbLeEcpOMEvKrF-9w/edit?usp=sharing)

Sidecar containers manage Kubernetes events and make the appropriate
calls to the CSI driver. The calls are made by sharing a UNIX domain socket
through an emptyDir volume between the sidecars and CSI Driver.

#### RBAC Rules

Most controller sidecars interact with Kubernetes objects and therefore need
to set RBAC policies. Each sidecar repository contains example RBAC
configurations.

### Node Plugin

The node component should be deployed on every node in the cluster through a
DaemonSet. It consists of the CSI driver that implements the CSI Node service and the
[node-driver-registrar](node-driver-registrar) sidecar container.

#### Communication with Kubelet

[![kubelet](images/kubelet.png)](https://docs.google.com/a/greatdanedata.com/drawings/d/1NXaVNDh3mSDhog7Q3Y9eELyEF24F8Z-Kk0ujR3pyOes/edit?usp=sharing)

The Kubernetes kubelet runs on every node and is responsible for making the CSI
Node service calls. These calls mount and unmount the storage volume from the
storage system, making it available to the Pod to consume. Kubelet makes calls
to the CSI driver through a UNIX domain socket shared on the host via a HostPath
volume. There is also a second UNIX domain socket that the node-driver-registrar
uses to register the CSI driver to kubelet.

#### Driver Volume Mounts
The node plugin needs direct access to the host for making block devices and/or
filesystem mounts available to the Kubernetes kubelet.

The mount point used by the CSI driver must be set to _Bidirectional_ to allow Kubelet
on the host to see mounts created by the CSI driver container. See the example below:

```yaml
      containers:
      - name: my-csi-driver
        ...
        volumeMounts:
        - name: socket-dir
          mountPath: /csi
        - name: mountpoint-dir
          mountPath: /var/lib/kubelet/pods
          mountPropagation: "Bidirectional"
      - name: node-driver-registrar
        ...
        volumeMounts:
        - name: registration-dir
          mountPath: /registration
      volumes:
      # This volume is where the socket for kubelet->driver communication is done
      - name: socket-dir
        hostPath:
          path: /var/lib/kubelet/plugins/<driver-name>
          type: DirectoryOrCreate
      # This volume is where the driver mounts volumes
      - name: mountpoint-dir
        hostPath:
          path: /var/lib/kubelet/pods
          type: Directory
      # This volume is where the node-driver-registrar registers the plugin
      # with kubelet
      - name: registration-dir
        hostPath:
          path: /var/lib/kubelet/plugins_registry
          type: Directory
```


## Deploying
Deploying a CSI driver onto Kubernetes is highlighted in detail in [_Recommended Mechanism for Deploying CSI Drivers on Kubernetes_](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/storage/container-storage-interface.md#recommended-mechanism-for-deploying-csi-drivers-on-kubernetes). 

## Enable privileged Pods

To use CSI drivers, your Kubernetes cluster must allow privileged pods (i.e. `--allow-privileged` flag must be set to `true` for both the API server and the kubelet). This is the default in some environments (e.g. GCE, GKE, `kubeadm`).

Ensure your API server are started with the privileged flag:

```shell
$ ./kube-apiserver ...  --allow-privileged=true ...
```

```shell
$ ./kubelet ...  --allow-privileged=true ...
```

> Note: Starting from Kubernetes 1.13.0, --allow-privileged is true for kubelet. It'll be deprecated in future kubernetes releases.

## Enabling mount propagation
Another feature that CSI depends on is mount propagation.  It allows the sharing of volumes mounted by one container with other containers in the same pod, or even to other pods on the same node.  For mount propagation to work, the Docker daemon for the cluster must allow shared mounts. See the [mount propagation docs][mount-propagation-docs] to find out how to enable this feature for your cluster.  [This page][docker-shared-mount] explains how to check if shared mounts are enabled and how to configure Docker for shared mounts.

### Examples

- Simple deployment example using a single pod for all components: see the [hostpath example](example.html).
- Full deployment example using a _DaemonSet_ for the node plugin and _StatefulSet_ for the controller plugin: TODO

## More information
For more information, please read [_CSI Volume Plugins in Kubernetes Design Doc_](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/storage/container-storage-interface.md).
