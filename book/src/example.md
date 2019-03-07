# Example

The [Hostpath CSI driver](https://github.com/kubernetes-csi/csi-driver-host-path) is a simple sample driver that provisions a directory on the host. It can be used as an example to get started writing a driver, however it is not meant for production use.
The [deployment example](https://github.com/kubernetes-csi/csi-driver-host-path/tree/master/deploy) shows how to deploy and use that driver in Kubernetes.

Deployment has been tested with Kubernetes v1.13

The example deployment uses the original RBAC rule files that are maintained together with sidecar apps and deploys into the default namespace. A real production should copy the RBAC files and customize them as explained in the comments of those files.

### Deploy livenessprobe with CSI plugin

The CSI community provides a livenessprobe side-container that can be integrated with the CSI driver services (Node and Controller) to provide the liveness of the CSI service containers.

The livenessprobe side-container will expose the an http endpoint that will be used in a kubernetes liveness probe.

Below is an example configuration which needs to be added to CSI driver services (Node and Controller) yamls:

Note: This example is derived from [using-livenessprobe](https://github.com/kubernetes-csi/livenessprobe#using-livenessprobe) from [kubernetes-csi/livenessprobe](https://github.com/kubernetes-csi/livenessprobe)

```yaml
- name: hostpath-driver
    image: quay.io/k8scsi/hostpathplugin:vx.x.x
    imagePullPolicy: Always
    securityContext:
      privileged: true
#
# Defining port which will be used to GET plugin health status
# 9808 is default, but can be changed.
#
    ports:
    - containerPort: 9808
      name: healthz
      protocol: TCP
    livenessProbe:
      failureThreshold: 5
      httpGet:
        path: /healthz
        port: healthz
      initialDelaySeconds: 10
      timeoutSeconds: 3
      periodSeconds: 2
      failureThreshold: 1
...
#
# Spec for liveness probe sidecar container
# 
 - name: liveness-probe
    imagePullPolicy: Always
    volumeMounts:
    - mountPath: /csi
      name: socket-dir
    image: quay.io/k8scsi/livenessprobe:v0.4.1
    args:
    - --csi-address=/csi/csi.sock
    - --connection-timeout=3s
    - --health-port=9898
#
```

Where:

- `--csi-address` - specifies the Unix domain socket path, as seen in the container, for the CSI driver. It allows the livenessprobe sidecar to communicate with the driver for driver liveness information.  Mount path `/csi` is mapped to HostPath entry `socket-dir` which is mapped to directory `/var/lib/kubelet/plugins/csi-hostpath`

- `--connection-timeout` - specifies the timeout duration of waiting for CSI driver socket in seconds. (default 30s)

- `--health-port` - specifies the TCP ports for listening healthz requests (default "9808")

## Snapshot support

Deployment example starts the snapshotter pod.

>
> $ kubectl get volumesnapshotclass
> ```
> NAME                     AGE
> csi-hostpath-snapclass   11s
> ```
>
> $ kubectl describe volumesnapshotclass
> ```
> Name:         csi-hostpath-snapclass
> Namespace:
> Labels:       <none>
> Annotations:  <none>
> API Version:  snapshot.storage.k8s.io/v1alpha1
> Kind:         VolumeSnapshotClass
> Metadata:
>   Creation Timestamp:  2018-10-03T14:15:30Z
>   Generation:          1
>   Resource Version:    2418
>   Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/volumesnapshotclasses/csi-hostpath-snapclass
>   UID:                 c8f5bc47-c716-11e8-8911-000c2967769a
> Snapshotter:           csi-hostpath
> Events:                <none>
> ```

Use the volume snapshot class to dynamically create a volume snapshot:

> $ kubectl create -f [https://raw.githubusercontent.com/kubernetes-csi/docs/387dce893e59c1fcf3f4192cbea254440b6f0f07/book/src/example/snapshot/csi-snapshot.yaml](https://github.com/kubernetes-csi/docs/blob/387dce893e59c1fcf3f4192cbea254440b6f0f07/book/src/example/snapshot/csi-snapshot.yaml)
> `volumesnapshot.snapshot.storage.k8s.io/new-snapshot-demo created`
>
> $ kubectl get volumesnapshot
> ```
> NAME                AGE
> new-snapshot-demo   12s
> ```
>
> $ kubectl get volumesnapshotcontent
>```
> NAME                                               AGE
> snapcontent-f55db632-c716-11e8-8911-000c2967769a   14s
> ```
>
> $ kubectl describe volumesnapshot
> ```
> Name:         new-snapshot-demo
> Namespace:    default
> Labels:       <none>
> Annotations:  <none>
> API Version:  snapshot.storage.k8s.io/v1alpha1
> Kind:         VolumeSnapshot
> Metadata:
>   Creation Timestamp:  2018-10-03T14:16:45Z
>   Generation:          1
>   Resource Version:    2476
>   Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/namespaces/default/volumesnapshots/new-snapshot-demo
>   UID:                 f55db632-c716-11e8-8911-000c2967769a
> Spec:
>   Snapshot Class Name:    csi-hostpath-snapclass
>   Snapshot Content Name:  snapcontent-f55db632-c716-11e8-8911-000c2967769a
>   Source:
>     Kind:  PersistentVolumeClaim
>     Name:  csi-pvc
> Status:
>   Creation Time:  2018-10-03T14:16:45Z
>   Ready:          true
>   Restore Size:   1Gi
> Events:           <none>
> ```
>
> $ kubectl describe volumesnapshotcontent
> ```
> Name:         snapcontent-f55db632-c716-11e8-8911-000c2967769a
> Namespace:
> Labels:       <none>
> Annotations:  <none>
> API Version:  snapshot.storage.k8s.io/v1alpha1
> Kind:         VolumeSnapshotContent
> Metadata:
>   Creation Timestamp:  2018-10-03T14:16:45Z
>   Generation:          1
>   Resource Version:    2474
>   Self Link:           /apis/snapshot.storage.k8s.io/v1alpha1/volumesnapshotcontents/snapcontent-f55db632-c716-11e8-8911-000c2967769a
>   UID:                 f561411f-c716-11e8-8911-000c2967769a
> Spec:
>   Csi Volume Snapshot Source:
>     Creation Time:    1538576205471577525
>     Driver:           csi-hostpath
>     Restore Size:     1073741824
>     Snapshot Handle:  f55ff979-c716-11e8-bb16-000c2967769a
>   Persistent Volume Ref:
>     API Version:        v1
>     Kind:               PersistentVolume
>     Name:               pvc-0571cc14-c714-11e8-8911-000c2967769a
>     Resource Version:   1573
>     UID:                0575b966-c714-11e8-8911-000c2967769a
>   Snapshot Class Name:  csi-hostpath-snapclass
>   Volume Snapshot Ref:
>     API Version:       snapshot.storage.k8s.io/v1alpha1
>     Kind:              VolumeSnapshot
>     Name:              new-snapshot-demo
>     Namespace:         default
>     Resource Version:  2472
>     UID:               f55db632-c716-11e8-8911-000c2967769a
> Events:                <none>
> ```

## Restore volume from snapshot support

Follow the following example to create a volume from a volume snapshot:

> $ kubectl create -f [https://raw.githubusercontent.com/kubernetes-csi/docs/387dce893e59c1fcf3f4192cbea254440b6f0f07/book/src/example/snapshot/csi-restore.yaml](https://github.com/kubernetes-csi/docs/blob/387dce893e59c1fcf3f4192cbea254440b6f0f07/book/src/example/snapshot/csi-restore.yaml)
> `persistentvolumeclaim/hpvc-restore created`
>
> $ kubectl get pvc
> ```
> NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
> csi-pvc        Bound    pvc-0571cc14-c714-11e8-8911-000c2967769a   1Gi        RWO            csi-hostpath-sc   24m
> hpvc-restore   Bound    pvc-77324684-c717-11e8-8911-000c2967769a   1Gi        RWO            csi-hostpath-sc   6s
> ```
>
> $ kubectl get pv
> ```
> NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS      REASON   AGE
> pvc-0571cc14-c714-11e8-8911-000c2967769a   1Gi        RWO            Delete           Bound    default/csi-pvc        csi-hostpath-sc            25m
> pvc-77324684-c717-11e8-8911-000c2967769a   1Gi        RWO            Delete           Bound    default/hpvc-restore   csi-hostpath-sc            33s
> ```

If you encounter any problems, please check the [Troubleshooting page](Troubleshooting.html).
