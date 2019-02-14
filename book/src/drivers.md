# Drivers
The following are a set of CSI driver which can be used with Kubernetes:

> NOTE: If you would like your driver to be added to this table, please open a pull request in [this repo](https://github.com/kubernetes-csi/docs/pulls) updating this file.

## Production Drivers

Name | Status | More Information
-----|--------|-------
[Alicloud Elastic Block Storage](https://github.com/AliyunContainerService/csi-plugin) | v1.0.0 |A Container Storage Interface (CSI) Storage Plug-in for Alicloud Elastic Block Storage
[Alicloud Elastic File System](https://github.com/AliyunContainerService/csi-plugin)| v1.0.0 |A Container Storage Interface (CSI) Storage Plug-in for Alicloud Elastic File System
[Alicloud OSS](https://github.com/AliyunContainerService/csi-plugin)| v1.0.0 |A Container Storage Interface (CSI) Storage Plug-in for Alicloud OSS
[AWS Elastic Block Storage](https://github.com/kubernetes-sigs/aws-ebs-csi-driver) | v0.2.0 | A Container Storage Interface (CSI) Driver for AWS Elastic Block Storage (EBS)
[AWS Elastic File System](https://github.com/aws/aws-efs-csi-driver) | v0.1.0 | A Container Storage Interface (CSI) Driver for AWS Elastic File System (EFS)
[AWS FSx for Lustre](https://github.com/aws/aws-fsx-csi-driver) | v0.1.0 | A Container Storage Interface (CSI) Driver for AWS FSx for Lustre (EBS)
[Azure disk](https://github.com/andyzhangx/azuredisk-csi-driver)| v0.1.0 (alpha) |A Container Storage Interface (CSI) Storage Plug-in for Azure disk
[Azure file](https://github.com/andyzhangx/azurefile-csi-driver)| v0.1.0 (alpha) |A Container Storage Interface (CSI) Storage Plug-in for Azure file
[CephFS](https://github.com/ceph/ceph-csi)|v1.0.0|A Container Storage Interface (CSI) Storage Plug-in for CephFS
[Cinder](https://github.com/kubernetes/cloud-provider-openstack/tree/master/pkg/csi/cinder)|v0.2.0|A Container Storage Interface (CSI) Storage Plug-in for Cinder
[Datera](https://github.com/Datera/kubernetes-driver)|v1.0.0|A Container Storage Interface (CSI) Storage Plugin for Datera Data Services Platform (DSP)
[DigitalOcean Block Storage](https://github.com/digitalocean/csi-digitalocean) | v0.4.0 | A Container Storage Interface (CSI) Driver for DigitalOcean Block Storage
[DriveScale](https://github.com/DriveScale/k8s-plugins)|v1.0.0|A Container Storage Interface (CSI) Storage Plug-in for DriveScale software composable infrastructure solution
[Ember CSI](https://ember-csi.io) | v0.2.0 (alpha) | Multi-vendor CSI plugin supporting over 80 storage drivers to provide block and mount storage to Container Orchestration systems.
[GCE Persistent Disk](https://github.com/kubernetes-sigs/gcp-compute-persistent-disk-csi-driver)|Beta|A Container Storage Interface (CSI) Storage Plugin for Google Compute Engine Persistent Disk (GCE PD)
[Google Cloud Filestore](https://github.com/kubernetes-sigs/gcp-filestore-csi-driver)|Alpha|A Container Storage Interface (CSI) Storage Plugin for Google Cloud Filestore
[GlusterFS](https://github.com/gluster/gluster-csi-driver) | v1.0.0 | A Container Storage Interface (CSI) Plugin for GlusterFS
[Linode Block Storage](https://github.com/linode/linode-blockstorage-csi-driver) | v0.0.3 | A Container Storage Interface (CSI) Driver for Linode Block Storage 
[MapR](https://github.com/mapr/mapr-csi) | v1.0.0 | A Container Storage Interface (CSI) Storage Plugin for MapR Data Platform
[MooseFS](https://github.com/moosefs/moosefs-csi)|v0.0.1 (alpha)|A Container Storage Interface (CSI) Storage Plugin for [MooseFS](https://moosefs.com/) clusters.
[NetApp](https://github.com/NetApp/trident) | v0.2.0 (alpha) | A Container Storage Interface (CSI) Storage Plug-in for NetApp's [Trident](https://netapp-trident.readthedocs.io/) container storage orchestrator
[NexentaStor](https://github.com/Nexenta/nexentastor-csi-driver) | Beta | A Container Storage Interface (CSI) Driver for NexentaStor
[Nutanix](https://portal.nutanix.com/#/page/docs/details?targetId=CSI-Volume-Driver:CSI-Volume-Driver) | beta | A Container Storage Interface (CSI) Storage Driver for Nutanix
[OpenSDS](https://www.opensds.io/) | Beta | For more information, please visit [releases](https://github.com/opensds/nbp/releases) and https://github.com/opensds/nbp/tree/master/csi
[Portworx](https://portworx.com/) | 0.3.0 | CSI implementation is available [here](https://github.com/libopenstorage/openstorage/tree/master/csi) which can be used as an example also.
[Quobyte](https://github.com/quobyte/quobyte-csi) | v0.2.0 | A Container Storage Interface (CSI) Plugin for Quobyte
[RBD](https://github.com/ceph/ceph-csi)|v1.0.0|A Container Storage Interface (CSI) Storage RBD Plug-in for Ceph
[ScaleIO](https://github.com/thecodeteam/csi-scaleio)|v0.1.0|A Container Storage Interface (CSI) Storage Plugin for DellEMC ScaleIO
[StorageOS](https://storageos.com/) | v1.0.0 | A Container Storage Interface (CSI) Plugin for StorageOS
[XSKY](https://www.xsky.com/en/) | Beta | A Container Storage Interface (CSI) Driver for XSKY Distributed Block Storage (X-EBS) 
[Vault](https://github.com/kubevault/csi-driver) | Alpha | A Container Storage Interface (CSI) Plugin for HashiCorp Vault
[vSphere](https://github.com/thecodeteam/csi-vsphere)|v0.1.0|A Container Storage Interface (CSI) Storage Plug-in for VMware vSphere

## Sample Drivers
Name | Status | More Information
-----|--------|-------
[Flexvolume](https://github.com/kubernetes-csi/drivers/tree/master/pkg/flexadapter) | Sample |
[HostPath](https://github.com/kubernetes-csi/drivers/tree/master/pkg/hostpath) | v0.2.0 | Only use for a single node tests. See the [Example](Example.html) page for Kubernetes-specific instructions.
[In-memory Sample Mock Driver](https://github.com/kubernetes-csi/csi-test/tree/master/mock/service) | v0.3.0 | The sample mock driver used for [csi-sanity](https://github.com/kubernetes-csi/csi-test/tree/master/cmd/csi-sanity)
[NFS](https://github.com/kubernetes-csi/drivers/tree/master/pkg/nfs) | Sample |
[VFS Driver](https://github.com/thecodeteam/csi-vfs) | Released | A CSI plugin that provides a virtual file system.
