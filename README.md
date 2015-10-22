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

The service we are going to use for demonstration exposes a very basic HTTP-based API that returns JSON. The source for
the service can be seen here: [hello.py](https://github.com/datawire/bakerstreet-docker-template/blob/master/image/hello.py)

## Tutorial ##

### Getting Started ###

1. Start the example VM `vagrant up` ... bootstrapping takes a few minutes so go grab a cup of coffee.
2. SSH into the running VM using `vagrant ssh`

Once these steps are performed there will be a Datawire Directory server running on the host VM. Going forward the
containerized services will communicate with the Directory on the host for convenience, but in practice it would be 
trivial to move the Directory to a different host system.

### Launching the first service ###

Let's launch the first service. You can use the convenient helper script available on the VM to perform this operation:

`./launch_service.sh -p=9000 -v=1`

What that command is indicating is that we want to start a new service and expose it via port 9000. The v=1 parameter
indicates that we will start the :v1 tagged Docker image.

Once the container is loaded 


3. Start your first service `./launch_service.sh -p=9000 -v=1`
4. Start your second service
5. Start your third service
6. Start your fourth service
7. 