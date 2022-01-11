To further harden the running container you can make some changes to the contents of the image filesystem.

In this step you are going to remove the shell from the image to prevent running commands in the container.

## Execute an interactive shell in the container

Run the image from the previous step with an interactive shell `docker run --rm -it step4:multi-alpine sh`

> Using the command above you can execute arbitrary commands in a running container. You can also **exec** into running containers using a similar command and start additional processes that could potentially be used as exploits by a hacker.

## Remove the shell

Change to the step5 directory `cd ~/step5`{{execute}}

Take a look at the new Dockerfile for the application `step5/Dockerfile`{{open}}

> The line below has been added which deletes the contents of the /bin/ directory

```
RUN rm -rf /bin/*
```

Build the container image `docker image build -t step5:multi-alpine .`{{execute}}

Run the application to check it still works `docker run --rm step5:multi-alpine`{{execute}}

Try to run the image with an interactive shell like before `docker run --rm -it step5:multi-alpine sh`

> This will not work (executable file not found in $PATH)