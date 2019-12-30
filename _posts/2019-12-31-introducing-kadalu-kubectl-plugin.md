---
title: "Introducing Kadalu kubectl plugin"
author: aravindavk
layout: post
summary: "Kadalu kubectl plugin further simplifies the hassle of generating storage YAML file and adding it to the Kadalu Storage."
---

> [Kadalu](https://kadalu.io) is a lightweight project which provides
> persistent storage for apps running in Kubernetes.

[Kubernetes](https://kubernetes.io) supports extending  `kubectl`
functionalities via
[plugins](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/). We
are happy to announce the Kadalu kubectl plugin with the `0.4` release.

Installing Kadalu is very easy! The first step is to install the
Kadalu Operator by running the following command.

```console
kube-master# kubectl kubectl create -f https://kadalu.io/operator-latest.yaml
```

The second step is to define the storage pool, which is a YAML file
with the details about available storage devices and corresponding
Kube node. For example, the below YAML file is to add `/dev/vdc` from
kube-node1.example.com to Kadalu Storage.

```yaml
# File: storage-pool.yaml
---
apiVersion: kadalu-operator.storage/v1alpha1
kind: KadaluStorage
metadata:
 # This will be used as name of PV Hosting Volume
  name: storage-pool-1
spec:
  type: Replica1
  storage:
    - node: kube-node1.example.com  # node name as shown in `kubectl get nodes`
      device: /dev/vdc              # Device to provide storage to all PVs
```

Then run the following command to add that device to Kadalu Storage so
that that future PV claims can be served from this pool.

```console
kube-master# kubectl create -f storage-pool.yaml
```

Kadalu kubectl plugin further simplifies the hassle of generating
storage YAML file and adding it to the Kadalu Storage. For example,
the following command does the same thing as create YAML file and
calling kubectl create command.

```console
kube-master# kubectl kadalu storage-add storage-pool-1 \
    --device kube-node1.example.com:/dev/vdc
```

Install Kadalu kubectl plugin using the following command,

```console
kube-master# pip3 install kubectl-kadalu
```

Run `kubectl kadalu storage-add --help` to see all the available options.

In this initial release,  only add storage is supported. Please write
to us with the list of features you want to see in this tool.

