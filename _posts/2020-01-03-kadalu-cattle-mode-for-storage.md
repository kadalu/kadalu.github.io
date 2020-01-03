---
title: "kaDalu — cattle mode for storage"
author: amarts
layout: post
summary: "One of the primary goal for us at Kadalu is keeping things ‘simple’ (It was same for us when we started ‘Gluster’ project). As part of that, our goal was always minimum config, and steps to get things configured. And also, keep the dependency minimal. With release v0.4, kadalu is closer to the reality of true cattle mode for storage"
---

{% include crosspost.html url="https://medium.com/@tumballi/kadalu-cattle-mode-for-storage-26b1adf460a4" name="Amar Tumballi" %}

# kadalu - cattle mode for storage

As I have mentioned earlier, I work on kadalu.io Project. The fun part of any early stage projects is that, there is always more work and problems than you have time. And satisfaction of you finishing one task at a time, is immense :-)

Last month was good for me, as I was working on kadalu project. I learnt a decent amount of k8s, and some debugging skills in that eco-system. Appreciation for CI/CD grew even more. And, got used to python even more.

One of the primary goal for us at Kadalu is keeping things ‘simple’ (It was same for us when we started ‘Gluster’ project). As part of that, our goal was always minimum config, and steps to get things configured. And also, keep the dependency minimal.

In this blog, I talk about 2 features which got added since our v0.3 release 2 weeks back, and which would be highlight for our v0.4 release.

----
### External Storage

In k8s ecosystem, ‘native storage’ means, storage provided by PVCs which would be having storage from inside of same set of hosts which helps run the containers. Any other storage which comes from outside of this is called ‘external storage’. This may be more of ‘Gluster’ naming, mainly because gluster can run as containers, managed by k8s (in which case they are called CNS — container native storage), or gluster can reside in external cluster (outside of k8s cluster), but can provide storage for containers running in k8s (this is called external storage).

When we started kadalu, our goal is to ignore this mode, as we thought we have made storage so simple to use in k8s, no one would want to manage another storage cluster. But, the reality was different. There are many deployments where storage is kept outside of k8s. There were some users who didn’t look at the project mainly because we didn’t support external cluster support.

We now support external gluster storage as Hosting volume for kadalu PVs. Interestingly, in the process, we also added support for those users who would have storage from heketi project, also to use kadalu to manage that storage as PV (through CSI).

----
### gluster brick pods on top of PVC

This is one feature, which truly makes kadalu a cattle mode member in cloud. The problem till now was, one had to run storage on nodes which has storage, and hence it couldn’t be moved around.

In cloud, users had elastic block storage options, which provided storage on any node. But considering there was a decent amount of lag for fail-over to get the storage attached on another node, people preferred gluster’s high availability, which provided instant fail-over. But with gluster/kadalu till now we didn’t had an option of automatically migrate our storage nodes along with PVs.

We have implemented the feature now! As cloud based k8s provides elastic storage, and CSI to manage these, kadalu storage can sit on top of this PVC, and then help our users to scale the same backend PV to provide multiple smaller PVs through kadalu. This makes kadalu storage not attached to a host in cluster, but PVC. Where ever PV is attached, kadalu node would be started.

This is the feature which makes kadalu a true cattle mode solution for hybrid cloud storage.

----
kadalu.io’s [v0.4 is now released](https://github.com/kadalu/kadalu/releases/tag/0.4.0). Give these new features a try, and let us know how is your experience.
