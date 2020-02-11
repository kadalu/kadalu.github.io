---
title: "Small PVs and Kadalu Storage"
author: aravindavk
layout: post
description: "Kadalu Storage can provision the smallest Persistent Volume as low as 20MiB for the applications running in Kubernetes(k8s). Small PVs are attractive for many use cases like providing home dir for each container user or storing config files of applications etc."
---

Kadalu Storage can provision the smallest Persistent Volume as low as `20MiB` for the applications running in Kubernetes(k8s). Small PVs are attractive for many use cases like providing home dir for each container user or storing config files of applications etc.

Performant Read and write of small files over the network are always challenging, and it is still hard to match local filesystem performance.

This blog is to discuss a hybrid approach to solve these performance issues if the data is not very critical(In case of failure, it is okay to lose last 10-30 seconds data).

Claim PV from Kadalu as usual with the required size, for example, `200MiB`.

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pv1
spec:
  storageClassName: kadalu.replica1
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 200Mi
```

Prepare the Pod container image such that, on start, it copies data from `/srcdata` to `$HOME` directory. The idea is to mount Kadalu PV to `/src` directory and design application to use `$HOME` directory(Or any other required directory). With this approach, the application will be using local data instead of accessing data from the PV provided by Kadalu.

On Pod termination(using pre stop hook), call the reverse sync script to sync data from `$HOME` to `/srcdata`. This method secures the Pod/container data in PV So that it can be started again anytime.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod1
  labels:
    app: my-super-app
spec:
  containers:
  - name: my-super-app
    image: docker.io/kadalu/my-super-app:latest
    imagePullPolicy: IfNotPresent
    lifecycle:
      preStop:
        exec:
          command: ["/usr/local/bin/sync.sh", "~/", "/srcdata"]
    volumeMounts:
    - mountPath: "/srcdata"
      name: csivol
  volumes:
  - name: csivol
    persistentVolumeClaim:
      claimName: pv1
  restartPolicy: OnFailure
```

**Note**: The container image used in the above example is non-existent. It is used for illustrative purposes only.

## Minimize the Risk

What happens in cases where the Pod terminates abruptly or, the node goes down without being able to call Pre to stop the hook script? Let's create a background job that syncs data from `$HOME` to `/srcdata` at regular intervals. For example, if the background job runs once every 10 seconds, then the risk of losing data is reduced to 10 seconds(plus sync time).

Any failure to sync data from `$HOME` to `/srcdata`(or vice-versa) should be treated as a Pod failure to avoid more data loss.

**Note**: This approach is not suitable for large volumes, but a similar technique can be adapted for medium and large volumes if Inotify(or similar tools) is available for containers.

Thanks, [Gautham Pai](https://twitter.com/gauthampai)([Jnaapti](https://jnaapti.com/)) for brainstorming the issues related to small PVs and data movements required when an application Pod starts in other node and hostPath was used as PV.

**WARNING**: This approach is not suitable for all use cases. The specific use case creates a trade-off that losing data for such minimal time duration is considered to be acceptable.
