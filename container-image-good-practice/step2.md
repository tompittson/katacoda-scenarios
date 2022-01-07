In this step you are going to create an image for a simple go application. The files for this step are in the step2 directory.

## Create Image

Change to the step2 directory `cd ~/step2`{{execute}}

Take a look at the go application `~/step2/main.go`{{open}}

> This is a simple application which outputs some information about the running container.

Take a look at the Dockerfile for the application `~/step2/Dockerfile`{{open}}

> The application is built as part of the container build.

Build the container image `docker image build -t step2:normal .`{{execute}}

## Check Image

Run the application

```bash
docker run --rm step2:normal
```

Check the image size

```bash
docker image ls step2:normal
```

> Over 800MB for a simple Go application! The problem is that the base image we are using includes all the sdk for building go applications, we don't need that to run our application.

## Multi-stage Builds

[Multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/) allow you to split your Dockerfile into different stages using multiple FROM statements. Only the last stagein the Dockerfile is included in the final image. This enables you to build the go application in the first stage and then copy the output of the build into a much smaller image in the final stage.

Update the Dockerfile to use a multi-stage build

<pre class="file" data-filename="~/step2/Dockerfile" data-target="replace">
# build image
FROM golang as builder

WORKDIR /go/src/app
COPY main.go .

ENV GO111MODULE=auto \
    GOOS=linux \
    CGO_ENABLED=0

RUN go build -o app .

# Runtime image
FROM alpine:3.14

RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/app/app .

CMD ["./app"]
</pre>

Build the new image `docker image build -t step2:multi-alpine .`{{execute}}

Run the new image to make sure it still works `docker run --rm step2:multi-alpine`{{execute}}

Check the new image size `docker image ls step2:multi-alpine`

> Less than 10MB, a significant improvement from the previous image.