In the previous step you looked at how to harden an alpine image by removing the shell. However, there is a better approach, which is to use a distroless parent image to further reduce the attack surface and also potentially reduce the size of the image.

In this step you will use a google distroless image and a scratch image as the base for the application runtime image to better understand the pros and cons of the distroless approach.

## Distroless

Change to the step6 directory `cd ~/step6`{{execute}}

Take a look at the new Dockerfile for the application `step6/Dockerfile`{{open}}

> The second stage in the multi-stage build has changed significantly now we are using a different parent image.

```
FROM gcr.io/distroless/base-debian11:nonroot
```

Build the container image `docker image build -t step6:multi-distroless .`{{execute}}

Run the application to check it still works `docker run --rm step6:multi-distroless`{{execute}}

Compare the output to previous step image `docker run --rm step5:multi-alpine`{{execute}}

> The username, group, home, uid, gid and environment variables have all changed.

Try to run the image with an interactive shell (this will fail) `docker run --rm -it step6:multi-distroless sh`{{execute}}

View the size of the different images `docker image ls | grep -E '(step6|step5)'`{{execute}}

> Interestingly the image size is bigger than an alpine image. Google distroless images are [based on debian](https://github.com/GoogleContainerTools/distroless#base-operating-system) and built using [bazel](https://bazel.build/), the image build files can be [viewed on GitHub](https://github.com/GoogleContainerTools/distroless/blob/main/base/BUILD) to see what they contain.

## Scratch

A [scratch image](https://docs.docker.com/develop/develop-images/baseimages/#create-a-simple-parent-image-using-scratch) is a special reserved parent image name that is used to signify that you are starting with a completely empty image that contains nothing.

Scratch images are typically used to create base images for a particular distro (e.g. debian, alpine, ubuntu) but they can also be used to create very minimal images that just contain a binary and its dependencies, the Docker [hello-world image](https://hub.docker.com/_/hello-world/) is one example of this.

Update the Dockerfile to use a scratch base image

<pre class="file" data-filename="step6/Dockerfile" data-target="replace">
# build image
FROM golang:1.17.6 as builder

# [New] add non-root user that can be used in the scratch image
RUN groupadd --system -g 1001 nonroot \
    && useradd --system -g 1001 -u 1001 nonroot

WORKDIR /go/src/app
COPY main.go .

ENV GO111MODULE=auto \
    GOOS=linux \
    CGO_ENABLED=0

RUN go build -o app .

CMD ["./app"]

# [New] using a scratch image as the base
FROM scratch

# [New] the nonroot user is added by copying the passwd file from the builder
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder /go/src/app/app .

USER 1001:1001

CMD ["./app"]
</pre>

> Like the distroless image the scratch based image has no shell which means you cannot **RUN** any commands in the Dockerfile (e.g. to create a non-root user). To get round this limitation you can execute the commands in a previous stage and then copy the relevant files over as shown. 

Build the container image `docker image build -t step6:multi-scratch .`{{execute}}

Run the application to check it still works `docker run --rm step6:multi-scratch`{{execute}}

Try to run the image with an interactive shell (this will fail) `docker run --rm -it step6:multi-scratch sh`{{execute}}

View the size of the different images `docker image ls | grep -E '(step6|step5)'`{{execute}}

> The scratch image is the smallest possible image you could create and has no additional files other than the compiled application, the /etc/passwd and the /etc/group files.