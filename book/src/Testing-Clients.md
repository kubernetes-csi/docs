# Testing CSI Clients
If you are writing a CSI client, like a CO or a side car container, then you can use some of the following methods to test your application.

* _csi-test unit test mock driver_: The csi-test repo provides an automatically generated Golang mock code to be used for unit tests.
* _mock-driver_: This driver can be used as an external service to test your gRPC calls.
* _hostPath driver_: This driver can be used on a single node to tests for mounting and unmounting of storage.

# CSI-Test Unit Test Mock Driver
The [csi-test](https://github.com/kubernetes-csi/csi-test) unit test mock driver enables Golang clients to test all aspects of their code. This is done by using the mock driver generated using [GoMock](https://github.com/golang/mock), which let's the caller verify parameters and test for returned values. Here is a small example:

```go
	// Setup mock
	m := gomock.NewController(&mock_utils.SafeGoroutineTester{})
	defer m.Finish()
	driver := mock_driver.NewMockIdentityServer(m)

	// Setup input
	in := &csi.GetPluginInfoRequest{
		Version: &csi.Version{
			Major: 0,
			Minor: 1,
			Patch: 0,
		},
	}

	// Setup mock outout
	out := &csi.GetPluginInfoResponse{
		Name:          "mock",
		VendorVersion: "0.1.1",
		Manifest: map[string]string{
			"hello": "world",
		},
	}

	// Setup expectation
	// !IMPORTANT!: Must set context expected value to gomock.Any() to match any value
	driver.EXPECT().GetPluginInfo(gomock.Any(), in).Return(out, nil).Times(1)

	// Create a new RPC
	server := mock_driver.NewMockCSIDriver(&mock_driver.MockCSIDriverServers{
		Identity: driver,
	})
	conn, err := server.Nexus()
	if err != nil {
		t.Errorf("Error: %s", err.Error())
	}
	defer server.Close()

	// Make call
	c := csi.NewIdentityClient(conn)
	r, err := c.GetPluginInfo(context.Background(), in)
	if err != nil {
		t.Errorf("Error: %s", err.Error())
	}

	name := r.GetName()
	if name != "mock" {
		t.Errorf("Unknown name: %s\n", name)
	}
```

## More Information
For more examples and information see:

* [external-attacher side car container](https://github.com/kubernetes-csi/external-attacher/blob/master/pkg/connection/connection_test.go)
* [Golang GoMock](https://github.com/golang/mock)

# Mock Driver
The [mock driver](https://github.com/thecodeteam/gocsi/tree/master/mock) from [_TheCodeTeam_](https://github.com/thecodeteam) can also be used to test your application for functional tests. For convenience, we provide a containerized version which can be used as follows:

```
$ docker run -d --rm -e CSI_ENDPOINT=tcp://:34555 -p 34555:34555 docker.io/k8scsi/mock-plugin
$ csc controller list-volumes -v 0.1.0 --endpoint tcp://127.0.0.1:34555
```

Where [_csc_](https://github.com/thecodeteam/gocsi/tree/master/csc) is _TheCodeTeam_'s sample test client.

# HostPath Driver
The [hostPath](https://github.com/kubernetes-csi/drivers/tree/master/pkg/hostpath) driver is probably the simplest CSI driver to use for testing on a single node. This is the driver that is for CSI e2e tests in Kubernetes. See the [Example](Example.html) page for deployment and usage instructions.

