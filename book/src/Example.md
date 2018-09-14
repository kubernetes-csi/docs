# Example

The
[HostPath](https://github.com/kubernetes-csi/drivers/tree/master/pkg/hostpath)
can be used to provision local storage in a single node test. This
section shows how to deploy and use that driver in Kubernetes.

## Deployment

The following .yaml file will deploy a `csi-pod` with the HostPath CSI driver and the
[sidecar containers](CSI-Kubernetes.html#sidecar-containers) which integrate the driver into Kubernetes.
Use it with a cluster that is [set up for CSI](Setup.html), either by copying it into a local file or
by referencing the latest version directly:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/csi-setup.yaml
storageclass.storage.k8s.io "csi-hostpath-sc" created
serviceaccount "csi-service-account" created
clusterrole.rbac.authorization.k8s.io "csi-cluster-role" created
clusterrolebinding.rbac.authorization.k8s.io "csi-role-binding" created
pod "csi-pod" created
$ kubectl get pods
NAME      READY     STATUS    RESTARTS   AGE
csi-pod   5/5       Running   0          24s
```

```yaml
{{#include example/csi-setup.yaml}}
```


## Usage

Dynamic provisioning was enabled by the .yaml file above via the
`csi-hostpath-sc` storage class. We can use this to create and claim a
new volume:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/csi-pvc.yaml
persistentvolumeclaim "csi-pvc" created
$ kubectl get pvc
NAME      STATUS    VOLUME                                   CAPACITY   ACCESS MODES   STORAGECLASS      AGE
csi-pvc   Bound     kubernetes-dynamic-pv-bb3d8e2a23d611e8   1Gi        RWO            csi-hostpath-sc   5s
$ kubectl get pv
NAME                                     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS    CLAIM             STORAGECLASS      REASON    AGE
kubernetes-dynamic-pv-bb3d8e2a23d611e8   1Gi        RWO            Delete           Bound     default/csi-pvc   csi-hostpath-sc             8s
```

```yaml
{{#include example/csi-pvc.yaml}}
```

The HostPath driver is configured to create new volumes under `/tmp`
inside the `csi-pod/hostpath-driver` and thus persist as long as the `csi-pod` itself.
We can use such volumes in another pod like this:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/csi-app.yaml
pod "my-csi-app" created
$ kubectl get pods
NAME         READY     STATUS    RESTARTS   AGE
csi-pod      5/5       Running   0          3m
my-csi-app   1/1       Running   0          8s
$ kubectl describe pods/my-csi-app
Name:         my-csi-app
Namespace:    default
Node:         127.0.0.1/127.0.0.1
Start Time:   Fri, 09 Mar 2018 21:17:21 +0100
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
Containers:
  my-frontend:
    Container ID:  docker://52ea6c569abea710166059005416297a654b3216f7ce632516c50498fe130639
    Image:         busybox
    Image ID:      docker-pullable://busybox@sha256:2107a35b58593c58ec5f4e8f2c4a70d195321078aebfadfbfb223a2ff4a4ed21
    Port:          <none>
    Host Port:     <none>
    Command:
      sleep
      1000000
    State:          Running
      Started:      Fri, 09 Mar 2018 21:17:25 +0100
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /data from my-csi-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-hw8rs (ro)
Conditions:
  Type           Status
  Initialized    True 
  Ready          True 
  PodScheduled   True 
Volumes:
  my-csi-volume:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  csi-pvc
    ReadOnly:   false
  default-token-hw8rs:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-hw8rs
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason                  Age   From                     Message
  ----    ------                  ----  ----                     -------
  Normal  Scheduled               59s   default-scheduler        Successfully assigned my-csi-app to 127.0.0.1
  Normal  SuccessfulAttachVolume  59s   attachdetach-controller  AttachVolume.Attach succeeded for volume "kubernetes-dynamic-pv-bb3d8e2a23d611e8"
  Normal  SuccessfulMountVolume   59s   kubelet, 127.0.0.1       MountVolume.SetUp succeeded for volume "default-token-hw8rs"
  Normal  SuccessfulMountVolume   58s   kubelet, 127.0.0.1       MountVolume.SetUp succeeded for volume "kubernetes-dynamic-pv-bb3d8e2a23d611e8"
  Normal  Pulling                 58s   kubelet, 127.0.0.1       pulling image "busybox"
  Normal  Pulled                  55s   kubelet, 127.0.0.1       Successfully pulled image "busybox"
  Normal  Created                 55s   kubelet, 127.0.0.1       Created container
  Normal  Started                 55s   kubelet, 127.0.0.1       Started container

```

```
{{#include example/csi-app.yaml}}
```

## Confirming the setup

Writing inside the app container should be visible in `/tmp` of the `hostpath-driver` container:
```
$ kubectl exec -ti my-csi-app /bin/sh
/ # touch /data/hello-world
/ # exit
$ kubectl exec -ti csi-pod -c hostpath-driver /bin/sh
/ # find / -name hello-world
/tmp/aba238a3-21f9-11e8-9164-0242ac110002/hello-world
```

There should be a `VolumeAttachment` while the app has the volume mounted:
```
$ kubectl get VolumeAttachment
NAME                                                                   AGE
csi-7bf49991faecc67f5049ed4b72e56b5935d92fb21b69fe782e74ea26e25863a3   7m
$ kubectl describe VolumeAttachment
Name:         csi-7bf49991faecc67f5049ed4b72e56b5935d92fb21b69fe782e74ea26e25863a3
Namespace:    
Labels:       <none>
Annotations:  <none>
API Version:  storage.k8s.io/v1beta1
Kind:         VolumeAttachment
Metadata:
  Creation Timestamp:  2018-03-09T20:17:21Z
  Resource Version:    597
  Self Link:           /apis/storage.k8s.io/v1beta1/volumeattachments/csi-7bf49991faecc67f5049ed4b72e56b5935d92fb21b69fe782e74ea26e25863a3
  UID:                 dfaffa08-23d6-11e8-bf78-fcaa1497a416
Spec:
  Attacher:   csi-hostpath
  Node Name:  127.0.0.1
  Source:
    Persistent Volume Name:  kubernetes-dynamic-pv-bb3d8e2a23d611e8
Status:
  Attached:  true
Events:      <none>
```

## Snapshot support

Enable dynamic provisioning of volume snapshot by creating a volume snapshot
class as follows:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/csi-snapshotclass.yaml
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
  Creation Timestamp:  2018-08-28T17:54:04Z
  Generation:          1
  Resource Version:    424
  Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/volumesnapshotclasses/csi-hostpath-snapclass
  UID:                 5a429a21-aaeb-11e8-ae86-000c2967769a
Snapshotter:           csi-hostpath
Events:                <none>
```

```yaml
{{#include example/csi-snapshotclass.yaml}}
```

Use the volume snapshot class to dynamically create a volume snapshot:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/csi-snapshot.yaml
volumesnapshot.snapshot.storage.k8s.io/new-snapshot-demo created
$ kubectl get volumesnapshot
NAME                AGE
new-snapshot-demo   12s
$ kubectl get volumesnapshotcontent
NAME                                               AGE
snapcontent-7bdb093a-aaeb-11e8-ae86-000c2967769a   28s
$ kubectl describe volumesnapshot
Name:         new-snapshot-demo
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  snapshot.storage.k8s.io/v1alpha1
Kind:         VolumeSnapshot
Metadata:
  Creation Timestamp:  2018-08-28T17:55:00Z
  Generation:          1
  Resource Version:    441
  Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/namespaces/default/volumesnapshots/new-snapshot-demo
  UID:                 7bdb093a-aaeb-11e8-ae86-000c2967769a
Spec:
  Snapshot Class Name:    csi-hostpath-snapclass
  Snapshot Content Name:  snapcontent-7bdb093a-aaeb-11e8-ae86-000c2967769a
  Source:
    Kind:  PersistentVolumeClaim
    Name:  hpvc
Status:
  Created At:    2018-08-28T17:55:00Z
  Ready:         true
  Restore Size:  1Gi
Events:          <none>
$ kubectl describe volumesnapshotcontent
Name:         snapcontent-7bdb093a-aaeb-11e8-ae86-000c2967769a
Namespace:
Labels:       <none>
Annotations:  <none>
API Version:  snapshot.storage.k8s.io/v1alpha1
Kind:         VolumeSnapshotContent
Metadata:
  Creation Timestamp:  2018-08-28T17:55:00Z
  Generation:          1
  Resource Version:    439
  Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/volumesnapshotcontents/snapcontent-7bdb093a-aaeb-11e8-ae86-000c2967769a
  UID:                 7bde6846-aaeb-11e8-ae86-000c2967769a
Spec:
  Csi Volume Snapshot Source:
    Creation Time:    1535478900692119403
    Driver:           csi-hostpath
    Restore Size:     1Gi
    Snapshot Handle:  7bdd0de3-aaeb-11e8-9aae-0242ac110002
  Persistent Volume Ref:
    API Version:        v1
    Kind:               PersistentVolume
    Name:               pvc-470e2153-aaeb-11e8-ae86-000c2967769a
    Resource Version:   413
    UID:                4715d726-aaeb-11e8-ae86-000c2967769a
  Snapshot Class Name:  csi-hostpath-snapclass
  Volume Snapshot Ref:
    API Version:  snapshot.storage.k8s.io/v1alpha1
    Kind:         VolumeSnapshot
    Name:         new-snapshot-demo
    Namespace:    default
    UID:          7bdb093a-aaeb-11e8-ae86-000c2967769a
Events:           <none>
```

```yaml
{{#include example/csi-snapshot.yaml}}
```

## Restore volume from snapshot support

To restore volume from snapshot, the VolumeSnapshotDataSource feature gate
needs to be enabled. Follow the following example to create a volume from
a volume snapshot:
```
$ kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/docs/master/book/src/example/csi-restore.yaml
persistentvolumeclaim/hpvc-restore created
$ kubectl get pvc hpvc-restore
NAME           STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
hpvc-restore   Bound     pvc-ecdd2367-b149-11e8-be49-000c2967769a   1Gi        RWO            csi-hostpath-sc   18s
```

```yaml
{{#include example/csi-restore.yaml}}

If you encounter any problems, please check the [Troubleshooting page](Troubleshooting.html).

