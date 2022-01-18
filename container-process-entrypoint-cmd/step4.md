The previous step you explored the ENTRYPOINT and CMD instructions. You used the ***exec*** form of the two instructions but there is also an alternate ***shell*** form which you will look at in this step.

There are actually three instructions that can be defined in both *shell* and *exec* forms, CMD, ENTRYPOINT and [RUN](https://docs.docker.com/engine/reference/builder/#run). This step will not look at the RUN instruction but it is worth noting that unlike [CMD](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#cmd) and [ENTRYPOINT](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#entrypoint) the preferred form for [RUN](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run) is the *shell* form.

## Build Image

Change to the step4 directory `cd ~/step4`{{execute}}

Take a look at the new Dockerfile for the application `step4/Dockerfile`{{open}}

> This is the same image as the previous step but the CMD is in the *shell* form and an environment variable is used to set the message.

Build the container image `docker image build -t cowsay:cmd-shell .`{{execute}}

## Run Shell CMD Container

Run the application to check it works `docker run --rm cowsay:cmd-shell`{{execute}}

> Using the *shell* form means you can use environment variable expansion which does not work in the *exec* form by default. The equivilent command in *exec* form would be `CMD [ "sh", "-c", "cowsay $MESSAGE" ]`.

## Shell CMD and PID 1

Update the Dockerfile to change the CMD instruction to execute `sleep 20`

<pre class="file" data-filename="step4/Dockerfile" data-target="replace">
FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games

# [New] changed CMD sleep instead of cowsay
CMD sleep 20
</pre>

Build the container image `docker image build -t cowsay:cmd-shell .`{{execute}}

Run a container based on the new image `docker run --rm -d --name cow-sleep cowsay:cmd-shell`{{execute}}

Look at the processes in the container `docker exec cow-sleep ps -ef`{{execute}}

> Using the *shell* form the main process (PID 1) is /bin/sh. This demonstrates how the shell form can prevent a container from responding to the stop signals properly.

## Shell ENTRYPOINT and CMD

Change the Dockerfile so that ENTRYPOINT and CMD are used both in the *shell* forms

<pre class="file" data-filename="step4/Dockerfile" data-target="replace">
FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games

# [New] changed CMD sleep instead of cowsay
ENTRYPOINT sleep
CMD 20
</pre>

Build the container image `docker image build -t cowsay:entrypoint-shell .`{{execute}}

Run a container based on the new image `docker run --rm cowsay:entrypoint-shell`{{execute}}

> When using ENTRYPOINT in the *shell* form the CMD instruction is ignored.

## Shell ENTRYPOINT

Change the Dockerfile so that only the ENTRYPOINT is used in *shell* form

<pre class="file" data-filename="step4/Dockerfile" data-target="replace">
FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games

# [New] changed CMD sleep instead of cowsay
ENTRYPOINT sleep 300
</pre>

Build the container image `docker image build -t cowsay:entrypoint-shell .`{{execute}}

Run a container based on the new image `docker run --rm -d --name cow-sleep cowsay:entrypoint-shell`{{execute}}

Look at the processes in the container `docker exec cow-sleep ps -ef`{{execute}}

> Again, using the *shell* form the main process (PID 1) is /bin/sh. This causes the same PID 1 problem.

Stop the container `docker stop cow-sleep`{{execute}}

> The container does not stop cleanly and is killed (SIGKILL) after the default 10s timeout.

## Exec ENTRYPOINT Comparison

Change the Dockerfile so that the ENTRYPOINT is used in *exec* form to see how this compares to the previous container image that used the *shell* form

<pre class="file" data-filename="step4/Dockerfile" data-target="replace">
FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games

# [New] changed CMD sleep instead of cowsay
ENTRYPOINT [ "sleep", "20" ]
</pre>

Build the container image `docker image build -t cowsay:entrypoint-exec .`{{execute}}

Run a container based on the new image `docker run --rm -d --name cow-sleep cowsay:entrypoint-exec`{{execute}}

Look at the processes in the container `docker exec cow-sleep ps -ef`{{execute}}

> Using the *exec* form the main process (PID 1) is sleep.