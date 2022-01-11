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

# [New] make the /tmp part of the filesystem read-only
RUN chmod a-w /tmp

USER 1001:1001

CMD ["./app"]