# Kubernetes-CSI Documentation

This repository contains documentation capturing how to develop and deploy a [Container Storage Interface](https://github.com/container-storage-interface/spec/blob/master/spec.md) (CSI) driver on Kubernetes.

To access the documentation go to: [kubernetes-csi.github.io/docs](https://kubernetes-csi.github.io/docs/)

To make changes to the documentation, modify the files in [book/src](https://github.com/kubernetes-csi/docs/tree/master/book/src) and submit a new PR.

Once the PR is reviewed and merged, the CI will automatically generate (using [mdbook](https://github.com/rust-lang-nursery/mdBook)) the HTML to serve and check it in to [src/_book](https://github.com/kubernetes-csi/docs/tree/master/book/src/_book).

## Community, discussion, contribution, and support

Learn how to engage with the Kubernetes community on the [community page](http://kubernetes.io/community/).

You can reach the maintainers of this project at:

- [Slack channel](https://kubernetes.slack.com/messages/sig-storage)
- [Mailing list](https://groups.google.com/forum/#!forum/kubernetes-sig-storage)

### Code of conduct

Participation in the Kubernetes community is governed by the [Kubernetes Code of Conduct](code-of-conduct.md).

## To start editing on localhost

```bash
$ git clone git@github.com:kubernetes-csi/docs.git
$ cd docs
$ make $(pwd)/mdbook
$ make serve
```

Access to http:localhost:3000 and you can view a book on localhost!
