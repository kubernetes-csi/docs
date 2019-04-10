# Functional Testing

Drivers should be functionally "end-to-end" tested while deployed in a Kubernetes cluster. Previously, how to do this and what tests to run was left up to driver authors. Now, a standard set of Kubernetes CSI end-to-end tests can be imported and run by third party CSI drivers. This documentation specifies how to do so.

The CSI community is also looking in to establishing an official "CSI Conformance Suite" to recognize "officially certified CSI drivers".  This documentation will be updated with more information once that process has been defined.

# Kubernetes End to End Testing for CSI Storage Plugins

Currently, [csi-sanity](https://github.com/kubernetes-csi/csi-test/tree/master/cmd/csi-sanity) exists to help test compliance with the CSI spec, but e2e testing of plugins is needed as well to provide plugin authors and users validation that their plugin is integrated well with specific versions of Kubernetes.

## Setting up End to End tests for your CSI Plugin

### Prerequisites:
 * A Kubernetes v1.13+ Cluster
 * [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)

There are two ways to run end-to-end tests for your CSI Plugin
 1) use [Kubernetes E2E Tests](https://github.com/kubernetes/kubernetes/tree/master/test/e2e/storage/external), by providing a DriverDefinition YAML file via a parameter. 
 * **Note**: In some cases you would not be able to use this method, in running e2e tests by just providing a YAML file defining your CSI plugin. For example the [NFS CSI plugin](https://github.com/kubernetes-csi/csi-driver-nfs) currently does not support dynamic provisoning, so we would want to skip those and run only pre-provisioned tests. For such cases, you would need to write your own testdriver, which is discussed below. 
 
 2) import the in-tree storage tests and run them using `go test`. 
 
 This doc will cover how to run the E2E tests using the second method.

## Importing the E2E test suite as a library

In-tree storage e2e tests could be used to test CSI storage plugins. Your repo should be setup similar to how the [NFS CSI plugin](https://github.com/kubernetes-csi/csi-driver-nfs) is setup, where the testfiles are in a `test` directory and the main test file is in the `cmd` directory.

To be able to import Kubernetes in-tree storage tests, the CSI plugin would need to use **Kubernetes v1.14+** (add to plugin's GoPkg.toml, since pluggable E2E tests become available in v1.14). CSI plugin authors would also be required to implement a [testdriver](https://github.com/kubernetes/kubernetes/blob/6644db9914379a4a7b3d3487b41b2010f226e4dc/test/e2e/storage/testsuites/testdriver.go#L31) for their CSI plugin. The testdriver provides required functionality that would help setup testcases for a particular plugin. 

For any testdriver these functions would be required (Since it implements the [TestDriver Interface](https://github.com/kubernetes/kubernetes/blob/6644db9914379a4a7b3d3487b41b2010f226e4dc/test/e2e/storage/testsuites/testdriver.go#L31)):
 - `GetDriverInfo() *testsuites.DriverInfo`
 - `SkipUnsupportedTest(pattern testpatterns.TestPattern)`
 - `PrepareTest(f *framework.Framework) (*testsuites.PerTestConfig, func())` 
 
The `PrepareTest` method is where you would write code to setup your CSI plugin, and it would be called before each test case. It is recommended that you don't deploy your plugin in this method, and rather deploy it manually before running your tests.

`GetDriverInfo` will return a `DriverInfo` object that has all of the plugin's capabilities and required information. This object helps tests find the deployed plugin, and also decides which tests should run (depending on the plugin's capabilities).

Here are examples of the NFS and Hostpath DriverInfo objects:

```
testsuites.DriverInfo{
			Name:        "csi-nfsplugin",
			MaxFileSize: testpatterns.FileSizeLarge,
			SupportedFsType: sets.NewString(
				"", // Default fsType
			),
			Capabilities: map[testsuites.Capability]bool{
				testsuites.CapPersistence: true,
				testsuites.CapExec:        true,
			},
}
```

```
testsuites.DriverInfo{
			Name:        "csi-hostpath",
			FeatureTag:  "",
			MaxFileSize: testpatterns.FileSizeMedium,
			SupportedFsType: sets.NewString(
				"", // Default fsType
			),
			Capabilities: map[testsuites.Capability]bool{
				testsuites.CapPersistence: true,
			},
}
```

You would define something similar for your CSI plugin.

`SkipUnsupportedTest` simply skips any tests that you define there.

Depending on your plugin's specs, you would implement other interaces defined [here](https://github.com/kubernetes/kubernetes/blob/6644db9914379a4a7b3d3487b41b2010f226e4dc/test/e2e/storage/testsuites/testdriver.go#L61). For example the [NFS testdriver](https://github.com/kubernetes-csi/csi-driver-nfs/blob/193faa0f2aa92a3be0855764a1126ff3cdcd3e77/test/nfs-testdriver.go#L66) also implements PreprovisionedVolumeTestDriver and PreprovisionedPVTestDriver interfaces, to enable pre-provisoned tests. 

After implementing the testdriver for your CSI plugin, you would create a `csi-volumes.go` file, where the implemented testdriver is used to run in-tree storage testsuites, [similar to how the NFS CSI plugin does so](https://github.com/kubernetes-csi/csi-driver-nfs/blob/193faa0f2aa92a3be0855764a1126ff3cdcd3e77/test/csi-volumes.go#L37). This is where you would define which testsuites you would want to run for your plugin. All available in-tree testsuites can be found [here](https://github.com/kubernetes/kubernetes/tree/master/test/e2e/storage/testsuites).

Finally, importing the `test` package into your [main test file](https://github.com/kubernetes-csi/csi-driver-nfs/blob/193faa0f2aa92a3be0855764a1126ff3cdcd3e77/cmd/tests/nfs-e2e.go#L18) will [initialize the testsuites to run the E2E tests](https://github.com/kubernetes-csi/csi-driver-nfs/blob/193faa0f2aa92a3be0855764a1126ff3cdcd3e77/test/csi-volumes.go#L37).

The NFS plugin creates a binary to run E2E tests, but you could use `go test` instead to run E2E tests using a command like this:
```
go test -v <main test file> -ginkgo.v -ginkgo.progress --kubeconfig=<kubeconfig file> -timeout=0
```

