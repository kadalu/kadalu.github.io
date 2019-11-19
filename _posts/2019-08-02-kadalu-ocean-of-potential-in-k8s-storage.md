---
title: "kaDalu — Ocean of potential in k8s storage"
author: amarts
layout: post
summary: "It has been more than 3 years since Kubernetes (k8s) picked up exponential growth. Now, almost every software company and every product are trying to latch on to this phenomena and expand. While such stupendous growth is a nice thing, it is not without its unique challenges."
---

{% include crosspost.html url="https://medium.com/@tumballi/kadalu-ocean-of-potential-in-k8s-storage-a07be1b8b961" name="Amar Tumballi" %}

It has been more than 3 years since Kubernetes (k8s) picked up
exponential growth. Now, almost every software company and every
product are trying to latch on to this phenomena and expand. While
such stupendous growth is a nice thing, it is not without its unique
challenges.

## k8s and storage:

While process (CPU), network management has completely moved [to
cattle
mode](https://thenewstack.io/how-to-treat-your-kubernetes-clusters-like-cattle-not-pets/)
in k8s, storage is not virtualized enough to become a cattle mode
candidate. By migrating storage management to CSI (Container Storage
Interface) and introducing concepts of PV (PersistentVolume) and PVC
(PersistentVolumeClaim), k8s now has made it possible for storage
vendors to provide viable solutions. But, it **is not** easy!

Let me explain why;

- While network and CPU can stay ephemeral and invoked only when there
  is a need for ‘execution’, data needs to be persisted — stored and
  retrieved even when processes are not invoked.
- To ‘store’ data, one needs to access physical storage media,
  somewhere.

This is the main reason why object storage made sense (mainly because
it can be accessed with a simple URL, can be hosted outside the
cluster somewhere in the cloud). But this is most efficient for
immutable data only. Applications are still written to work on top of
file-systems, which directly or indirectly sits on top of block
storage. Then the question is, what do we do till then?

## Gluster and k8s — story

[Gluster](http://gluster.org/), being a SDS (Software Defined
Storage), has all the ingredients to make storage more cattle mode
like, but lacks a good management layer based on APIs (or call it REST
APIs). The existing implementation made the solution bulkier than
required. Gluster used the “heketi project” as an external entity to
help in k8s world. Even though the whole stack could be containerized
and managed within k8s, the overall complexity of the solution made
its adoption very difficult.

The “Rook project” which started as a ‘storage operator’ for k8s early
on, picked Ceph as the storage engine. Rook did a good job of making
‘management’ easy for admins using k8s. Currently, many projects have
ported their plugins to Rook. And Rook is growing in popularity with
Ceph as the focus.

In the mean time, Gluster tried to productize its long pending GD2
(which was intended to have embedded REST API). For those who doesn’t
know what is gd2, it means v2.0 (or new way) of glusterd, which is the
management layer of Gluster. There was a plan of bringing together
different Gluster projects under a single umbrella to provide a
comprehensive “container storage solution”, called as GCS (Gluster
Container Storage) or GlusterCS. This isn’t finished and has too many
dependencies to call it production ready as yet. As per my
understanding on contributions are made to these projects in last 4
months or so.

The “gluster-subvol” approach which was also attempted didn’t get much
attention though. However, it did solve a major problem of scale of
PVs in k8s. This was not tagged as a generic solution for k8s. Also,
gluster community didn’t perceive this as a generic solution.

> I should say, this is not yet a ‘Gluster community’ project, mainly
> as it changes the way Gluster is managed, and perceived in last 10
> years.

## Introduction to kaDalu

This was the time when the proposal for a light-weight service that
would provide a comprehensive solution, came through. I wrote about it
earlier [here in my
blog](https://medium.com/@tumballi/13020a561962). Once we started
prototyping, we called the project as ‘kaDalu’ (ಕಡಲು), which means
Ocean.

We talked about this at today’s
[DevConf.IN](https://devconfin19.sched.com/event/RVPw). You can find
the slides for our
[presentation](https://github.com/kadalu/kadalu/blob/master/doc/rethinking-gluster-management-using-k8s.pdf)
here, and the demo of our simple two steps install can be found @
[https://asciinema.org/a/259949](https://asciinema.org/a/259949)

![Kadalu Overview](/static/images/kadalu-operator.jpg)

kaDalu is the operator which provisions the gluster storage as
containers, and manages everything related to GlusterFS, so that k8s
users can get PV/PVC requests done through CSI. As it is developed for
higher versions of k8s where CSI is supported (1.14.+), kaDalu choose
to be an independent operator, instead of a sub-operator under rook
project. kadalu is choosen to be very light weight, so there is no
duplicate layers.

One other main solution we wanted to provide with kaDalu project is
helping users (and companies) having traditional storage array, or any
other existing highly available storage, which they want to expose in
k8s. With kadalu, it becomes very easy. All operator and CSI
responsibilities are taken care by kaDalu project, and all you have to
do is, expose the storage in one of the nodes of k8s, and provide
storage config file to k8s.

> One other main solution we wanted to provide with kaDalu project is
> helping users (and companies) having traditional storage array, or
> any other existing highly available storage, which they want to
> expose in k8s

We invite you to try out the project, steps to try and install the
operator are in its [github page](https://github.com/kadalu/kadalu).

I should say, this is not yet a ‘Gluster community’ project, mainly as
it changes the way Gluster is managed, and perceived in last 10
years. If there are enough users trying it out, and liking the project
we can call it a community project. Right now, this is still
[Aravinda](https://aravindavk.in)’s and my pet project. Do give a github star if you like it,
so we know you like it. We also don’t mind you tweeting and blogging
about it :-)
