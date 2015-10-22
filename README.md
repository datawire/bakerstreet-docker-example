# Baker Street Docker Example #

A pure example of running Docker and Baker Street together without a scheduling or orchestration framework such as
Kubernetes, Swarm, Flynn or any other higher-level container management framework.

## Requirements ##

1. Vagrant and support for using the VirtualBox VM provider.
2. Vagrant plugin [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest).
3. A couple minutes of time!

## Objective ##

The goal is to show how easy it is to build a Baker Street enabled microservices system using Docker containers. The
containers we use are generated from the reusable [bakerstreet-docker-template](https://github.com/datawire/bakerstreet-docker-template) project.