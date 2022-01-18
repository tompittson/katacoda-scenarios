In this step you will look at 2 different CLIs for running containers. The environment should already have both the docker and [nerdctl](https://github.com/containerd/nerdctl) CLIs installed.

**nerdctl** is a docker compatible CLI for interacting directly with containerd to manage containers. 

## Check CLIs

Check the docker cli `docker version`{{execute}}

Check the nerdctl cli `nerdctl version`{{execute}}

> Note that both nerdctl and docker are using the same version of containerd.

## Running Containers

Start a container using docker `docker run --rm -d --name docker-sleep busybox sleep 10000`{{execute}}

> The command above starts a container in the background (-d) running a sleep command (sleep 10000). The container will be automatically deleted once stopped (--rm).

List the running container `docker ps`{{execute}}

Start another container using nerdctl `nerdctl run -d --name nerdctl-sleep busybox sleep 99999`{{execute}}

> Note that the command line options and structure are the same as the docker CLI making it easy to switch between the two clients. However, not everything is the same, if you add the --rm flag the command errors because nerdctl doesn't allow you to pass --rm and -d at the same time for some reason.

## Inspect the Processes

List the processes from inside the docker container `docker exec docker-sleep ps aux`{{execute}}

And inside the nerdctl container `nerdctl exec nerdctl-sleep ps aux`{{execute}}

> Both commands should have almost identical output. Note that the sleep commands are PID 1 from within the container.

Use the **docker top** command to view the processes in the container `docker top docker-sleep`{{execute}}

Do the same using **nerdctl top** `nerdctl top nerdctl-sleep`{{execute}}

> These commands show the sleep processes again but include a PID and PPID (Parent Process ID) that are not PID 1. These process IDs are those allocated by the host as you can see using the commands below.

View the process tree of the docker container on the host `pstree -Ssp $(docker inspect --format '{{.State.Pid}}' docker-sleep)`{{execute}}

View the process tree of the nerdctl container on the host `pstree -Ssp $(nerdctl inspect --format '{{.State.Pid}}' nerdctl-sleep)`{{execute}}

> This shows that processes running in containers are also visible on the host machine. See this [blog post](https://iximiuz.com/en/posts/implementing-container-runtime-shim/) for more information about shims.

# Clean-up

Remove the two containers created in this step

```
docker stop -t 0 docker-sleep
nerdctl stop -t 0 nerdctl-sleep
nerdctl rm nerdctl-sleep
```{{execute}}