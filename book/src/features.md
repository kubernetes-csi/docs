# Features

The Kubernetes implementation of CSI has multiple sub-features. This section describes these sub-features, their status (although support for CSI in Kubernetes is GA/stable, support of sub-features moves independently so sub-features maybe alpha or beta), and how to integrate them in to your CSI Driver.

## Feature Status

This table outlines the feature status across Kubernetes versions.

| Feature | Alpha | Beta | GA |
| ------- | ----- | ---- | -- |
| Raw Block | 1.11 | 1.14 | - |
| Topology | 1.12 | 1.14 | - |
| Skip Attach | 1.12 | 1.14 | - |
| Pod Info on Mount | 1.12 | 1.14 | - |
| Snapshots | 1.12 | - | - |
| Volume Expansion | 1.14 | - | - |
