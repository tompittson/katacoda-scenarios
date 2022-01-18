In linux PID 1 is also known as the init process and it has some additional responsibilties one of which is zombie PID reaping. For more information about this and why it can be a problem in containers see this [blog post](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/).

## Create Image

Change to the step2 directory `cd ~/step5`{{execute}}

Take a look at the C application `step5/zombie.c`{{open}}

> This is a simple application which spawns multiple zombie processes.

Take a look at the Dockerfile for the application `step5/Dockerfile`{{open}}

> The application uses a multi-stage build to compile the application and then copy it to the runtime image.

Build the container image `docker image build -t zombie:test .`{{execute}}

## Test Zombies

Run the container `docker run --rm -d --name zombie zombie:test`{{execute}}

Execute the zombie application within the container `docker exec zombie /app/zombie`{{execute T2}}

View the zombie processes created `ps -ef | grep zombie | grep -v grep`{{execute T1}}

> These steps attempted to re-create the issue described in the blog post but you will notice that once the parent process exits the zombies dissapear so they must have been reaped some how. Looking into the code for the containerd-shim it looks like this is now handled by the container runtime [https://github.com/containerd/containerd/blob/main/cmd/containerd-shim/shim_linux.go#L29].