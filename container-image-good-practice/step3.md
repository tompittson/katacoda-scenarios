Most repositories allow mutable tags so you can't guarantee that using the same tag on a pull will result in the same image being downloaded.

In this step you are going to pin the versions of the images used to ensure repeatable image builds. The files for this step are in the step3 directory.

## Create Image

Change to the step3 directory `cd ~/step3`{{execute}}

Take a look at the new Dockerfile for the application `step3/Dockerfile`{{open}}

> The application is built as part of the container build.

Build the container image `docker image build -t step3:multi-alpine .`{{execute}}

Run the application to check it still works `docker run --rm step3:multi-alpine`{{execute}}

## Base Image Digests

> Although we are using tags for both base images in the Dockerfile these tags are mutable and the underlying image may be changed. You can reference the image using the digest as well which gives more assurance that the same image is being used for every build.

Pull the two base images used (all the layers should already exist)

```
docker image pull golang:1.17.6
docker image pull alpine:3.14
```{{execute}}

The digest is shown at the end of the pull output, alternatively we can inspect the images to find the digest values

```
docker image inspect golang:1.17.6 | grep -A1 RepoDigests
docker image inspect alpine:3.14 | grep -A1 RepoDigests
```{{execute}}

## Update Dockerfile

Update the Dockerfile to reference the base images using the image digests

> Note: You may need to modify the digest values to match those output in the previous command.

<pre class="file" data-filename="step3/Dockerfile" data-target="replace">
# build image
FROM golang:1.17.6@sha256:d36ec9839e6ebac63a53f3e15758ffa339b81dc5df6c9d41a18a3f9302bd0d90 as builder

WORKDIR /go/src/app
COPY main.go .

ENV GO111MODULE=auto \
    GOOS=linux \
    CGO_ENABLED=0

RUN go build -o app .

# Runtime image
FROM alpine:3.14@sha256:635f0aa53d99017b38d1a0aa5b2082f7812b03e3cdb299103fe77b5c8a07f1d2

RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/app/app .

CMD ["./app"]
</pre>

Re-build the image `docker image build -t step3:multi-alpine .`{{execute}}

> The image should build very quickly because the cache is being used as nothing has changed from the previous build.

Run the new image to make sure it still works `docker run --rm step3:multi-alpine`{{execute}}