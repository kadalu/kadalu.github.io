---
title: "Kadalu Kubernetes(k8s) Storage"
author: aravindavk
layout: post
summary: "Kadalu project offers a lightweight persistent storage solution for applications running in Kubernetes. Kadalu k8s storage solution is lightest among all the other k8s integrations using Gluster because Kadalu is integrated natively with Kubernetes without using Gluster's management daemon. With this many layers are reduced and completely isolated processes related to different storage devices."
image: /static/images/use-kadalu.jpeg
---

Containers on restart don't persist the modifications done while
running.  The applications which need persistent storage can use a
directory from the host machine as volume, request for persistent
local volume, or third-party storage providers while running in
[Kubernetes(k8s)](https://kubernetes.io/).

 For example, to run an Nginx static file server in a container, files
 need to be copied to `/usr/share/nginx/html` directory. But on
 container restart, the data saved in that directory is lost. A
 directory from the host machine can be mapped as
 `/usr/share/nginx/html` inside the container using the
 [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath)
 configuration.

Take another example; the user runs AI/ML tools on a set of data and
saves the result in the output directory. If the data in input and
output directories are not persistent, then all the processed data
will be lost on the container restart.

HostPath and Local PV solves most of the use cases, but what happens
if an application scheduled to run in another node if the node in
which the app was previously running goes down?

[![Use Kadalu!](/static/images/use-kadalu.jpeg)](https://kadalu.io)

Kubernetes takes care of scheduling the app pod to run in another node
if the currently running node goes down. But copying data associated
with the application to the new node is not feasible.

## How Kadalu solve the persistent storage problem?

Kadalu project offers a lightweight persistent storage solution for
applications running in Kubernetes. Kadalu k8s storage solution is
lightest among all the other k8s integrations using
[Gluster](https://www.gluster.org) because Kadalu is integrated natively
with Kubernetes without using Gluster's management daemon. With this
design pattern, many layers are reduced and completely isolated the
processes related to different storage devices.

Kadalu is cluster-aware and capable of providing mount over the
network. It uses GlusterFS to provide storage to application pods.

Kadalu accepts raw device as its storage and can provide multiple
small persistent volumes from that storage. For example, From `1TiB`
device, Kadalu can provide `1000` persistent volumes of `1GiB` each.

## Components
### Kadalu Operator Pod
Kadalu Operator is just like any other pod but with special
permissions. The Operator starts CSI pods when it began and watches
for any new storage device configuration. For every new storage
configuration, the Operator starts the required server pods. The
Operator is also responsible for maintaining the health of the Kadalu
cluster.

### Kadalu CSI Pods
Kubernetes defines [Container Storage
Interface](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/),
a standard protocol to communicate between the application and
different storage providers. For example, the user submits a claim for
persistent volume, Kubernetes will route the request to respective CSI
driver registered. In this case, Kadalu CSI drivers are running as
pods and listening to the persistent Volume claim requests. Kadalu CSI
drivers are responsible for preparing the volume and make it available
when the requester pod starts.

### Kadalu Server Pods
These pods are important ones. One pod will run for every storage
device added. These pods take care of exporting storage and managing
quota.

## Installation
Install Kadalu Operator using the following command. Once the Operator
pod starts it automatically starts the required CSI driver pods.

```console
$ kubectl create -f https://kadalu.io/operator-latest.yaml
```

### Add storage devices to Kadalu

[Kadalu Kubectl
plugin](https://kadalu.io/blog/introducing-kadalu-kubectl-plugin) is
available with the release 0.4, install it using Python `pip3 install
kubectl-kadalu` command. For example, if a device `/dev/vdc` needs to
be exported from the node kube-node-1.example.com then run the
following command.

```console
$ kubectl kadalu storage-add storage-pool-1 --type=Replica1 \
    --device kube-node1.example.com:/dev/vdc
```

Currently supported types are "Replica1" and "Replica3". More details
about these configurations are discussed later in this blog post.

```console
$ kubectl get pods -n kadalu
NAME                                        READY   STATUS    RESTARTS   AGE
csi-nodeplugin-5hfms                        3/3     Running   0          14m
csi-nodeplugin-924cc                        3/3     Running   0          14m
csi-nodeplugin-cbjl9                        3/3     Running   0          14m
csi-provisioner-0                           4/4     Running   0          14m
operator-577f569dc8-l2q6c                   1/1     Running   0          15m
server-storage-pool-1-0-kube-node1...-0     2/2     Running   0          11m
```

That's it! Now we are ready to claim persistent Volumes.

## Running Webserver example

Create a Persistent Volume Claim(PVC) as below,

```yaml
# File: webserver-pvc.yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: webapp-pv
spec:
  storageClassName: kadalu.replica1
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1GiB
```

```console
$ kubectl create -f webserver-pvc.yaml
```

Now deploy an Nginx pod by specifying the PVC name created above.

```yaml
# File: webserver-app.yaml
---
kind: Pod
apiVersion: v1
metadata:
  name: webapp
spec:
  containers:
    - name: web-nginx
      image: nginx:alpine
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: webapp-storage
  volumes:
    - name: webapp-storage
      persistentVolumeClaim:
       claimName: webapp-pv
```

```console
$ kubectl create -f webserver-app.yaml
```

Documentation for this use-case is available [here](https://kadalu.io/docs/running-a-webserver)

## Kadalu Configurations
### Kadalu configuration - Replica1

This configuration provides high availability for applications if the
storage node is up. This configuration is still better than using
hostPath but not so useful when the storage node goes down.

```console
$ kubectl kadalu storage-add storage-pool-1 --type=Replica1 \
    --device kube-node1.example.com:/dev/vdc
```

### Kadalu configuration - Replica1 but storage from another storage provider

Claim large block devices from Azure or AWS and multiplex into
multiple RWX/RWO volumes using Kadalu Replica1 config. In this case,
AWS/Azure will take care of storage availability.

This solution is better compared to the previous solution because
Kubernetes will now take care of scheduling Kadalu server pod wherever
AWS/Azure devices move in the cluster.

There will be downtime of application pods till the AWS/Azure storage
mounts in another node, and the Kadalu storage server starts in that
new node.

```console
$ kubectl kadalu storage-add storage-pool-1 --type=Replica1 \
    --pvc azure-vol-1
```

### Kadalu Configuration - Replica3
This solution provides high availability of storage even if one out of
three nodes goes down.

```console
$ kubectl kadalu storage-add storage-pool-1 --type=Replica3 \
    --device kube-node1.example.com:/dev/vdc \
    --device kube-node2.example.com:/dev/vdc \
    --device kube-node3.example.com:/dev/vdc
```

Kadalu is also capable of providing persistent storage from Externally
managed Gluster
cluster. [Amar](https://kadalu.io/blog/kadalu-cattle-mode-for-storage)
mentioned those configurations in his blog. We will write about it in
detail with the 0.5 release(Expected at the end of this month).

Is Kadalu suitable for your use-case? Please try and let us know.
