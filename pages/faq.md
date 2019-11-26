---
layout: page
permalink: /faq
---

## You say kadalu is powered by Gluster, but I don't see Gluster installation notes

That is the beauty of Kadalu. We made 'gluster' invisible to users. Many of the
gluster management's (glusterd/CLI) responsibilities are deligated to Kubernetes
to make the solution simple. Read more about this in our first presentation.

## I don't see any option to configure glusterfs, you say none of 350+ options of gluster needs to be configured?

We believe in simplicity. Specially in case of micro-services ecosystem, the highlight is always on simplicity. We have removed many layers of gluster in our template volfiles. Our default options which are added in gluster volfile template are good enough for 90-95% of the usecases we want to serve. If you are in that rare 1-5% of usecases, our code is open, and you can extend the templates. Or also get in touch with us to resolve your issue.

## Why is CSI / Operator developed in Python, when 'golang' is defacto language in kubernetes eco-system.

It is not true that everything in kubernetes world has to be in golang. While it has its own benefits, we have to weigh our decisions based on what serves kadalu better. How we want to enable the community, etc.

We picked Python for our project considering multiple reasons.
1) Operator, CSI are in control plane so performance will not matter,
2) Rich standard library, that means less external dependencies. (For example, in Go, we have to depend on third party library even for logging),
3) We are using Python3 which has inbuilt support for async/await that means GIL(Global interpreter lock) is not a bottleneck even in case of thread is used.
4) More developers than Go (We may be wrong here, but based on our general observation),
5) Good support for running subcommands and handle errors(Look for a example in Go for getting return code of child process)

We are open to re-valuate our decision from time to time, but for now, for use case we are trying to solve with kadalu, Python seems to be a better choice.

