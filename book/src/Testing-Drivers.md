# Testing CSI Drivers
There are multiple ways to test your driver, some still in development. This page will describe each of the multiple methods to test your driver.

## Unit Testing
There are multiple ways to test your driver. One way is to exercise every call by writing your own client for your unit tests as done in the [Portworx driver](https://github.com/libopenstorage/openstorage/tree/master/csi).

Another way to test your driver is to use the [`sanity`](https://github.com/kubernetes-csi/csi-test/tree/master/pkg/sanity) package from [csi-test](https://github.com/kubernetes-csi/csi-test). This simple package contains a single call which will test your driver according to the CSI specification. Here is an example of how it can be used:

```go
func TestMyDriver(t *testing.T) {
    // Setup the full driver and its environment
    ... setup driver ...

    // Now call the test suite
    sanity.Test(t, driverEndpointAddress)
}
```

## Functional Testing
For functional testing you can again provide your own model, or some of the following tools:

### csi-sanity
[csi-sanity](https://github.com/kubernetes-csi/csi-test/tree/master/cmd/csi-sanity) is a program from [csi-test](https://github.com/kubernetes-csi/csi-test) which tests your driver based on the [`sanity`](https://github.com/kubernetes-csi/csi-test/tree/master/pkg/sanity) package.

Here is a sample way to use it:

```
$ csi-sanity --ginkgo.v --csi.endpoint=<your csi driver endpoint>
```

For more information please see [csi-sanity](https://github.com/kubernetes-csi/csi-test/tree/master/cmd/csi-sanity)

### Container Storage Client
Container Storage client, or [csc](https://github.com/thecodeteam/gocsi/tree/master/csc) is a program created by [_thecodeteam_](https://github.com/thecodeteam) to execute commands to a driver. With this program you can manually send commands to your driver. Here is an example:

```
$ csc controller list-volumes -v 0.1.0 --endpoint <your csi driver endpoint>
```


