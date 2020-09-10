# CSI Windows Suppoort

## Status

Status | Min K8s Version | Min CSI proxy Version | Min Node Driver Registrar Version
--|--|--|--
GA | 1.19 | 1.0.0 | 1.3.0
Beta | 1.19 | 0.2.0 | 1.3.0
Alpha | 1.18 | 0.1.0 | 1.3.0


## Overview

CSI drivers (e.g. AzureDisk, GCE PD, etc.) are recommended to be deployed as containers. CSI driver’s node plugin typically runs on every worker node in the cluster (as a DaemonSet). Node plugin containers need to run with elevated privileges to perform storage related operations. However, Windows was not supporting privileged containers (Note: privileged containers a.k.a Host process is introduced as alpha feature in Kubernetes 1.22 very recently). To solve this problem, [CSI Proxy](https://github.com/kubernetes-csi/csi-proxy) is a binary that runs on the Windows host and executes a set of privileged storage operations on Windows nodes on behalf of containers in a CSI Node plugin daemonset. This enables multiple CSI Node plugins to execute privileged storage operations on Windows nodes without having to ship a custom privileged operation proxy.

Please note that CSI controller level operations/sidecars are not supported on Windows.

## How to use the CSI Proxy for Windows?
See how to install CSI Proxy in [csi-proxy.md#Deployment]

For CSI driver authors, import CSI proxy client under github.com/kubernetes-csi/csi-proxy/client. There are six client API groups including disk, filesystem, iscsi, smb, system, volume. See [link](https://github.com/kubernetes-csi/csi-proxy/tree/master/client/groups) for details.
As an example, please check how GCE PD Driver import disk, volume and filesystem client API groups [here](https://github.com/kubernetes-sigs/gcp-compute-persistent-disk-csi-driver/blob/release-1.2/pkg/mount-manager/safe-mounter_windows.go#L28)

The Daemonset specification of a CSI node plugin for Windows can mount the desired named pipes from CSI Proxy based on the version of the API groups that the node-plugin needs to execute.


The following Daemonset YAML shows how to mount various API groups from CSI Proxy into a CSI Node plugin:

```
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: csi-storage-node-win
spec:
  selector:
    matchLabels:
      app: csi-driver-win
  template:
    metadata:
      labels:
        app: csi-driver-win
    spec:
      serviceAccountName: csi-node-sa
      nodeSelector:
        kubernetes.io/os: windows
      containers:
        - name: csi-driver-registrar
          image: k8s.gcr.io/sig-storage/csi-node-driver-registrar
          args:
            - "--v=5"
            - "--csi-address=unix://C:\\csi\\csi.sock"
            - "--kubelet-registration-path=C:\\kubelet\\plugins\\plugin.csi\\csi.sock"
          volumeMounts:
            - name: plugin-dir
              mountPath: C:\csi
            - name: registration-dir
              mountPath: C:\registration
        - name: csi-driver
          image: k8s.gcr.io/sig-storage/csi-driver:win-v1
          args:
            - "--v=5"
            - "--endpoint=unix:/csi/csi.sock"
          volumeMounts:
            - name: kubelet-dir
              mountPath: C:\var\lib\kubelet
            - name: plugin-dir
              mountPath: C:\csi
            - name: csi-proxy-disk-pipe
              mountPath: \\.\pipe\csi-proxy-disk-v1
            - name: csi-proxy-volume-pipe
              mountPath: \\.\pipe\csi-proxy-volume-v1
            - name: csi-proxy-filesystem-pipe
              mountPath: \\.\pipe\csi-proxy-filesystem-v1
      volumes:
        - name: csi-proxy-disk-pipe
          hostPath:
            path: \\.\pipe\csi-proxy-disk-v1
            type: ""
        - name: csi-proxy-volume-pipe
          hostPath:
            path: \\.\pipe\csi-proxy-volume-v1
            type: ""
        - name: csi-proxy-filesystem-pipe
          hostPath:
            path: \\.\pipe\csi-proxy-filesystem-v1
            type: ""
        - name: registration-dir
          hostPath:
            path: C:\var\lib\kubelet\plugins_registry\
            type: Directory
        - name: kubelet-dir
          hostPath:
            path: C:\var\lib\kubelet\
            type: Directory
        - name: plugin-dir
          hostPath:
            path: C:\var\lib\kubelet\plugins\csi.org.io\
            type: DirectoryOrCreate
```

