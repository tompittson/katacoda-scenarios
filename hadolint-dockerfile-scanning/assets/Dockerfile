FROM alpine

USER root
RUN apk update && \
    apk add curl

ENTRYPOINT [ "curl" ]