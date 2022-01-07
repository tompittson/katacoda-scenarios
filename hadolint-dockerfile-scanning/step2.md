An updated Dockerfile is listed below which contains the fixes to the issues highlighted by hadolint. See the comments in the file for an explanation of the changes.

## Updated Dockerfile

<pre class="file" data-filename="Dockerfile" data-target="replace">
# specify the version of the alpine base image
FROM alpine:3.13

USER root

# add the nonroot user
RUN addgroup -S -g 1001 nonroot \
    && adduser -S -h /home/nonroot -G nonroot -u 1001 nonroot

# add --no-cache flag (removes the need to apk update and rm /var/cache/apk/*)
# specify the curl version
RUN apk add --no-cache curl=7.74.0-r1

# specify the nonroot user
USER 1001:1001

ENTRYPOINT [ "curl" ]
</pre>

## Test Changes

Build the image `docker image build -t curl .`{{execute}}

Test the image `docker run --rm curl --version`{{execute}}

## Hadolint Scan

Scan the Dockerfile `docker run --rm -i hadolint/hadolint < Dockerfile`{{execute}}

> Success, we have fixed the issues and created a more secure container image that follows recommended good practice.