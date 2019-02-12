# Ephemeral Local Volumes

> ## *This page is still under active development.*

**Status:** Alpha

Kubernetes supports three types of volumes:

1. Remote Persistent Volumes
2. Local Persistent Volumes
3. Local Ephemeral Volumes

The initial focus of Kubernetes CSI was Remote Persistent Volumes. However, the goal is for CSI to support all three types.

This page documents how to create "Local Ephemeral Volumes" for Kubernetes using CSI.

# What is a Local Ephemeral Volumes?

A Local Ephemeral Volumes is a volume whose lifecycle is tied to the lifecycle of a single pod:

* The volume is "provisioned" (either empty or with some pre-populated data) when the pod is created.
* The volume is deleted when the pod is terminated.

[Kubernetes Secret Volumes](https://kubernetes.io/docs/concepts/storage/volumes/#secret) are a good example (non-CSI) of a local ephemeral volumes.

# How to write a CSI Driver for Local Ephemeral Volumes

The following features make it easier to develop CSI Drivers that expose local ephemeral volumes:

* [Pod Info on Mount](pod-info.md)
  * This feature provides the CSI driver pod information at mount time. Many ephemeral volumes write some files at mount time. Often the data they write depends on the the pod they are operating on.
* [Skip Attach](skip-attach.md)
  * This instructs Kubernetes to skip any attach operation (`ControllerPublishVolume`) altogether. Local ephemeral volume drivers generally do not have or need a cluster control plane component.

Features currently in development to improve Local Ephemeral Volume support:

* Inline Volume Support
  * Having to create a PV and a PVC for every ephemeral volume is onerous. Being able to specify a volume inside a pod definition (not currently possible for CSI drivers) will make that easier.
