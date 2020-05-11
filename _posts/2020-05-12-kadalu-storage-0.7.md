---
title: "Announcing Kadalu Storage 0.7"
author: kadalu
layout: post
description: "Use Kadalu Storage as Local Storage alternative, experimental Arm support and much more"
---

The Kadalu team is happy to announce a new version of Kadalu Storage,
0.7.0.

## Documentation updates

* Added documentation for [Storage
  classes](https://kadalu.io/docs/k8s-storage/latest/storage-classes). This
  document explains Kadalu Storage classes, which are available by
  default, and also describes how to create Custom Storage classes.

## New Features

* **Use Kadalu as an alternative to local storage** - Replica 1
  storage pool type is beneficial for many applications that don't
  require replication. In the previous releases, the PV claim doesn't
  have the option to specify node affinity while choosing the Kadalu
  Storage pool. 

  In this release, a new filter(`node_affinity`) added to enable node
  filter while defining new storage classes.

  For example, create a new Storage class as below by specifying
  node_affinity as `node2.example.com`.

        kind: StorageClass
        apiVersion: storage.k8s.io/v1
        metadata:
          name: kadalu.local-node2
        provisioner: kadalu
        parameters:
          node_affinity: "node2.example.com"  # Node name as shown in `kubectl get nodes`

  PVC request by specifying the above Storage class name.

        kind: PersistentVolumeClaim
        apiVersion: v1
        metadata:
          name: pv1
        spec:
          storageClassName: kadalu.local-node2
          accessModes:
            - ReadWriteMany
          resources:
            requests:
              storage: 10Gi

  More details are available
  [here](https://kadalu.io/docs/k8s-storage/latest/storage-classes).

  **Note**: Node affinity is applicable only for `Replica1` Storage
  pools.

* **Experimental Arm support** - Kadalu container images are built for
  Arm, please try and provide feedback to make this support
  stable. Start the operator with `kubectl create -f
  https://raw.githubusercontent.com/kadalu/kadalu/master/manifests/kadalu-operator-master.yml`
  (Or using `kubectl kadalu install --version=master` if Kadalu Kubectl
  plugin is installed) to get started! Once we have few users confirming
  it works, will tag it in a release!

* **Python2 support added to Kadalu Kubectl extension** - Install using,
`sudo pip install kubectl-kadalu`

* Kadalu now works with **Kubernetes 1.18**

* Kadalu Server and CSI container images are upgraded to the latest
  stable release of Gluster(7.4).

* Fixed an issue of Server pods not starting due to long
  names. Removed hostname identifier from the Server pod names so that
  the Server pod name length will be well within limits. Use `kubectl
  get pods -n kadalu -o wide` to see the hostnames.

See the detailed [release
notes](https://github.com/kadalu/kadalu/blob/master/CHANGELOG.md) for
additional information.

## Contributors to this release (5)

A huge thanks goes to all the awesome people who made this release
possible.

* [Adrian Wyssmann (papanito)](https://github.com/papanito)
* [Amar Tumballi (amarts)](https://github.com/amarts)
* [Aravinda Vishwanathapura (aravindavk)](https://github.com/aravindavk)
* [Endre Sara (esara)](https://github.com/esara)
* [Shreevatsa N (vatsa287)](https://github.com/vatsa287)
