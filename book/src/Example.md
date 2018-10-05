# Example

The
[HostPath](https://github.com/kubernetes-csi/drivers/tree/master/pkg/hostpath)
can be used to provision local storage in a single node test. This
section shows how to deploy and use that driver in Kubernetes.

## Deployment

This is tested with Kubernetes v1.12. Set the following feature gate flags to true:

```
--feature-dates=CSIPersistentVolume=true,MountPropagation=true,VolumeSnapshotDataSource=true,KubeletPluginsWatcher=true,CSINodeInfo=true,CSIDriverRegistry=true
```

`CSIPersistentVolume` is enabled by default in v1.10. `MountPropagation` is enabled by default
in v1.10. `VolumeSnapshotDataSource` is a new alpha feature in v1.12. `KubeletPluginsWatcher`
is enabled by default in v1.12. `CSINodeInfo` and `CSIDriverRegistry` are new alpha features
in v1.12.

CRDs needs to be created manually for `CSIDriverRegistry` and `CSINodeInfo`.

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/testdata/csidriver.yaml --validate=false
customresourcedefinition.apiextensions.k8s.io/csidrivers.csi.storage.k8s.io created

$ kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/testdata/csinodeinfo.yaml --validate=false
customresourcedefinition.apiextensions.k8s.io/csinodeinfos.csi.storage.k8s.io created
```

### Create RBAC rules for CSI provisioner

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/rbac/csi-provisioner-rbac.yaml
serviceaccount/csi-provisioner created
clusterrole.rbac.authorization.k8s.io/external-provisioner-runner created
clusterrolebinding.rbac.authorization.k8s.io/csi-provisioner-role created
```

```yaml
{{#include example/rbac/csi-provisioner-rbac.yaml}}
```

### Create RBAC rules for CSI attacher

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/rbac/csi-attacher-rbac.yaml
serviceaccount/csi-attacher created
clusterrole.rbac.authorization.k8s.io/external-attacher-runner created
clusterrolebinding.rbac.authorization.k8s.io/csi-attacher-role created
```

```yaml
{{#include example/rbac/csi-attacher-rbac.yaml}}
```

### Create RBAC rules for node plugin

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/rbac/csi-nodeplugin-rbac.yaml
serviceaccount/csi-nodeplugin created
clusterrole.rbac.authorization.k8s.io/csi-nodeplugin created
clusterrolebinding.rbac.authorization.k8s.io/csi-nodeplugin created
```

```yaml
{{#include example/rbac/csi-nodeplugin-rbac.yaml}}
```

### Create RBAC rules for CSI snapshotter

The CSI snapshotter is an optional sidecar container. You only need to create these
RBAC rules if you want to test the snapshot feature.

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/snapshot/csi-snapshotter-rbac.yaml
serviceaccount/csi-snapshotter created
clusterrole.rbac.authorization.k8s.io/external-snapshotter-runner created
clusterrolebinding.rbac.authorization.k8s.io/csi-snapshotter-role created
```

```yaml
{{#include example/snapshot/csi-snapshotter-rbac.yaml}}
```

### Deploy CSI provisioner in StatefulSet pod

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/hostpath/csi-hostpath-provisioner.yaml
service/csi-hostpath-provisioner created
statefulset.apps/csi-hostpath-provisioner created

$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
csi-hostpath-provisioner-0   1/1     Running   0          6s
```

```yaml
{{#include example/hostpath/csi-hostpath-provisioner.yaml}}
```

### Deploy CSI attacher in StatefulSet pod

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/hostpath/csi-hostpath-attacher.yaml
service/csi-hostpath-attacher created
statefulset.apps/csi-hostpath-attacher created

$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
csi-hostpath-attacher-0      1/1     Running   0          4s
csi-hostpath-provisioner-0   1/1     Running   0          2m1s
```

```yaml
{{#include example/hostpath/csi-hostpath-attacher.yaml}}
```

### Deploy driver-registrar and hostpath CSI plugin in DaemonSet pod

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/hostpath/csi-hostpathplugin.yaml
daemonset.apps/csi-hostpathplugin created

$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
csi-hostpath-attacher-0      1/1     Running   0          53s
csi-hostpath-provisioner-0   1/1     Running   0          2m50s
csi-hostpathplugin-9rp7c     2/2     Running   0          5s
```

```yaml
{{#include example/hostpath/csi-hostpathplugin.yaml}}
```

### Deploy CSI snapshotter in StatefulSet pod

The CSI snapshotter is an optional sidecar container. You only need to deploy it if you
want to test the snapshot feature.

```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/snapshot/csi-hostpath-snapshotter.yaml
service/csi-hostpath-snapshotter created
statefulset.apps/csi-hostpath-snapshotter created

$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
csi-hostpath-attacher-0      1/1     Running   0          96s
csi-hostpath-provisioner-0   1/1     Running   0          3m33s
csi-hostpath-snapshotter-0   1/1     Running   0          5s
csi-hostpathplugin-9rp7c     2/2     Running   0          48s
```

```yaml
{{#include example/snapshot/csi-hostpath-snapshotter.yaml}}
```

## Usage

Dynamic provisioning is enabled by creating a `csi-hostpath-sc` storage class.
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/usage/csi-storageclass.yaml
storageclass.storage.k8s.io/csi-hostpath-sc created
```

```yaml
{{#include example/usage/csi-storageclass.yaml}}
```

We can use this storage class to create and claim a new volume:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/usage/csi-pvc.yaml
persistentvolumeclaim/csi-pvc created
$ kubectl get pvc
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
csi-pvc   Bound    pvc-0571cc14-c714-11e8-8911-000c2967769a   1Gi        RWO            csi-hostpath-sc   3s

$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS      REASON   AGE
pvc-0571cc14-c714-11e8-8911-000c2967769a   1Gi        RWO            Delete           Bound    default/csi-pvc   csi-hostpath-sc            3s
```

```yaml
{{#include example/usage/csi-pvc.yaml}}
```

The HostPath driver is configured to create new volumes under `/tmp` inside
the `hostpath` container in the CSI hostpath plugin DaemonSet pod and thus
persist as long as the DaemonSet pod itself.
We can use such volumes in another pod like this:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/usage/csi-app.yaml
pod/my-csi-app created
$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
csi-hostpath-attacher-0      1/1     Running   0          17m
csi-hostpath-provisioner-0   1/1     Running   0          19m
csi-hostpath-snapshotter-0   1/1     Running   0          16m
csi-hostpathplugin-9rp7c     2/2     Running   0          16m
my-csi-app                   1/1     Running   0          5s

$ kubectl describe pods/my-csi-app
Name:               my-csi-app
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               127.0.0.1/127.0.0.1
Start Time:         Wed, 03 Oct 2018 06:59:19 -0700
Labels:             <none>
Annotations:        <none>
Status:             Running
IP:                 172.17.0.5
Containers:
  my-frontend:
    Container ID:  docker://fd2950af39a155bdf08d1da341cfb23aa0d1af3eaaad6950a946355789606e8c
    Image:         busybox
    Image ID:      docker-pullable://busybox@sha256:2a03a6059f21e150ae84b0973863609494aad70f0a80eaeb64bddd8d92465812
    Port:          <none>
    Host Port:     <none>
    Command:
      sleep
      1000000
    State:          Running
      Started:      Wed, 03 Oct 2018 06:59:22 -0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /data from my-csi-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-xms2g (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  my-csi-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  csi-pvc
    ReadOnly:   false
  default-token-xms2g:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-xms2g
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason                  Age   From                     Message
  ----    ------                  ----  ----                     -------
  Normal  Scheduled               69s   default-scheduler        Successfully assigned default/my-csi-app to 127.0.0.1
  Normal  SuccessfulAttachVolume  69s   attachdetach-controller  AttachVolume.Attach succeeded for volume "pvc-0571cc14-c714-11e8-8911-000c2967769a"
  Normal  Pulling                 67s   kubelet, 127.0.0.1       pulling image "busybox"
  Normal  Pulled                  67s   kubelet, 127.0.0.1       Successfully pulled image "busybox"
  Normal  Created                 67s   kubelet, 127.0.0.1       Created container
  Normal  Started                 66s   kubelet, 127.0.0.1       Started container
```

```
{{#include example/usage/csi-app.yaml}}
```

## Confirming the setup

Writing inside the app container should be visible in `/tmp` of the `hostpath` container:
```
$ kubectl exec -it my-csi-app /bin/sh
/ # touch /data/hello-world
/ # exit

$ kubectl exec -it $(kubectl get pods --selector app=csi-hostpathplugin -o jsonpath='{.items[*].metadata.name}') -c hostpath /bin/sh
/ # find / -name hello-world
/tmp/057485ab-c714-11e8-bb16-000c2967769a/hello-world
/ # exit
```

There should be a `VolumeAttachment` while the app has the volume mounted:
```
$ kubectl get VolumeAttachment
Name:         csi-a4e97f3af2161c6d081b8e96c58ed00c9bf1e1745e89b2545e24505437f015df
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  storage.k8s.io/v1beta1
Kind:         VolumeAttachment
Metadata:
  Creation Timestamp:  2018-10-03T13:59:19Z
  Resource Version:    1730
  Self Link:           /apis/storage.k8s.io/v1beta1/volumeattachments/csi-a4e97f3af2161c6d081b8e96c58ed00c9bf1e1745e89b2545e24505437f015df
  UID:                 862d7241-c714-11e8-8911-000c2967769a
Spec:
  Attacher:   csi-hostpath
  Node Name:  127.0.0.1
  Source:
    Persistent Volume Name:  pvc-0571cc14-c714-11e8-8911-000c2967769a
Status:
  Attached:  true
Events:      <none>
```

## Snapshot support

Enable dynamic provisioning of volume snapshot by creating a volume snapshot
class as follows:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/snapshot/csi-snapshotclass.yaml
volumesnapshotclass.snapshot.storage.k8s.io/csi-hostpath-snapclass created
$ kubectl get volumesnapshotclass
NAME                     AGE
csi-hostpath-snapclass   11s
$ kubectl describe volumesnapshotclass
Name:         csi-hostpath-snapclass
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  snapshot.storage.k8s.io/v1alpha1
Kind:         VolumeSnapshotClass
Metadata:
  Creation Timestamp:  2018-10-03T14:15:30Z
  Generation:          1
  Resource Version:    2418
  Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/volumesnapshotclasses/csi-hostpath-snapclass
  UID:                 c8f5bc47-c716-11e8-8911-000c2967769a
Snapshotter:           csi-hostpath
Events:                <none>
```

```yaml
{{#include example/snapshot/csi-snapshotclass.yaml}}
```

Use the volume snapshot class to dynamically create a volume snapshot:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/snapshot/csi-snapshot.yaml
volumesnapshot.snapshot.storage.k8s.io/new-snapshot-demo created

$ kubectl get volumesnapshot
NAME                AGE
new-snapshot-demo   12s

$ kubectl get volumesnapshotcontent
NAME                                               AGE
snapcontent-f55db632-c716-11e8-8911-000c2967769a   14s

$ kubectl describe volumesnapshot
Name:         new-snapshot-demo
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  snapshot.storage.k8s.io/v1alpha1
Kind:         VolumeSnapshot
Metadata:
  Creation Timestamp:  2018-10-03T14:16:45Z
  Generation:          1
  Resource Version:    2476
  Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/namespaces/default/volumesnapshots/new-snapshot-demo
  UID:                 f55db632-c716-11e8-8911-000c2967769a
Spec:
  Snapshot Class Name:    csi-hostpath-snapclass
  Snapshot Content Name:  snapcontent-f55db632-c716-11e8-8911-000c2967769a
  Source:
    Kind:  PersistentVolumeClaim
    Name:  csi-pvc
Status:
  Creation Time:  2018-10-03T14:16:45Z
  Ready:          true
  Restore Size:   1Gi
Events:           <none>

$ kubectl describe volumesnapshotcontent
Name:         snapcontent-f55db632-c716-11e8-8911-000c2967769a
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  snapshot.storage.k8s.io/v1alpha1
Kind:         VolumeSnapshotContent
Metadata:
  Creation Timestamp:  2018-10-03T14:16:45Z
  Generation:          1
  Resource Version:    2474
  Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/volumesnapshotcontents/snapcontent-f55db632-c716-11e8-8911-000c2967769a
  UID:                 f561411f-c716-11e8-8911-000c2967769a
Spec:
  Csi Volume Snapshot Source:
    Creation Time:    1538576205471577525
    Driver:           csi-hostpath
    Restore Size:     1073741824
    Snapshot Handle:  f55ff979-c716-11e8-bb16-000c2967769a
  Persistent Volume Ref:
    API Version:        v1
    Kind:               PersistentVolume
    Name:               pvc-0571cc14-c714-11e8-8911-000c2967769a
    Resource Version:   1573
    UID:                0575b966-c714-11e8-8911-000c2967769a
  Snapshot Class Name:  csi-hostpath-snapclass
  Volume Snapshot Ref:
    API Version:       snapshot.storage.k8s.io/v1alpha1
    Kind:              VolumeSnapshot
    Name:              new-snapshot-demo
    Namespace:         default
    Resource Version:  2472
    UID:               f55db632-c716-11e8-8911-000c2967769a
Events:                <none>
```

```yaml
{{#include example/snapshot/csi-snapshot.yaml}}
```

## Restore volume from snapshot support

Follow the following example to create a volume from a volume snapshot:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/snapshot/csi-restore.yaml
persistentvolumeclaim/hpvc-restore created
$ kubectl get pvc
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
csi-pvc        Bound    pvc-0571cc14-c714-11e8-8911-000c2967769a   1Gi        RWO            csi-hostpath-sc   24m
hpvc-restore   Bound    pvc-77324684-c717-11e8-8911-000c2967769a   1Gi        RWO            csi-hostpath-sc   6s
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS      REASON   AGE
pvc-0571cc14-c714-11e8-8911-000c2967769a   1Gi        RWO            Delete           Bound    default/csi-pvc        csi-hostpath-sc            25m
pvc-77324684-c717-11e8-8911-000c2967769a   1Gi        RWO            Delete           Bound    default/hpvc-restore   csi-hostpath-sc            33s
```

```yaml
{{#include example/snapshot/csi-restore.yaml}}

If you encounter any problems, please check the [Troubleshooting page](Troubleshooting.html).
