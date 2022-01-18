In this step you are going to look at the often confused [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint) and [CMD](https://docs.docker.com/engine/reference/builder/#cmd) Dockerfile instructions.

The two instructions are confusing because on the face of it they are both used to define the executable and parameters for the main process to run in the container.

From the Dockerfile reference the ENTRYPOINT instruction has 2 forms:
1. `ENTRYPOINT ["executable", "param1", "param2"]` (***exec*** form, this is the preferred form)
1. `ENTRYPOINT command param1 param2` (***shell*** form)

From the Dockerfile reference the CMD instruction has 3 forms:
1. `CMD ["executable","param1","param2"]` (***exec*** form, this is the preferred form)
1. `CMD ["param1","param2"]` (as default parameters to ENTRYPOINT)
1. `CMD command param1 param2` (***shell*** form)

You will learn about the differences between *shell* and *exec* forms in the next step.

The Dockerfile reference has a good explanation of [how CMD and ENTRYPOINT interact](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact). This step will guide you through examples of the common ways that the two instructions are used.

> All of the examples will use the preferred *exec* form of the commands.

## Review Files

Change to the step3 directory `cd ~/step3`{{execute}}

Take a look at the Dockerfile for this step `step3/Dockerfile`{{open}}

> The Dockerfile installs a simple command line application called [cowsay](https://github.com/tnalpgge/rank-amateur-cowsay) which will be used to demonstrate the relationship between ENTRYPOINT and CMD.

> In the Dockerfile it includes just the CMD instruction and does not specify an ENTRYPOINT.

## Build CMD Image

Build the container image `nerdctl image build -t cowsay:cmd .`{{execute}}

> You are using nerdctl to build and run the containers in this step, this further demonstrates how the commands are almost identical to those used with the docker CLI. nerdctl is dependent on the [buildkit](https://github.com/moby/buildkit) daemon running to build the image.

## Run CMD Container

> The format of the run instruction in docker/nerdctl is `docker|nerdctl run [OPTIONS] IMAGE [COMMAND] [ARG...]`. As you can see the COMMAND and ARG parameters are optional.

Run the container just built `nerdctl run --rm cowsay:cmd`{{execute}}

> You can see the output is based on the executable and argument defined in the CMD instruction.

Run the container providing the command/args on the command line `nerdctl run --rm cowsay:cmd echo "Baaa!"`{{execute}}

> Passing the command on the command line has overwritten the CMD instruction in the Dockerfile.

## Build ENTRYPOINT Image

Update the Dockerfile to use the ENTRYPOINT instruction

<pre class="file" data-filename="step3/Dockerfile" data-target="replace">
FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games

# [New] changed CMD to ENTRYPOINT
ENTRYPOINT [ "cowsay", "Mooo!" ]
</pre>

Build the container image `nerdctl image build -t cowsay:entrypoint .`{{execute}}

## Run ENTRYPOINT Image

Run the container just built `nerdctl run --rm cowsay:entrypoint`{{execute}}

> The output is identical to running the CMD based image with no command/args on the command line.

Run the container providing the command/args on the command line `nerdctl run --rm cowsay:entrypoint echo "Baaa!"`{{execute}}

> Passing the command/args on the command line has added those to the executable and arg already defined in the ENTRYPOINT in the Dockerfile. This demonstrates the key difference between the two instructions.

## Update ENTRYPOINT Image

Typically the two instructions are used as follows:
* **ENTRYPOINT**: The executable to run when the container starts.
* **CMD**: The *default* arguments to the executable defined in ENTRYPOINT.

Update the Dockerfile to remove the argument defined in the ENTRYPOINT instruction

<pre class="file" data-filename="step3/Dockerfile" data-target="replace">
FROM ubuntu:18.04

# install cowsay
RUN apt-get update \
    && apt-get install -y cowsay=3.03+dfsg2-4 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# "cowsay" installs to /usr/games
ENV PATH=$PATH:/usr/games

# [New] Removed "Mooo!" argument from the ENTRYPOINT
ENTRYPOINT [ "cowsay" ]

# [New] Added default arguments in CMD
CMD [ "Mooo!" ]
</pre>

Build the container image `nerdctl image build -t cowsay:entrypoint2 .`{{execute}}

## Run ENTRYPOINT Image

Run the container just built `nerdctl run --rm cowsay:entrypoint2`{{execute}}

> The output is the same as before.

Run the container providing the *version* arg `nerdctl run --rm cowsay:entrypoint2 --help`{{execute}}

> You now have full control over the arguments passed to the executable. The cowsay page on Wikipedia has a detailed list of the [command line options](https://en.wikipedia.org/wiki/Cowsay).

Run the container again with different args `nerdctl run --rm cowsay:entrypoint2 -f sheep "Baaa!"`{{execute}}