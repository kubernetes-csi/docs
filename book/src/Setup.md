# Setup

To use CSI drivers, your Kubernetes cluster must allow privileged pods (i.e. `--allow-privileged` flag must be set to `true` for both the API server and the kubelet). This is the default in some environments (e.g. GCE, GKE, `kubeadm`).

Moreover, as stated in the [mount propagation docs][mount-propagation-docs], the Docker daemon of the cluster nodes must allow shared mounts. [This page][docker-shared-mount] explains how to check if shared mounts are enabled and how to configure Docker for shared mounts.

This document has been updated to the latest version of Kubernetes v1.11.

## Alpha Features

* [CSI Raw block volume support][rawvol]: To enable support for raw block volumes
you mest set the following feature gate on Kubernetes v1.11:

```
--feature-gates=BlockVolume=true,CSIBlockVolume=true
```

Also, see [Raw Block Volume Support][rawsupport]

* [Kubelet Plugin Watcher][plugin-watcher]: To enable support for Kubelet plugin
watcher for CSI plugins:

```
--feature-gates=KubeletPluginsWatcher=true
```

You will also need to use the following flag in your `driver-registrar` side-car
container with the value set to the location of kubekel plugin watcher socket:

```
--kubelet-registration-path: Enables Kubelet Plugin Registration service, and returns
  the specified path as "endpoint" in "PluginInfo" response. If this option is set, the
  driver-registrar expose a unix domain socket to handle Kubelet Plugin Registration,
  this socket MUST be surfaced on the host in the kubelet plugin registration director
  (in addition to the CSI driver socket). If plugin registration is enabled on kubelet
  (kubelet flag KubeletPluginsWatcher is set), then this option should be set and the
  value should be the path of the CSI driver socket on the host machine.
```

## Archives

Please visit the [Archives](Archive.html) for setup instructions on previous versions of Kubernetes.

[mount-propagation-docs]: https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
[docker-shared-mount]: https://docs.portworx.com/knowledgebase/shared-mount-propogation.html
[rawvol]: https://kubernetes.io/docs/concepts/storage/volumes/#csi-raw-block-volume-support
[rawsupport]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#raw-block-volume-support
[plugin-watcher]: https://docs.google.com/document/d/1dtHpGY-gPe9sY7zzMGnm8Ywo09zJfNH-E1KEALFV39s/edit#heading=h.7fe6spexljh6