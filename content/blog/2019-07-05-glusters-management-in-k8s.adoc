---
title: "Gluster’s management in k8s"
author: amarts
layout: post
description: "This blog gives a small snippet into the talk we are giving in DevConf.IN’19. Goes little deep into Gluster project details."
---

{% include crosspost.html url="https://medium.com/@tumballi/glusters-management-in-k8s-13020a561962" name="Amar Tumballi" %}

## A talk @ DevConf.IN’19

This blog gives a small snippet into the talk we are giving in DevConf.IN’19. Goes little deep into Gluster project details.

## The back story

It was some time in 2018, GD2 development was actively happening. Aravinda had just gotten into this team. On one of our weekly twice carpool time, he asked a question which made both of us think a lot (carpooling in Bangalore gives a lot of time think 😃), and feel the ‘Aha!’ moment. He asked, “If GD2 is developed solely to solve the k8s usecase, why don’t we handle it without gluster’s management layer?”

To even think it is a possibility, you have to understand Gluster without its ‘glusterd’ (the management process) era (i.e., pre-2010). Good part is, he proposed that to the Gluster’s first support engineer, who had gone through and handled all humanly possible errors originating from volume (config) file mistakes. Since I was involved in ‘GlusterFS’ development even before the existence of management daemon, I quickly understood his idea.

It was possible, It seemed easy, but sadly, we couldn’t spend time on this idea as we got busy with ‘higher’ priority tasks in our day roles.

## DevConf.IN’19

As we approached 2019, our GD2 development was almost stagnant. And there were projects like rook.io which got more attention, and rightly so. They solved the storage problems better than ‘previously’ available solutions. While Gluster had its share of users consuming the project in k8s, it used heketi project for this solution.

When DevConf CFP was announced, Aravinda and myself regrouped, and worked on a proposal for the event. Now, it was selected and schedule can be found here. Ref: https://devconfin19.sched.com/event/RVPw

    Aravinda: “If GD2 is developed solely to solve the k8s usecase, why don’t we handle it without gluster’s management layer?”

    Me: ‘Why Not?’

As part of the talk, we would like to showcase how this idea can be achieved, how Gluster can make storage ‘Easy’ for you in k8s ecosystem. We have been busy over weekends prototyping, and hoping to have a working model. It would be fantastic to get feedback from you. Any feedback on the idea, implementation, or usability is greatly appreciated.

Looking forward to see you at the event!

## Update:

The event happened, and details are captured here in another blog.

Thanks to Sac Urs. 

