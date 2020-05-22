# Kubernetes PVC DataSource (CSI VolumeContentSource)

When creating a new PersistentVolumeClaim, the Kubernetes API provides a `PersistentVolumeClaim.DataSource` parameter.  This parameter is used to specify the CSI `CreateVolumeRequest.VolumeContentSource` option for CSI Provisioners. The `VolumeContentSource` parameter instructs the CSI plugin to pre-populate the volume being provisioned with data from the specified source. 

## External Provisioner Responsibilities

If a `DataSource` is specified in the `CreateVolume` call to the CSI external provisioner, the external provisioner will fetch the specified resource and pass the appropriate object id to the plugin.

## Supported DataSources

Currently there are two types of `PersistentVolumeClaim.DataSource` objects that are supported:

1. [VolumeSnapshot](snapshot-restore-feature.md)
2. [PersistentVolumeClaim (Cloning)](volume-cloning.md)
