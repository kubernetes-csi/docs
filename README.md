# Kubernetes-CSI Documentation
Welcome to the Kubernets-CSI documentation reposotiory. Here you will find information on how to use, develop, and deploy CSI plugins, or drivers, with Kubernetes.

This is the repository for the book published on [kubernetes-csi.github.io/docs](https://kubernetes-csi.github.io/docs/). The sources for the book are in the `book/` and it is setup to use [mdbook](https://github.com/rust-lang-nursery/mdBook).

The `docs/` directory is the output of the book and the root of the published website. 

## Generate the Book
`docs/` is created by running `mdbook build` from the `book/` directory. Alternatively, you can use docker to generate `docs/` using following command:

```
docker run --rm -v $(pwd):/data -u $(id -u):$(id -g) -it chengpan/mdbook:0.2.1 mdbook build ./book
```

## Community, discussion, contribution, and support

Learn how to engage with the Kubernetes community on the [community page](http://kubernetes.io/community/).

You can reach the maintainers of this project at:

- [Slack channel](https://kubernetes.slack.com/messages/sig-storage)
- [Mailing list](https://groups.google.com/forum/#!forum/kubernetes-sig-storage)

### Code of conduct

Participation in the Kubernetes community is governed by the [Kubernetes Code of Conduct](code-of-conduct.md).
