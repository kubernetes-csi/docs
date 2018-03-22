# Troubleshooting

### Node plugin pod does not start with *RunContainerError* status 

`kubectl describe pod your-nodeplugin-pod` shows:
```
failed to start container "your-driver": Error response from daemon:
linux mounts: Path /var/lib/kubelet/pods is mounted on / but it is not a shared mount
```

Your Docker host is not configured to allow shared mounts. Take a look at [this page][docker-shared-mount] for instructions to enable them.

[docker-shared-mount]: https://docs.portworx.com/knowledgebase/shared-mount-propogation.html
