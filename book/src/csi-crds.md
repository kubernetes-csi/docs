# CSI CRDs

**Status:** Alpha

The Kubernetes CSI development team created a set of [Custom Resource Definitions](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#create-a-customresourcedefinition) (CRDs).

There are currently two CRDs:

* [CSIDriver Object](csi-driver-object.md)
* [CSINodeInfo Object](csi-node-info-object.md)

Definitions of the CRDs can be found [here](https://github.com/kubernetes/csi-api/tree/master/pkg/crd/manifests).

The CRDs are automatically deployed on Kubernetes via a Kubernetes Storage CRD addon https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/storage-crds. Ensure your Kubernetes Cluster deployment mechanisms (kops, etc.) enable the addon and/or installs the CRDs.

To verify the CRDs are installed, issue the following commands: `kubectl get crd`. Verify the result includes the CRDs. If deployment does not automatically install the CRD, CRDs may be manually installed via `kubectl create -f {file}.yaml` using the files [here](https://github.com/kubernetes/csi-api/tree/master/pkg/crd/manifests).

The schema definition for the custom resources (CRs) can be found here: https://github.com/kubernetes/csi-api/blob/master/pkg/apis/csi/v1alpha1/types.go

