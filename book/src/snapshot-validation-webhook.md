# Snapshot Validation Webhook

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/external-snapshotter](https://github.com/kubernetes-csi/external-snapshotter)

**Status:** GA as of 4.0.0

There is a new validating webhook server which provides tightened validation on snapshot objects. This SHOULD be installed by the Kubernetes distros along with the snapshot-controller, not end users. It SHOULD be installed in all Kubernetes clusters that has the snapshot feature enabled.

### Supported Versions

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version)
--|--|--|--|--|--|--|--
[external-snapshotter v8.1.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v8.1.0) | [release-8.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-8.1) | [v1.11.0](https://github.com/container-storage-interface/spec/releases/tag/v1.11.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.1.0 | v1.25 | - | v1.25
[external-snapshotter v8.0.2](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v8.0.2) | [release-8.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-8.0) | [v1.9.0](https://github.com/container-storage-interface/spec/releases/tag/v1.9.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v8.0.2 | v1.25 | - | v1.25




### Unsupported Versions
<details>

<summary>List of previous versions</summary>

Latest stable release | Branch | Min CSI Version | Max CSI Version | Container Image | [Min K8s Version](project-policies.md#minimum-version) | [Max K8s Version](project-policies.md#maximum-version) | [Recommended K8s Version](project-policies.md#recommended-version)
 --|--|--|--|--|--|--|--
[external-snapshotter v6.3.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.3.0) | [release-6.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.3) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/napshot-validation-webhook:v6.2.1 | v1.20 | - | v1.24
[external-snapshotter v6.2.2](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.2.2) | [release-6.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/napshot-validation-webhook:v6.2.1 | v1.20 | - | v1.24
[external-snapshotter v6.1.0](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.1.0) | [release-6.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/napshot-validation-webhookr:v6.1.0 | v1.20 | - | v1.24
[snapshot-validation-webhook v6.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v6.0.1) | [release-6.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-6.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v6.0.1 | v1.20 | - | v1.24
[snapshot-validation-webhook v5.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v5.0.1) | [release-5.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-5.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v5.0.1 | v1.20 | - | v1.22
[snapshot-validation-webhook v4.2.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.2.1) | [release-4.2](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.2) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v4.2.1 | v1.20 | - | v1.22
[snapshot-validation-webhook v4.1.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.1.1) | [release-4.1](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.1) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v4.1.0 | v1.20 | - | v1.20
[snapshot-validation-webhook v4.0.1](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v4.0.1) | [release-4.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-4.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v4.0.1 | v1.20 | - | v1.20
[snapshot-validation-webhook v3.0.3](https://github.com/kubernetes-csi/external-snapshotter/releases/tag/v3.0.3) | [release-3.0](https://github.com/kubernetes-csi/external-snapshotter/tree/release-3.0) | [v1.0.0](https://github.com/container-storage-interface/spec/releases/tag/v1.0.0) | - | registry.k8s.io/sig-storage/snapshot-validation-webhook:v3.0.3 | v1.17 | - | v1.17

</details>

## Description

The snapshot validating webhook is an HTTP callback which responds to [admission requests](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/). It is part of a larger [plan](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1900-volume-snapshot-validation-webhook) to tighten validation for volume snapshot objects. This webhook introduces the [ratcheting validation](https://github.com/kubernetes/enhancements/tree/master/keps/sig-storage/1900-volume-snapshot-validation-webhook#backwards-compatibility) mechanism targeting the tighter validation. The cluster admin or Kubernetes distribution admin should install the webhook alongside the snapshot controllers and CRDs.

> :warning: **WARNING**: Cluster admins choosing not to install the webhook server and participate in the phased release process can cause future problems when upgrading from `v1beta1` to `v1` volumesnapshot API, if there are currently persisted objects which fail the new stricter validation. Potential impacts include being unable to delete invalid snapshot objects.

## Deployment

Kubernetes distributors should bundle and deploy the snapshot validation webhook along with the snapshot controller and CRDs as part of their Kubernetes cluster management process (independent of any CSI Driver).

Read more about how to install the example webhook [here](https://github.com/kubernetes-csi/external-snapshotter/tree/master/deploy/kubernetes/webhook-example).
