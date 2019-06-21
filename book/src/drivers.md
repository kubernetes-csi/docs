# Drivers
The following are a set of CSI driver which can be used with Kubernetes:

> NOTE: If you would like your driver to be added to this table, please open a pull request in [this repo](https://github.com/kubernetes-csi/docs/pulls) updating this file.

## Production Drivers

Name | CSI Driver Name | Compatible with CSI Version(s) | Description | Persistence (Beyond Pod Lifetime) | Supported Access Modes | Dynamic Provisioning | [Raw Block Support](raw-block.md) | [Volume Snapshot Support](snapshot-restore-feature.md) | [Volume Expansion Support](volume-expansion.md) | [Volume Cloning Support](volume-cloning.md)
-----|-----------------|--------------------------------|-------------|-----------------------------------|------------------------|----------------------|-----------------------------------|------------|-------------
[Alicloud Disk](https://github.com/AliyunContainerService/csi-plugin) | `diskplugin.csi.alibabacloud.com` | v1.0 | A Container Storage Interface (CSI) Driver for Alicloud Disk | Persistent | Read/Write Single Pod | Yes | Yes | Yes | ? | ?
[Alicloud NAS](https://github.com/AliyunContainerService/csi-plugin) | `nasplugin.csi.alibabacloud.com` | v1.0 | A Container Storage Interface (CSI) Driver for Alicloud Network Attached Storage (NAS) | Persistent | Read/Write Multiple Pods | No | No | No | ? | ?
[Alicloud OSS](https://github.com/AliyunContainerService/csi-plugin)| `ossplugin.csi.alibabacloud.com` | v1.0 | A Container Storage Interface (CSI) Driver for Alicloud Object Storage Service (OSS) | Persistent | Read/Write Multiple Pods | No | No | No | ? | ?
[AWS Elastic Block Storage](https://github.com/kubernetes-sigs/aws-ebs-csi-driver) | `ebs.csi.aws.com` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for AWS Elastic Block Storage (EBS) | Persistent | Read/Write Single Pod | Yes | Yes | Yes | ? | ?
[AWS Elastic File System](https://github.com/aws/aws-efs-csi-driver) | `efs.csi.aws.com` | v0.3 | A Container Storage Interface (CSI) Driver for AWS Elastic File System (EFS) | Persistent | Read/Write Multiple Pods | No | No | No | ? | ?
[AWS FSx for Lustre](https://github.com/aws/aws-fsx-csi-driver) | `fsx.csi.aws.com` | v0.3 | A Container Storage Interface (CSI) Driver for AWS FSx for Lustre (EBS) | Persistent | Read/Write Multiple Pods | No | No | No | ? | ?
[Azure disk](https://github.com/andyzhangx/azuredisk-csi-driver) | `disk.csi.azure.com` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for Azure disk | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[Azure file](https://github.com/andyzhangx/azurefile-csi-driver) | `file.csi.azure.com` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for Azure file | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?
[CephFS](https://github.com/ceph/ceph-csi) | `cephfs.csi.ceph.com` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for CephFS | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?
[Ceph RBD](https://github.com/ceph/ceph-csi) | `rbd.csi.ceph.com` | v0.3, v1.0 | A Container Storage Interface (CSI)  Driver for Ceph RBD | Persistent | Read/Write Single Pod | Yes | Yes | Yes | ? | ?
[Cinder](https://github.com/kubernetes/cloud-provider-openstack/tree/master/pkg/csi/cinder) | `cinder.csi.openstack.org` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for OpenStack Cinder | Persistent | Depends on the storage backend used | Yes, if storage backend supports it | No | Yes, if storage backend supports it | ? | ?
[cloudscale.ch](https://github.com/cloudscale-ch/csi-cloudscale) | `csi.cloudscale.ch` | v1.0 | A Container Storage Interface (CSI) Driver for the [cloudscale.ch](https://www.cloudscale.ch/) IaaS platform | Persistent | Read/Write Single Pod | Yes | No | Yes | ? | ?
[Datera](https://github.com/Datera/datera-csi) | `dsp.csi.daterainc.io` | v1.0 | A Container Storage Interface (CSI) Driver for Datera Data Services Platform (DSP) | Persistent | Read/Write Single Pod | Yes | No | Yes | ? | ?
[DigitalOcean Block Storage](https://github.com/digitalocean/csi-digitalocean) | `dobs.csi.digitalocean.com` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for DigitalOcean Block Storage | Persistent | Read/Write Single Pod | Yes | No | Yes | ? | ?
[DriveScale](https://github.com/DriveScale/k8s-plugins) | `csi.drivescale.com` | v1.0 |A Container Storage Interface (CSI) Driver for DriveScale software composable infrastructure solution | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[Ember CSI](https://ember-csi.io) | `[x].ember-csi.io` | v0.2, v0.3, v1.0 | Multi-vendor CSI plugin supporting over 80 Drivers to provide block and mount storage to Container Orchestration systems. | Persistent | Read/Write Single Pod | Yes | Yes | Yes | No | ?
[GCE Persistent Disk](https://github.com/kubernetes-sigs/gcp-compute-persistent-disk-csi-driver) | `pd.csi.storage.gke.io` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for Google Compute Engine Persistent Disk (GCE PD) | Persistent | Read/Write Single Pod | Yes | No | Yes | ? | ?
[Google Cloud Filestore](https://github.com/kubernetes-sigs/gcp-filestore-csi-driver) | `com.google.csi.filestore` | v0.3 | A Container Storage Interface (CSI) Driver for Google Cloud Filestore | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?
[GlusterFS](https://github.com/gluster/gluster-csi-driver) | `org.gluster.glusterfs` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for GlusterFS | Persistent | Read/Write Multiple Pods | Yes | No | Yes | ? | ?
[Gluster VirtBlock](https://github.com/gluster/gluster-csi-driver) | `org.gluster.glustervirtblock` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for Gluster Virtual Block volumes | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[Hammerspace CSI](https://github.com/hammer-space/csi-plugin) | `com.hammerspace.csi` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for Hammerspace Storage | Persistent | Read/Write Multiple Pods | Yes | Yes | Yes | No | ?
[Hitachi Vantara](https://knowledge.hitachivantara.com/Documents/Adapters_and_Drivers/Storage_Adapters_and_Drivers/Containers) | `com.hitachi.hspc.csi` | v1.0 | A Container Storage Interface (CSI) Driver for VSP series Storage | Persistent | ? | ? | ? | ? | ? | ?
[JuiceFS](https://github.com/juicedata/juicefs-csi-driver) | `csi.juicefs.com` | v0.3 | A Container Storage Interface (CSI) Driver for JuiceFS File System | Persistent | Read/Write Multiple Pod | No | No | No | No | ?
[Linode Block Storage](https://github.com/linode/linode-blockstorage-csi-driver) | `linodebs.csi.linode.com` | v1.0 | A Container Storage Interface (CSI) Driver for Linode Block Storage | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[LINSTOR](https://github.com/LINBIT/linstor-csi) | `io.drbd.linstor-csi` | v1.1 | A Container Storage Interface (CSI) Driver for [LINSTOR](https://www.linbit.com/en/linstor/) volumes | Persistent | Read/Write Single Pod | Yes | No | Yes | ? | ?
[MacroSAN](https://github.com/macrosan-csi/macrosan-csi-driver) | `csi-macrosan` | v1.0 | A Container Storage Interface (CSI) Driver for MacroSAN Block Storage | Persistent | Read/Write Single Pod | Yes | No | No | No | ?
[MapR](https://github.com/mapr/mapr-csi) | `com.mapr.csi-kdf` | v1.0 | A Container Storage Interface (CSI) Driver for MapR Data Platform | Persistent | Read/Write Multiple Pods | Yes | No | Yes | ? | ?
[MooseFS](https://github.com/moosefs/moosefs-csi) | `com.tuxera.csi.moosefs` | v1.0 | A Container Storage Interface (CSI) Driver for [MooseFS](https://moosefs.com/) clusters. | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?
[NetApp](https://github.com/NetApp/trident) | `io.netapp.trident.csi` | v1.0 | A Container Storage Interface (CSI) Driver for NetApp's [Trident](https://netapp-trident.readthedocs.io/) container storage orchestrator | Persistent | Depends on the storage product | Yes | No | No | ? | ?
[NexentaStor](https://github.com/Nexenta/nexentastor-csi-driver) | `nexentastor-csi-driver.nexenta.com` | v1.0 | A Container Storage Interface (CSI) Driver for NexentaStor | Persistent | Read/Write Multiple Pods | Yes | No | Yes | ? | ?
[Nutanix](https://portal.nutanix.com/#/page/docs/details?targetId=CSI-Volume-Driver:CSI-Volume-Driver) | `"com.nutanix.csi"` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for Nutanix | Persistent | "Read/Write Single Pod" with Nutanix Volumes and "Read/Write Multiple Pods" with Nutanix Files | Yes | No | No | ? | ?
[OpenSDS](https://github.com/opensds/nbp/tree/master/csi) | `csi-opensdsplugin` | v1.0 | A Container Storage Interface (CSI) Driver for  [OpenSDS]((https://www.opensds.io/)) | Persistent | Read/Write Single Pod | Yes | Yes | Yes | ? | ?
[Portworx](https://github.com/libopenstorage/openstorage/tree/master/csi) | `pxd.openstorage.org` | v0.3, v1.1 | A Container Storage Interface (CSI) Driver for [Portworx](https://docs.portworx.com/portworx-install-with-kubernetes/storage-operations/csi/) | Persistent | Read/Write Multiple Pods | Yes | No | Yes | Yes | ?
[QingCloud CSI](https://github.com/yunify/qingcloud-csi)| `csi.qingcloud.com` | v1.0 | A Container Storage Interface (CSI) Driver for QingCloud Block Storage | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[QingStor CSI](https://github.com/yunify/qingstor-csi) | `csi-neonsan` | v0.3 | A Container Storage Interface (CSI) Driver for NeonSAN storage system | Persistent | Read/Write Single Pod | Yes | No | Yes | ? | ?
[Quobyte](https://github.com/quobyte/quobyte-csi) | `quobyte-csi` | v0.2 | A Container Storage Interface (CSI) Driver for Quobyte | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?
[ROBIN](https://get.robin.io/) | `robin` | v0.3, v1.0 | A Container Storage Interface (CSI) Driver for [ROBIN](https://docs.robin.io) | Persistent | Read/Write Multiple Pods | Yes | No | Yes | No | ?
[SmartX](http://www.smartx.com/?locale=en) | `csi-smtx-plugin` | v1.0 | A Container Storage Interface (CSI) Driver for SmartX ZBS Storage  | Persistent | Read/Write Multiple Pods | Yes | No | Yes | Yes | ?
[SandStone](https://github.com/sandstone-storage/sandstone-csi-driver) | `csi-sandstone-plugin` | v1.0 | A Container Storage Interface (CSI) Driver for SandStone USP | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[ScaleIO](https://github.com/thecodeteam/csi-scaleio) | `com.thecodeteam.scaleio` | v0.2 | A Container Storage Interface (CSI) Driver for DellEMC ScaleIO | Persistent | Read/Write Single Pod | Yes | No | No | ? | ?
[StorageOS](https://github.com/storageos/charts/blob/master/stable/storageos/README-CSI.md) | ? | v1.0 | A Container Storage Interface (CSI) Driver for [StorageOS](https://storageos.com/) | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?
[XSKY-EBS](https://xsky-csi.github.io/csi-block.html) | `csi.block.xsky.com` | v2.0 | A Container Storage Interface (CSI) Driver for XSKY Distributed Block Storage (X-EBS) | Persistent | Read/Write Single Pod | Yes | No | Yes | No | ?
[XSKY-EUS](https://xsky-csi.github.io/csi-fs.html) | `csi.fs.xsky.com` | v1.0 | A Container Storage Interface (CSI) Driver for XSKY Distributed File Storage (X-EUS) | Persistent | Read/Write Multiple Pods | Yes | No | No | No | ?
[Vault](https://github.com/kubevault/csi-driver) | `secrets.csi.kubevault.com` | v1.0 | A Container Storage Interface (CSI) Driver for mounting HashiCorp Vault secrets as volumes. | Ephemeral | N/A | N/A | N/A | N/A | ? | ?
[vSphere](https://github.com/kubernetes-sigs/vsphere-csi-driver) | `vsphere.csi.vmware.com` | v1.0 | A Container Storage Interface (CSI) Driver for VMware vSphere | Persistent | Read/Write Single Pod | Yes | Yes | No | ? | ?
[YanRongYun](http://www.yanrongyun.com/) | ? | v1.0 | A Container Storage Interface (CSI) Driver for YanRong YRCloudFile Storage  | Persistent | Read/Write Multiple Pods | Yes | No | No | ? | ?

## Sample Drivers

Name | Status | More Information
-----|--------|-------
[Flexvolume](https://github.com/kubernetes-csi/drivers/tree/master/pkg/flexadapter) | Sample |
[HostPath](https://github.com/kubernetes-csi/drivers/tree/master/pkg/hostpath) | v0.2.0 | Only use for a single node tests. See the [Example](Example.html) page for Kubernetes-specific instructions.
[In-memory Sample Mock Driver](https://github.com/kubernetes-csi/csi-test/tree/master/mock/service) | v0.3.0 | The sample mock driver used for [csi-sanity](https://github.com/kubernetes-csi/csi-test/tree/master/cmd/csi-sanity)
[NFS](https://github.com/kubernetes-csi/csi-driver-nfs) | Sample |
[Synology NAS](https://github.com/jparklab/synology-csi) | v1.0.0 | An unofficial (and unsupported) Container Storage Interface Driver for Synology NAS.
[VFS Driver](https://github.com/thecodeteam/csi-vfs) | Released | A CSI plugin that provides a virtual file system.
