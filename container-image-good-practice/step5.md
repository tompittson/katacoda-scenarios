To further harden the running container you can make some changes to the contents of the image filesystem.

In this step you are going to change part of the filesystem to be read-only and then remove the shell from the image to prevent running commands in the container.

## Execute an interactive shell in the container

Run the image from the previous step with an interactive shell `docker run --rm -it step4:multi-alpine sh`{{execute}}

> Using the command above you can execute arbitrary commands in a running container. You can also **exec** into running containers using a similar command and start additional processes that could potentially be used as exploits by a hacker.

Create a new file `echo "File created" >> /tmp/test-file`{{execute}}

Check the new file `cat /tmp/test-file`{{execute}}

Exit the container `exit`{{execute}}

## Read-only filesystem

Change to the step5 directory `cd ~/step5`{{execute}}

Take a look at the new Dockerfile for the application `step5/Dockerfile`{{open}}

> The line below has been added which removes write permission from the /tmp directory.

```
RUN chmod a-w /tmp
```

Build the container image `docker image build -t step5:multi-alpine-read-only .`{{execute}}

Run the application to check it still works `docker run --rm step5:multi-alpine-read-only`{{execute}}

Run the image with an interactive shell `docker run --rm -it step5:multi-alpine-read-only sh`{{execute}}

Create a file in the /tmp directory `echo "File created" >> /tmp/test-file`{{execute}}

> This will no longer work (Permission denied)

Exit the container `exit`{{execute}}

## Remove the shell

You will now update the Dockerfile to remove the shell from the runtime image

<pre class="file" data-filename="step5/Dockerfile" data-target="replace">
# build image
FROM golang:1.17.6 as builder

WORKDIR /go/src/app
COPY main.go .

ENV GO111MODULE=auto \
    GOOS=linux \
    CGO_ENABLED=0

RUN go build -o app .

# Runtime image
FROM alpine:3.14

RUN addgroup -S -g 1001 nonroot \
    && adduser -S -h /home/nonroot -G nonroot -u 1001 nonroot

RUN apk --no-cache add ca-certificates
WORKDIR /home/nonroot
COPY --from=builder --chown=nonroot:nonroot /go/src/app/app .

# [New] remove the shell
RUN rm -rf /bin/*

USER 1001:1001

CMD ["./app"]
</pre>

> The line below has been added which deletes the contents of the /bin/ directory

```
RUN rm -rf /bin/*
```

Build the container image `docker image build -t step5:multi-alpine-no-shell .`{{execute}}

Run the application to check it still works `docker run --rm step5:multi-alpine-no-shell`{{execute}}

Try to run the image with an interactive shell like before `docker run --rm -it step5:multi-alpine-no-shell sh`{{execute}}

> This will not work (executable file not found in $PATH: unknown)

Check the size of the new image `docker image ls | grep step5`{{execute}}

> Even though the /bin directory has been emptied the image size has not been reduced because the /bin directory still exists in previous layers of the union filesystem.