# Setup
This page shows the user how to setup their Kubernetes cluster enable support for CSI drivers.

## Cluster Requirements
Kubernetes v1.9 must be setup to support the new technologies required to enable CSI integration. To enable this new technology please setup the following flags:

* API Server binary:

```
--allow-privileged=true
--feature-gates=CSIPersistentVolume=true,MountPropagation=true
--runtime-config=storage.k8s.io/v1alpha1=true
```

* Controller-manager binary

```
--feature-gates=CSIPersistentVolume=true
```

* Kubelet

```
--allow-privileged=true
--feature-gates=CSIPersistentVolume=true,MountPropagation=true
```

### Developers

If you are a developer and are using the script `cluster/kube-up.sh` from the Kubernetes repo, then you can set values using the following environment variables:

```
export KUBE_RUNTIME_CONFIG="storage.k8s.io/v1alpha1=true"
export KUBE_FEATURE_GATES="MountPropagation=true,CSIPersistentVolume=true"
```

When using the script `hack/local-up-cluster.sh`, set the same variables without the `KUBE_` prefix:

```
export RUNTIME_CONFIG="storage.k8s.io/v1alpha1=true"
export FEATURE_GATES="MountPropagation=true,CSIPersistentVolume=true"
```

### Confirming the setup

Once the system is up, to confirm if the runtime config has taken effect, the following command should return that there are no resources and not return an error:

```bash
$ kubectl get volumeattachments
```

To confirm that the feature gate has taken effect, submit the following fake PersistentVolume specification. If it is accepted, then we can confirm that the feature gate has been set correctly, and you may go ahead and delete it:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
    name: fakepv
spec:
    capacity:
        storage: 1Gi
    accessModes:
        - ReadWriteMany
    csi:
        driver: fake
        volumeHandle: "1"
        readOnly: false
```
