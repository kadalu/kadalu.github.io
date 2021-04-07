---
layout: post
title: "Gluster and Kubernetes - Portmap"
date: 2019-07-09
author: aravindavk
description: "If we remove Glusterd in k8s setup, who will do the role of Glusterd? How will the brick process get the port number?"
---

{% include crosspost.html url="https://aravindavk.in/blog/gluster-and-k8s-portmap" name="Aravinda" %}

One of the primary roles of Glusterd is to allocate a port for brick
processes and let the clients know about it when requested.


Glusterd starts a brick process, and it allocates a free port number
between 49152-49664. Gluster client(or mount) will connect to Glusterd
(port:24007) and asks for the brick port, Glusterd provides brick port
and client then connects to the brick process.

![Get brick port from Glusterd](/static/images/gluster-glusterd-brick-port.png)

If we remove Glusterd in k8s setup, who will do the role of Glusterd?
How will the brick process get the port number?

Now comes the Magic! All brick processes will run with the port number
24007!

Each brick is one container in k8s setup, so no need to search for a new
port. Just use 24007. Gluster client is intelligent enough to know
that the connecting process is Glusterd or Brick process. The client
connects to 24007 to get brick port, and it finds the brick process
itself.

![Client directly connects to brick](/static/images/gluster-brick-connect-direct.png)

Found interesting? Do join our talk about [Managing Gluster in Kubernetes without using Glusterd/Glusterd2](http://bit.ly/gluster-k8s-devconf) at the devconf India event.
