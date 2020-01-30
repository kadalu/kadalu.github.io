---
title: "Announcing Kadalu Storage 0.5"
author: kadalu
layout: post
description: "We are excited to make available a new release of Kadalu Storage. The Kadalu Storage 0.5 continues to provide a lightweight solution to provision persistent storage for applications running in Kubernetes"
---

We are excited to make available a new release of Kadalu Storage. The Kadalu Storage 0.5 continues to provide a lightweight solution to provision persistent storage for applications running in Kubernetes

## New in Kadalu Storage 0.5

### Kadalu Kubectl plugin

We continue to add capabilities to make it easy to work with the Kadalu Kubectl plugin available since 0.4 release. This release has the install subcommand for the Kadalu Operator thus enabling installation of Kadalu on an already running Kubernetes cluster.

```console
$ pip3 install kubectl-kadalu
$ kubectl kadalu install
```

In case of Openshift,

```console
$ oc kadalu install --type=openshift
```

Adding storage devices is made easy with this tool. Run kadalu storage-add command to add the device/path/PVC to be managed by Kadalu. For example, to add a device(`/dev/vdc`) from `kube-node-1.example.com`,

```console
$ kubectl kadalu storage-add storage-pool-1 --type Replica1 \
    --device kube-node-1.example.com:/dev/vdc
```

Supported types are `Replica1`, `Replica3`, and `External`. More details about these configurations are available [here](https://kadalu.io/docs/k8s-storage/latest/storage-config-options).

The example above shows adding raw device, Kadalu also supports adding the storage by specifying a path or a PVC name from other storage providers(Example Azure PV or Amazon EBS).

### Support for external Gluster volume

Many users expressed interest in managing Storage clusters outside the Kubernetes and provision persistent volumes to the applications running in Kubernetes. This is now possible with Kadalu! Add the external Gluster Volume using the storage-add command.

Note that, this capability in kadalu can help to use gluster volumes created from other projects like heketi or other methods as PV. More on this would be made available as a document later.

```console
$ kubectl kadalu storage-add storage-pool-1 \
    --external node1.example.com:/gluster-volname
```

More details about this feature are available [here](https://kadalu.io/docs/k8s-storage/latest/external-gluster-storage)

### New images with latest stable Gluster

Kadalu Server container images are upgraded to the latest stable release of Gluster(7.x).

### Bug fixes

* Fixed locking issues during parallel operations like PV claim, starting application pods in parallel([#32](https://github.com/kadalu/kadalu/issues/32)).
* Fixed a crash in kadalu kubectl plugin([#138](https://github.com/kadalu/kadalu/issues/138))

See the detailed [release notes](https://github.com/kadalu/kadalu/blob/master/CHANGELOG.md) for additional information.

## What to expect in the next release?

We continue to make Kadalu more natively integrated with Kubernetes. There are some major features we have coming up. You can use our [issue tracker](https://github.com/kadalu/kadalu/issues) for use cases and workloads which need to be reviewed for priority.

A few key features you can expect in the 0.6 release(End of Feb 2020),

* Thin Arbiter support - This is one of the awesome new features of Gluster to provide high availability with only two storage nodes. Gluster Replica3 volumes are preferred compared to Replica2 volumes to avoid Split-brain issues. With the Thin-arbiter feature, Replica2 volume provides the same availability as Replica 3 volume but using a Tiebreaker node. See the accepted Proposal [here](https://kadalu.io/rfcs/0003-kadalu-thin-arbiter-support.html)

* Enhancements to Kadalu Kubectl plugin - Only `install` and `storage-add` subcommands are available now. We are planning to add `storage-list` and `storage-remove` sub-commands.

* Nightly releases - Don't want to wait till the next version to try the latest features? Team Kadalu is planning to provide nightly releases.

* Resize support for RWX PVs


## Contact us

Please contact us. Happy to discuss the use cases.

* Follow us on Twitter [@kadaluIO](https://twitter.com/kadaluio)
* Write to us - [hello@kadalu.io](mailto:hello@kadalu.io)
* [Slack](https://join.slack.com/t/kadalu/shared_invite/enQtNzg1ODQ0MDA5NTM2LWMzMTc5ZTJmMjk4MzI0YWVhOGFlZTJjZjY5MDNkZWI0Y2VjMDBlNzVkZmI1NWViN2U3MDNlNDJhNjE5OTBlOGU)
* [Linkedin](https://linkedin.com/company/kadalu-io)
* [Github](https://github.com/kadalu/kadalu)
