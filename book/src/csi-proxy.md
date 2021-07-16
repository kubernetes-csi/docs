# CSI Proxy

## Status and Releases

**Git Repository:** [https://github.com/kubernetes-csi/csi-proxy](https://github.com/kubernetes-csi/csi-proxy)

**Status:** Beta starting with v0.2.0

Status | Min K8s Version | Max K8s Version
--|--|--
v0.1.0 | 1.18 | - 
v0.2.0+ | 1.18  | -

## Description

CSI Proxy is a binary that exposes a set of gRPC APIs around storage operations over named pipes in Windows. A container, such as CSI node plugins, can mount the named pipes depending on operations it wants to exercise on the host and invoke the APIs.

Each named pipe will support a specific version of an API (e.g. v1alpha1, v2beta1) that targets a specific area of storage (e.g. disk, volume, file, SMB, iSCSI). For example, `\\.\pipe\csi-proxy-filesystem-v1alpha1`, `\\.\pipe\csi-proxy-disk-v1beta1`. Any release of csi-proxy.exe binary will strive to maintain backward compatibility across as many prior stable versions of an API group as possible. Please see details in this [CSI Windows support KEP](https://github.com/kubernetes/enhancements/tree/master/keps/sig-windows/1122-windows-csi-support)

## Usage

Run csi-proxy.exe binary directly on a Window node. Command line options

* `-kubelet-csi-plugins-path`: This is the prefix path of the Kubelet plugin directory in the host file system (`C:\var\lib\kubelet` is used by default).

* `-kubelet-pod-path`: This is the prefix path of the kubelet pod directory in the host file system (`C:\var\lib\kubelet` is used by default).

* `-windows-service`: Configure as a Windows Service

* `-log_file`: If non-empty, use this log file. (Note: must set `logtostdrr`=false if setting -log_file)

For detailed information (binary parameters, etc.), see the README of the relevant branch.

## Deployment

It the responsibility of the Kubernetes distribution or cluster admin to install csi-proxy. Directly run csi-proxy.exe binary or run it as a Windows Service on Kubernetes nodes.
For example,

``` 
    $flags = "-windows-service -log_file=\etc\kubernetes\logs\csi-proxy.log -logtostderr=false"
    sc.exe create csiproxy binPath= "${env:NODE_DIR}\csi-proxy.exe $flags"
    sc.exe failure csiproxy reset= 0 actions= restart/10000
    sc.exe start csiproxy
```
