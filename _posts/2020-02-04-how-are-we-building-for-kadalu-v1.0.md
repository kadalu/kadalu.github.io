---
title: "How are we building for Kadalu v1.0?"
author: sankarshan
layout: post
description: "In the journey from v0.5 to v1.0 we aim to work through the tasks of maturing the set of capabilities which we consider to be required as part of the general availability of the release. We also intend to focus on reaching out to the users and engaging with them to understand how to streamline the switching over from Heketi to a Kadalu based deployment of Gluster as persistent storage."
---


[GlusterFS](https://github.com/gluster/glusterfs) which started as distributed file storage in a standalone manner has had overwhelming user acceptance as preferred persistent storage backend in the cloud. The [Heketi project](https://github.com/heketi/heketi) has contributed immensely by enabling a simple ReSTful management interface for volume lifecycle management. This opened up a range of cloud services to dynamically provision storage.

The [Kadalu](https://github.com/kadalu/kadalu) Storage project emerged as the next step in the growth of Gluster as a "cloud native" storage. As application workloads get deployed in the open hybrid cloud infrastructure design pattern, it is needed for the storage to be more near to the control plane of this elasticity. We have designed Kadalu to be more cloud-native and thus make storage easier. With the Heketi project in ["near maintenance mode"](https://github.com/heketi/heketi/blob/master/README.md) the Gluster community requires a simple, stable and intuitive set of patterns with which to provision and manage storage.

Kadalu is built around design principles that are native to the Kubernetes (k8s) platform. Thus, it is a significant shift from any previous attempts to improve on volume lifecycle management (such as glusterd2). By using design primitives which are already present in k8s, Kadalu extends the flexibility of managing storage so that application workload designers can deploy faster and build efficiently.

Looking ahead to the v1.0 release, our goals are simple. We want to make it easy for everyone to deploy, provision and manage storage in public and private cloud. We believe that the direction we have taken with Kadalu enables an user to bring in enterprise grade storage hardware and instantiate it for persistent storage in cloud native IT infrastructure. Kadalu's goal of simplicity in user experience is based on k8s Operator framework and as we enable monitoring and resource management, Kadalu evolves into production readiness.

With the capabilities bundled in the v0.5 release, we see opportunities to consume Kadalu in software supply chain pipelines (including CI/CD); data processing and data manipulation pipelines (including using ML routines) along with the usual set of persistent storage for application data. We already see trends of strategies being built around applications; data stores; message queues which are now "batteries included" in cloud platforms. The evolution of cloud infrastructure layers to a composite whole allows projects such as Kadalu to offer up friction-less storage with baked in monitoring and management operations.

In the journey from v0.5 to v1.0 we aim to work through the tasks of maturing the set of capabilities which we consider to be required as part of the general availability of the release. We also intend to focus on reaching out to the users and engaging with them to understand how to streamline the switching over from Heketi to a Kadalu based deployment of Gluster as persistent storage. These are the 2 key aspects which will enable Kadalu to continue to blaze a trail for the Gluster project as an increasing number of IT infrastructure becomes cloud native and relocates existing digital assets.

