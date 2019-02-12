# Raw Block Volume Feature

> ## *This page is still under active development.*

**Status:** Alpha

This page documents how to implement raw block volume support to a CSI Driver.

A *block volume* is a volume that will appear as a block device inside the container.
A *mounted (file) volume* is volume that will be mounted using a specified file system and appear as a directory inside the container.

The [CSI spec](https://github.com/container-storage-interface/spec/blob/master/spec.md) supports both block and mounted (file) volumes.

While Kubernetes support of mounted (file) volumes is GA/stable, support for [block volume in Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#raw-block-volume-support) was introduced in v1.9, and promoted to beta in Kubernetes 1.13.

The Kubernetes CSI tooling support for block volumes is still alpha.

## Usage

Because this feature is still alpha it is disabled by default in Kubernetes. You must enable the feature on Kubernetes:

```
--feature-gates=BlockVolume=true,CSIBlockVolume=true...
```

## Implementing Raw Block Volume Support

* TODO: detail how to expose raw block volume support in CSI Driver.
* TODO: explain how raw block differs from mounted (file)
* TODO: answer: can a CSI driver choose to implement only raw block and not mounted (file)?
* TODO: detail the level of raw block volume functionality the CSI Sidecar containers currently provide.
* TODO: detail how Kubernetes API raw block fields get mapped to CSI methods/fields.
