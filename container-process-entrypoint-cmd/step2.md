In this step you are going to look at the importance of PID 1 in a container and how a pod is terminated.

## PID 1

In the previous step you saw that within the container the initial process has PID 1. The container lifetime is based on this process and when it terminates the container also stops. You can see this in action using the commands below.

Open a second terminal window `echo "Terminal 2"`{{execute T2}}

Run a container that will sleep for 10s `docker run -d --name docker-sleep-10s busybox sleep 10`{{execute T1}}

Watch the containers running on the host `watch -d docker ps -a`{{execute T2}}

> You can see the container start and then terminate once the sleep has finished.

The container will also stop if the PID 1 process is terminated using a signal

Start another container with a longer sleep `docker run -d --name docker-sleep busybox sleep infinity`{{execute T1}}

Check the container is running `docker ps -a`{{execute T1}}

View the process tree of the container on the host `pstree -Ssp $(docker inspect --format '{{.State.Pid}}' docker-sleep)`{{execute T1}}

Send a SIGKILL signal to the process on the host `kill -9 $(docker inspect --format '{{.State.Pid}}' docker-sleep)`{{execute T1}}

Check the status of the container `docker ps -a`{{execute T1}}

> The container has exited because the main process has terminated.

## Termination Signals

> A process running as PID 1 inside a container is treated specially by Linux: it ignores any signal with the default action. As a result, the process will not terminate on SIGINT or SIGTERM unless it is coded to do so - from [Docker documentation](https://docs.docker.com/engine/reference/run/#foreground).

Run another container with a sleep command `docker run -d --rm --name docker-sleep-infinity busybox sleep infinity`{{execute}}

Stop the container (using the time command to see how long it takes) `time docker stop docker-sleep-infinity`{{execute}}

> It takes over 10s! This is because the sleep command does not respond to the SIGTERM signal and the container does not stop until the grace period is over and a SIGKILL signal is sent to the process. This demonstrates why it is important that the main process in a container responds correctly to the termination signals. Imagine the scenario where the application is in the middle of a write operation to a file and it is suddenly killed.

Run the container again this time with an init process that correctly responds to the signals `docker run -d --init --rm --name docker-sleep-infinity busybox sleep infinity`{{execute}}

> The **--init** flag wraps the main container process in an init process. See the [Docker documentation](docker run -d --rm --name docker-sleep-infinity busybox sleep infinity) for more information. Docker uses [tini](https://github.com/krallin/tini) for this, another alternative is [dumb-init](https://github.com/Yelp/dumb-init).

You can see the init process in action by looking at the processes within the container `docker exec docker-sleep-infinity ps -ef`{{execute}}

Stop the container `time docker stop docker-sleep-infinity`{{execute}}

> The container stops much more quickly this time without the 10s grace period timeout.

> The **--init** flag is specific to Docker and is not available in other container engines such as the Kubernetes kubelet. There is an outstanding [issue](https://github.com/kubernetes/kubernetes/issues/84210 ) in Kubernetes to add this functionality but it doesn't look like this will be implemented any time soon, if ever. The current approach is to ensure your application responds correctly to signals or use an init wrapper such as tini or dumb-init.