# Volume Snapshot

<p>Packages:</p>
<ul>
<li>
<a href="#snapshot.storage.k8s.io%2fv1">snapshot.storage.k8s.io/v1</a>
</li>
</ul>
<h2 id="snapshot.storage.k8s.io/v1">snapshot.storage.k8s.io/v1</h2>
Resource Types:
<ul><li>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshot">VolumeSnapshot</a>
</li><li>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotClass">VolumeSnapshotClass</a>
</li><li>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContent">VolumeSnapshotContent</a>
</li></ul>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshot">VolumeSnapshot
</h3>
<div>
<p>VolumeSnapshot is a user&rsquo;s request for either creating a point-in-time
snapshot of a persistent volume, or binding to a pre-existing snapshot.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
snapshot.storage.k8s.io/v1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>VolumeSnapshot</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Standard object&rsquo;s metadata.
More info: <a href="https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata">https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata</a></p>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotSpec">
VolumeSnapshotSpec
</a>
</em>
</td>
<td>
<p>spec defines the desired characteristics of a snapshot requested by a user.
More info: <a href="https://kubernetes.io/docs/concepts/storage/volume-snapshots#volumesnapshots">https://kubernetes.io/docs/concepts/storage/volume-snapshots#volumesnapshots</a>
Required.</p>
<br/>
<br/>
<table>
<tr>
<td>
<code>source</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotSource">
VolumeSnapshotSource
</a>
</em>
</td>
<td>
<p>source specifies where a snapshot will be created from.
This field is immutable after creation.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>volumeSnapshotClassName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>VolumeSnapshotClassName is the name of the VolumeSnapshotClass
requested by the VolumeSnapshot.
VolumeSnapshotClassName may be left nil to indicate that the default
SnapshotClass should be used.
A given cluster may have multiple default Volume SnapshotClasses: one
default per CSI Driver. If a VolumeSnapshot does not specify a SnapshotClass,
VolumeSnapshotSource will be checked to figure out what the associated
CSI Driver is, and the default VolumeSnapshotClass associated with that
CSI Driver will be used. If more than one VolumeSnapshotClass exist for
a given CSI Driver and more than one have been marked as default,
CreateSnapshot will fail and generate an event.
Empty string is not allowed for this field.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotStatus">
VolumeSnapshotStatus
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>status represents the current information of a snapshot.
Consumers must verify binding between VolumeSnapshot and
VolumeSnapshotContent objects is successful (by validating that both
VolumeSnapshot and VolumeSnapshotContent point at each other) before
using this object.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotClass">VolumeSnapshotClass
</h3>
<div>
<p>VolumeSnapshotClass specifies parameters that a underlying storage system uses when
creating a volume snapshot. A specific VolumeSnapshotClass is used by specifying its
name in a VolumeSnapshot object.
VolumeSnapshotClasses are non-namespaced</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
snapshot.storage.k8s.io/v1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>VolumeSnapshotClass</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Standard object&rsquo;s metadata.
More info: <a href="https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata">https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata</a></p>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>driver</code><br/>
<em>
string
</em>
</td>
<td>
<p>driver is the name of the storage driver that handles this VolumeSnapshotClass.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>parameters</code><br/>
<em>
map[string]string
</em>
</td>
<td>
<em>(Optional)</em>
<p>parameters is a key-value map with storage driver specific parameters for creating snapshots.
These values are opaque to Kubernetes.</p>
</td>
</tr>
<tr>
<td>
<code>deletionPolicy</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.DeletionPolicy">
DeletionPolicy
</a>
</em>
</td>
<td>
<p>deletionPolicy determines whether a VolumeSnapshotContent created through
the VolumeSnapshotClass should be deleted when its bound VolumeSnapshot is deleted.
Supported values are &ldquo;Retain&rdquo; and &ldquo;Delete&rdquo;.
&ldquo;Retain&rdquo; means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept.
&ldquo;Delete&rdquo; means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted.
Required.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotContent">VolumeSnapshotContent
</h3>
<div>
<p>VolumeSnapshotContent represents the actual &ldquo;on-disk&rdquo; snapshot object in the
underlying storage system</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>apiVersion</code><br/>
string</td>
<td>
<code>
snapshot.storage.k8s.io/v1
</code>
</td>
</tr>
<tr>
<td>
<code>kind</code><br/>
string
</td>
<td><code>VolumeSnapshotContent</code></td>
</tr>
<tr>
<td>
<code>metadata</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#objectmeta-v1-meta">
Kubernetes meta/v1.ObjectMeta
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>Standard object&rsquo;s metadata.
More info: <a href="https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata">https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata</a></p>
Refer to the Kubernetes API documentation for the fields of the
<code>metadata</code> field.
</td>
</tr>
<tr>
<td>
<code>spec</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentSpec">
VolumeSnapshotContentSpec
</a>
</em>
</td>
<td>
<p>spec defines properties of a VolumeSnapshotContent created by the underlying storage system.
Required.</p>
<br/>
<br/>
<table>
<tr>
<td>
<code>volumeSnapshotRef</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#objectreference-v1-core">
Kubernetes core/v1.ObjectReference
</a>
</em>
</td>
<td>
<p>volumeSnapshotRef specifies the VolumeSnapshot object to which this
VolumeSnapshotContent object is bound.
VolumeSnapshot.Spec.VolumeSnapshotContentName field must reference to
this VolumeSnapshotContent&rsquo;s name for the bidirectional binding to be valid.
For a pre-existing VolumeSnapshotContent object, name and namespace of the
VolumeSnapshot object MUST be provided for binding to happen.
This field is immutable after creation.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>deletionPolicy</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.DeletionPolicy">
DeletionPolicy
</a>
</em>
</td>
<td>
<p>deletionPolicy determines whether this VolumeSnapshotContent and its physical snapshot on
the underlying storage system should be deleted when its bound VolumeSnapshot is deleted.
Supported values are &ldquo;Retain&rdquo; and &ldquo;Delete&rdquo;.
&ldquo;Retain&rdquo; means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept.
&ldquo;Delete&rdquo; means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted.
For dynamically provisioned snapshots, this field will automatically be filled in by the
CSI snapshotter sidecar with the &ldquo;DeletionPolicy&rdquo; field defined in the corresponding
VolumeSnapshotClass.
For pre-existing snapshots, users MUST specify this field when creating the
VolumeSnapshotContent object.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>driver</code><br/>
<em>
string
</em>
</td>
<td>
<p>driver is the name of the CSI driver used to create the physical snapshot on
the underlying storage system.
This MUST be the same as the name returned by the CSI GetPluginName() call for
that driver.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>volumeSnapshotClassName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>name of the VolumeSnapshotClass from which this snapshot was (or will be)
created.
Note that after provisioning, the VolumeSnapshotClass may be deleted or
recreated with different set of values, and as such, should not be referenced
post-snapshot creation.</p>
</td>
</tr>
<tr>
<td>
<code>source</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentSource">
VolumeSnapshotContentSource
</a>
</em>
</td>
<td>
<p>source specifies whether the snapshot is (or should be) dynamically provisioned
or already exists, and just requires a Kubernetes object representation.
This field is immutable after creation.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>sourceVolumeMode</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#persistentvolumemode-v1-core">
Kubernetes core/v1.PersistentVolumeMode
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>SourceVolumeMode is the mode of the volume whose snapshot is taken.
Can be either “Filesystem” or “Block”.
If not specified, it indicates the source volume&rsquo;s mode is unknown.
This field is immutable.
This field is an alpha field.</p>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<code>status</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentStatus">
VolumeSnapshotContentStatus
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>status represents the current information of a snapshot.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.DeletionPolicy">DeletionPolicy
(<code>string</code> alias)</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotClass">VolumeSnapshotClass</a>, <a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentSpec">VolumeSnapshotContentSpec</a>)
</p>
<div>
<p>DeletionPolicy describes a policy for end-of-life maintenance of volume snapshot contents</p>
</div>
<table>
<thead>
<tr>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody><tr><td><p>&#34;Delete&#34;</p></td>
<td><p>volumeSnapshotContentDelete means the snapshot will be deleted from the
underlying storage system on release from its volume snapshot.</p>
</td>
</tr><tr><td><p>&#34;Retain&#34;</p></td>
<td><p>volumeSnapshotContentRetain means the snapshot will be left in its current
state on release from its volume snapshot.</p>
</td>
</tr></tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotContentSource">VolumeSnapshotContentSource
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentSpec">VolumeSnapshotContentSpec</a>)
</p>
<div>
<p>VolumeSnapshotContentSource represents the CSI source of a snapshot.
Exactly one of its members must be set.
Members in VolumeSnapshotContentSource are immutable.
TODO(xiangqian): Add a webhook to ensure that VolumeSnapshotContentSource members
will be immutable once specified.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>volumeHandle</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>volumeHandle specifies the CSI &ldquo;volume_id&rdquo; of the volume from which a snapshot
should be dynamically taken from.
This field is immutable.</p>
</td>
</tr>
<tr>
<td>
<code>snapshotHandle</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>snapshotHandle specifies the CSI &ldquo;snapshot_id&rdquo; of a pre-existing snapshot on
the underlying storage system for which a Kubernetes object representation
was (or should be) created.
This field is immutable.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotContentSpec">VolumeSnapshotContentSpec
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContent">VolumeSnapshotContent</a>)
</p>
<div>
<p>VolumeSnapshotContentSpec is the specification of a VolumeSnapshotContent</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>volumeSnapshotRef</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#objectreference-v1-core">
Kubernetes core/v1.ObjectReference
</a>
</em>
</td>
<td>
<p>volumeSnapshotRef specifies the VolumeSnapshot object to which this
VolumeSnapshotContent object is bound.
VolumeSnapshot.Spec.VolumeSnapshotContentName field must reference to
this VolumeSnapshotContent&rsquo;s name for the bidirectional binding to be valid.
For a pre-existing VolumeSnapshotContent object, name and namespace of the
VolumeSnapshot object MUST be provided for binding to happen.
This field is immutable after creation.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>deletionPolicy</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.DeletionPolicy">
DeletionPolicy
</a>
</em>
</td>
<td>
<p>deletionPolicy determines whether this VolumeSnapshotContent and its physical snapshot on
the underlying storage system should be deleted when its bound VolumeSnapshot is deleted.
Supported values are &ldquo;Retain&rdquo; and &ldquo;Delete&rdquo;.
&ldquo;Retain&rdquo; means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are kept.
&ldquo;Delete&rdquo; means that the VolumeSnapshotContent and its physical snapshot on underlying storage system are deleted.
For dynamically provisioned snapshots, this field will automatically be filled in by the
CSI snapshotter sidecar with the &ldquo;DeletionPolicy&rdquo; field defined in the corresponding
VolumeSnapshotClass.
For pre-existing snapshots, users MUST specify this field when creating the
VolumeSnapshotContent object.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>driver</code><br/>
<em>
string
</em>
</td>
<td>
<p>driver is the name of the CSI driver used to create the physical snapshot on
the underlying storage system.
This MUST be the same as the name returned by the CSI GetPluginName() call for
that driver.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>volumeSnapshotClassName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>name of the VolumeSnapshotClass from which this snapshot was (or will be)
created.
Note that after provisioning, the VolumeSnapshotClass may be deleted or
recreated with different set of values, and as such, should not be referenced
post-snapshot creation.</p>
</td>
</tr>
<tr>
<td>
<code>source</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentSource">
VolumeSnapshotContentSource
</a>
</em>
</td>
<td>
<p>source specifies whether the snapshot is (or should be) dynamically provisioned
or already exists, and just requires a Kubernetes object representation.
This field is immutable after creation.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>sourceVolumeMode</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#persistentvolumemode-v1-core">
Kubernetes core/v1.PersistentVolumeMode
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>SourceVolumeMode is the mode of the volume whose snapshot is taken.
Can be either “Filesystem” or “Block”.
If not specified, it indicates the source volume&rsquo;s mode is unknown.
This field is immutable.
This field is an alpha field.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotContentStatus">VolumeSnapshotContentStatus
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContent">VolumeSnapshotContent</a>)
</p>
<div>
<p>VolumeSnapshotContentStatus is the status of a VolumeSnapshotContent object
Note that CreationTime, RestoreSize, ReadyToUse, and Error are in both
VolumeSnapshotStatus and VolumeSnapshotContentStatus. Fields in VolumeSnapshotStatus
are updated based on fields in VolumeSnapshotContentStatus. They are eventual
consistency. These fields are duplicate in both objects due to the following reasons:
- Fields in VolumeSnapshotContentStatus can be used for filtering when importing a
volumesnapshot.
- VolumsnapshotStatus is used by end users because they cannot see VolumeSnapshotContent.
- CSI snapshotter sidecar is light weight as it only watches VolumeSnapshotContent
object, not VolumeSnapshot object.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>snapshotHandle</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>snapshotHandle is the CSI &ldquo;snapshot_id&rdquo; of a snapshot on the underlying storage system.
If not specified, it indicates that dynamic snapshot creation has either failed
or it is still in progress.</p>
</td>
</tr>
<tr>
<td>
<code>creationTime</code><br/>
<em>
int64
</em>
</td>
<td>
<em>(Optional)</em>
<p>creationTime is the timestamp when the point-in-time snapshot is taken
by the underlying storage system.
In dynamic snapshot creation case, this field will be filled in by the
CSI snapshotter sidecar with the &ldquo;creation_time&rdquo; value returned from CSI
&ldquo;CreateSnapshot&rdquo; gRPC call.
For a pre-existing snapshot, this field will be filled with the &ldquo;creation_time&rdquo;
value returned from the CSI &ldquo;ListSnapshots&rdquo; gRPC call if the driver supports it.
If not specified, it indicates the creation time is unknown.
The format of this field is a Unix nanoseconds time encoded as an int64.
On Unix, the command <code>date +%s%N</code> returns the current time in nanoseconds
since 1970-01-01 00:00:00 UTC.</p>
</td>
</tr>
<tr>
<td>
<code>restoreSize</code><br/>
<em>
int64
</em>
</td>
<td>
<em>(Optional)</em>
<p>restoreSize represents the complete size of the snapshot in bytes.
In dynamic snapshot creation case, this field will be filled in by the
CSI snapshotter sidecar with the &ldquo;size_bytes&rdquo; value returned from CSI
&ldquo;CreateSnapshot&rdquo; gRPC call.
For a pre-existing snapshot, this field will be filled with the &ldquo;size_bytes&rdquo;
value returned from the CSI &ldquo;ListSnapshots&rdquo; gRPC call if the driver supports it.
When restoring a volume from this snapshot, the size of the volume MUST NOT
be smaller than the restoreSize if it is specified, otherwise the restoration will fail.
If not specified, it indicates that the size is unknown.</p>
</td>
</tr>
<tr>
<td>
<code>readyToUse</code><br/>
<em>
bool
</em>
</td>
<td>
<p>readyToUse indicates if a snapshot is ready to be used to restore a volume.
In dynamic snapshot creation case, this field will be filled in by the
CSI snapshotter sidecar with the &ldquo;ready_to_use&rdquo; value returned from CSI
&ldquo;CreateSnapshot&rdquo; gRPC call.
For a pre-existing snapshot, this field will be filled with the &ldquo;ready_to_use&rdquo;
value returned from the CSI &ldquo;ListSnapshots&rdquo; gRPC call if the driver supports it,
otherwise, this field will be set to &ldquo;True&rdquo;.
If not specified, it means the readiness of a snapshot is unknown.</p>
</td>
</tr>
<tr>
<td>
<code>error</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotError">
VolumeSnapshotError
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>error is the last observed error during snapshot creation, if any.
Upon success after retry, this error field will be cleared.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotError">VolumeSnapshotError
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotContentStatus">VolumeSnapshotContentStatus</a>, <a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotStatus">VolumeSnapshotStatus</a>)
</p>
<div>
<p>VolumeSnapshotError describes an error encountered during snapshot creation.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>time</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#time-v1-meta">
Kubernetes meta/v1.Time
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>time is the timestamp when the error was encountered.</p>
</td>
</tr>
<tr>
<td>
<code>message</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>message is a string detailing the encountered error during snapshot
creation if specified.
NOTE: message may be logged, and it should not contain sensitive
information.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotSource">VolumeSnapshotSource
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotSpec">VolumeSnapshotSpec</a>)
</p>
<div>
<p>VolumeSnapshotSource specifies whether the underlying snapshot should be
dynamically taken upon creation or if a pre-existing VolumeSnapshotContent
object should be used.
Exactly one of its members must be set.
Members in VolumeSnapshotSource are immutable.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>persistentVolumeClaimName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>persistentVolumeClaimName specifies the name of the PersistentVolumeClaim
object representing the volume from which a snapshot should be created.
This PVC is assumed to be in the same namespace as the VolumeSnapshot
object.
This field should be set if the snapshot does not exists, and needs to be
created.
This field is immutable.</p>
</td>
</tr>
<tr>
<td>
<code>volumeSnapshotContentName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>volumeSnapshotContentName specifies the name of a pre-existing VolumeSnapshotContent
object representing an existing volume snapshot.
This field should be set if the snapshot already exists and only needs a representation in Kubernetes.
This field is immutable.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotSpec">VolumeSnapshotSpec
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshot">VolumeSnapshot</a>)
</p>
<div>
<p>VolumeSnapshotSpec describes the common attributes of a volume snapshot.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>source</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotSource">
VolumeSnapshotSource
</a>
</em>
</td>
<td>
<p>source specifies where a snapshot will be created from.
This field is immutable after creation.
Required.</p>
</td>
</tr>
<tr>
<td>
<code>volumeSnapshotClassName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>VolumeSnapshotClassName is the name of the VolumeSnapshotClass
requested by the VolumeSnapshot.
VolumeSnapshotClassName may be left nil to indicate that the default
SnapshotClass should be used.
A given cluster may have multiple default Volume SnapshotClasses: one
default per CSI Driver. If a VolumeSnapshot does not specify a SnapshotClass,
VolumeSnapshotSource will be checked to figure out what the associated
CSI Driver is, and the default VolumeSnapshotClass associated with that
CSI Driver will be used. If more than one VolumeSnapshotClass exist for
a given CSI Driver and more than one have been marked as default,
CreateSnapshot will fail and generate an event.
Empty string is not allowed for this field.</p>
</td>
</tr>
</tbody>
</table>
<h3 id="snapshot.storage.k8s.io/v1.VolumeSnapshotStatus">VolumeSnapshotStatus
</h3>
<p>
(<em>Appears on:</em><a href="#snapshot.storage.k8s.io/v1.VolumeSnapshot">VolumeSnapshot</a>)
</p>
<div>
<p>VolumeSnapshotStatus is the status of the VolumeSnapshot
Note that CreationTime, RestoreSize, ReadyToUse, and Error are in both
VolumeSnapshotStatus and VolumeSnapshotContentStatus. Fields in VolumeSnapshotStatus
are updated based on fields in VolumeSnapshotContentStatus. They are eventual
consistency. These fields are duplicate in both objects due to the following reasons:
- Fields in VolumeSnapshotContentStatus can be used for filtering when importing a
volumesnapshot.
- VolumsnapshotStatus is used by end users because they cannot see VolumeSnapshotContent.
- CSI snapshotter sidecar is light weight as it only watches VolumeSnapshotContent
object, not VolumeSnapshot object.</p>
</div>
<table>
<thead>
<tr>
<th>Field</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>
<code>boundVolumeSnapshotContentName</code><br/>
<em>
string
</em>
</td>
<td>
<em>(Optional)</em>
<p>boundVolumeSnapshotContentName is the name of the VolumeSnapshotContent
object to which this VolumeSnapshot object intends to bind to.
If not specified, it indicates that the VolumeSnapshot object has not been
successfully bound to a VolumeSnapshotContent object yet.
NOTE: To avoid possible security issues, consumers must verify binding between
VolumeSnapshot and VolumeSnapshotContent objects is successful (by validating that
both VolumeSnapshot and VolumeSnapshotContent point at each other) before using
this object.</p>
</td>
</tr>
<tr>
<td>
<code>creationTime</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#time-v1-meta">
Kubernetes meta/v1.Time
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>creationTime is the timestamp when the point-in-time snapshot is taken
by the underlying storage system.
In dynamic snapshot creation case, this field will be filled in by the
snapshot controller with the &ldquo;creation_time&rdquo; value returned from CSI
&ldquo;CreateSnapshot&rdquo; gRPC call.
For a pre-existing snapshot, this field will be filled with the &ldquo;creation_time&rdquo;
value returned from the CSI &ldquo;ListSnapshots&rdquo; gRPC call if the driver supports it.
If not specified, it may indicate that the creation time of the snapshot is unknown.</p>
</td>
</tr>
<tr>
<td>
<code>readyToUse</code><br/>
<em>
bool
</em>
</td>
<td>
<em>(Optional)</em>
<p>readyToUse indicates if the snapshot is ready to be used to restore a volume.
In dynamic snapshot creation case, this field will be filled in by the
snapshot controller with the &ldquo;ready_to_use&rdquo; value returned from CSI
&ldquo;CreateSnapshot&rdquo; gRPC call.
For a pre-existing snapshot, this field will be filled with the &ldquo;ready_to_use&rdquo;
value returned from the CSI &ldquo;ListSnapshots&rdquo; gRPC call if the driver supports it,
otherwise, this field will be set to &ldquo;True&rdquo;.
If not specified, it means the readiness of a snapshot is unknown.</p>
</td>
</tr>
<tr>
<td>
<code>restoreSize</code><br/>
<em>
<a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#quantity-resource-api">
k8s.io/apimachinery/pkg/api/resource.Quantity
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>restoreSize represents the minimum size of volume required to create a volume
from this snapshot.
In dynamic snapshot creation case, this field will be filled in by the
snapshot controller with the &ldquo;size_bytes&rdquo; value returned from CSI
&ldquo;CreateSnapshot&rdquo; gRPC call.
For a pre-existing snapshot, this field will be filled with the &ldquo;size_bytes&rdquo;
value returned from the CSI &ldquo;ListSnapshots&rdquo; gRPC call if the driver supports it.
When restoring a volume from this snapshot, the size of the volume MUST NOT
be smaller than the restoreSize if it is specified, otherwise the restoration will fail.
If not specified, it indicates that the size is unknown.</p>
</td>
</tr>
<tr>
<td>
<code>error</code><br/>
<em>
<a href="#snapshot.storage.k8s.io/v1.VolumeSnapshotError">
VolumeSnapshotError
</a>
</em>
</td>
<td>
<em>(Optional)</em>
<p>error is the last observed error during snapshot creation, if any.
This field could be helpful to upper level controllers(i.e., application controller)
to decide whether they should continue on waiting for the snapshot to be created
based on the type of error reported.
The snapshot controller will keep retrying when an error occurs during the
snapshot creation. Upon success, this error field will be cleared.</p>
</td>
</tr>
</tbody>
</table>
<hr/>
<p><em>
Generated with <code>gen-crd-api-reference-docs</code>
on git commit <code>edf5a7b3</code>.
</em></p>