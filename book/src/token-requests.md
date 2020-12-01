# Token Requests

## Status

| Status | Min K8s Version | Max K8s Version |
| ------ | --------------- | --------------- |
| Alpha  | 1.20            | -               |

## Overview

This feature allows CSI drivers to impersonate the pods that they mount the
volumes for. This improves the security posture in the mounting process where
the volumes are ACL’ed on the pods’ service account without handing out
unnecessary permissions to the CSI drivers’ service account.
This feature is especially important for secret-handling CSI drivers, such as
the secrets-store-csi-driver. Since these tokens can be rotated and short-lived,
this feature also provides a knob for CSI drivers to receive NodePublishVolume
RPC calls periodically with the new token. This knob is also useful when volumes
are short-lived, e.g. certificates.

> See more details at the [design document](https://github.com/kubernetes/enhancements/blob/master/keps/sig-storage/1855-csi-driver-service-account-token/README.md).

## Usage

This feature adds two fields in `CSIDriver` spec:

```go
type CSIDriverSpec struct {
    ... // existing fields

    RequiresRepublish *bool
    TokenRequests []TokenRequest
}

type TokenRequest struct {
    Audience string
    ExpirationSeconds *int64
}
```

- **`TokenRequest.Audience`**:

  - This is a required field.
  - Audiences should be distinct, otherwise the validation will fail.
  - If it is empty string, the audience of the token is the `APIAudiences` of kube-apiserver.
    one of the audiences specified.
  - See more about audience specification [here](https://tools.ietf.org/html/rfc7519#section-4.1.3)

- **`TokenRequest.ExpirationSeconds`**:

  - The field is optional.
  - It has to be at least 10 minutes (600 seconds) and no more than `1 << 32` seconds.

- **`RequiresRepublish`**:

  - This field is optional.
  - If this is true, `NodePublishVolume` will be periodically called. When used
    with `TokenRequest`, the token will be refreshed if it expired.
    `NodePublishVolume` should only change the contents rather than the
    mount because container will not be restarted to reflect the mount
    change. The period between `NodePublishVolume` is 0.1s.

The token will be bounded to the pod that the CSI driver is mounting volumes for
and will be set in `VolumeContext`:

```go
"csi.storage.k8s.io/serviceAccount.tokens": {
  <audience>: {
    'token': <token>,
    'expirationTimestamp': <expiration timestamp in RFC3339 format>,
  },
  ...
}
```

If CSI driver doesn't find token recorded in the `volume_context`, it should return error in `NodePublishVolume` to inform Kubelet to retry.

### Example

Here is an example of a `CSIDriver` object:

```yaml
apiVersion: storage.k8s.io/v1
kind: CSIDriver
metadata:
  name: mycsidriver.example.com
spec:
  tokenRequests:
    - audience: "gcp"
    - audience: ""
      expirationSeconds: 3600
  requiresRepublish: true
```

### Feature gate

Kube apiserver must start with the `CSIServiceAccountToken` feature gate enabled:

```
--feature-gates=CSIServiceAccountToken=true
```

### Example CSI Drivers

- [secrets-store-csi-driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver)
  - With [GCP](https://github.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp),
    the driver will pass the token to GCP provider to exchange for GCP credentials, and then request
    secrets from Secret Manager.
  - With [Vault](https://github.com/hashicorp/secrets-store-csi-driver-provider-vault),
    the Vault provider will send the token to Vault which will use the token in
    `TokenReview` request to authenticate.
