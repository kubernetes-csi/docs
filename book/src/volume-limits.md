# Volume Limits

## Status

* Kubernetes 1.11 - 1.11: Alpha
* Kubernetes 1.12 - 1.16: Beta
* Kubernetes 1.17: GA

## Overview

Some storage providers may have a restriction on the number of volumes that can be used in a Node. This is common in cloud providers, but other providers might impose restriction as well.

Kubernetes will respect this limit as long the CSI driver advertises it. To support volume limits in a CSI driver, the plugin must fill in `max_volumes_per_node` in `NodeGetInfoResponse`.

It is recommended that CSI drivers allow for customization of volume limits. That way cluster administrators can distribute the limits of the same storage backends (e.g. iSCSI) accross different drivers, according to their individual needs.
