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

Once the container is loaded we can pretend to be a consumer client of the application by running the following command:

`docker exec -it client curl localhost:8000/health`

which should return something like this:

```json
{
  "index": 73, 
  "message": "Hello, world!", 
  "service_id": "57c135da-a8d6-434c-8571-8290bafa23e5", 
  "version": "1"
}
```

Let's start another service up. It's important we use a different port because Docker can only bind and map ports on a
1:1 cardinality.

`./launch_service.sh -p=9001 -v=1`

The re-run the client twice and the output should be something like this (notice the service ID is different):

```
for i in 1 2 ; do docker exec client curl -s http://localhost:8000/hello ; done
{
  "index": 391, 
  "message": "Hello, world!", 
  "service_id": "57c135da-a8d6-434c-8571-8290bafa23e5", 
  "version": "1"
}{
  "index": 251, 
  "message": "Hello, world!", 
  "service_id": "74688615-2938-4d5f-9dc9-2bdabba1f15e", 
  "version": "1"
}
```

Let's canary launch a brand new **2.0** version of our service. The 2.0 version doesn't do anything functionally
different besides report a new version, but, it is sufficient to show you how Baker Street enabled containers can be
canary released!

`./launch_service.sh -p=9002 -v=2`

Then run our test loop:

```
for i in 1 2 3; do docker exec client curl -s http://localhost:8000/hello ; done
{
  "index": 452, 
  "message": "Hello, world!", 
  "service_id": "57c135da-a8d6-434c-8571-8290bafa23e5", 
  "version": "1"
}{
  "index": 312, 
  "message": "Hello, world!", 
  "service_id": "74688615-2938-4d5f-9dc9-2bdabba1f15e", 
  "version": "1"
}{
  "index": 4, 
  "message": "Hello, world!", 
  "service_id": "41cb6d1a-1aaa-4cf2-94d2-a7e93783b07d", 
  "version": "2"
}
```

And voila! Notice the third service queried is our new v2.0 service running alongside our v1.0 service and it's also
available from the same URL!