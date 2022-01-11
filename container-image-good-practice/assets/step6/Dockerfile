# build image
FROM golang:1.17.6 as builder

WORKDIR /go/src/app
COPY main.go .

ENV GO111MODULE=auto \
    GOOS=linux \
    CGO_ENABLED=0

RUN go build -o app .

# [New] using base nonroot image as the second stage image
# already includes nonroot user - nobody:nobody, uid:gid = 65534:65534
FROM gcr.io/distroless/base-debian11:nonroot

WORKDIR /
COPY --from=builder --chown=nobody:nobody /go/src/app/app .

# use the built-in non-root user and group
USER 65534:65534

CMD ["./app"]