# Troubleshooting

# Known Issues
- [[minikube-3378](https://github.com/kubernetes/minikube/issues/3378)]: Volume mount causes minikube VM to become corrupted

# Common Errors

### Node plugin pod does not start with *RunContainerError* status 

`kubectl describe pod your-nodeplugin-pod` shows:
```
failed to start container "your-driver": Error response from daemon:
linux mounts: Path /var/lib/kubelet/pods is mounted on / but it is not a shared mount
```

Your Docker host is not configured to allow shared mounts. Take a look at [this page][docker-shared-mount] for instructions to enable them.

[docker-shared-mount]: https://kubernetes.io/docs/concepts/storage/volumes/#configuration


### External attacher can't find _VolumeAttachments_

If you have a Kubernetes 1.9 cluster, not being able to list _VolumeAttachment_
and the following error are due to the lack of the
`storage.k8s.io/v1alpha1=true` runtime configuration:

```
$ kubectl logs csi-pod external-attacher
...
I0306 16:34:50.976069       1 reflector.go:240] Listing and watching *v1alpha1.VolumeAttachment from github.com/kubernetes-csi/external-attacher/vendor/k8s.io/client-go/informers/factory.go:86

E0306 16:34:50.992034       1 reflector.go:205] github.com/kubernetes-csi/external-attacher/vendor/k8s.io/client-go/informers/factory.go:86: Failed to list *v1alpha1.VolumeAttachment: the server could not find the requested resource
...
```

Please see the [Kubernetes 1.9](Kubernetes-1.9.html) page.

### Problems with the external components

The external components images are under active development. It can
happen that they become incompatible with each other. If the
 issues above above have been ruled out, [contact the sig-storage
team](https://github.com/kubernetes/community/tree/master/sig-storage) and/or
[run the e2e test](https://github.com/kubernetes/community/blob/master/contributors/devel/e2e-tests.md#local-clusters):
```
go run hack/e2e.go -- --provider=local --test --test_args="--ginkgo.focus=Feature:CSI"
```
