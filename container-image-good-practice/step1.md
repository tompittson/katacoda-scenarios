In this step we will compare the size of different flavours of the same image.

## Image Pull

Pull the nginx images we are going to use in the comparison

```
docker image pull nginx:1.20.2
docker image pull nginx:1.20.2-alpine
```{{execute}}

Now pull the base alpine image

```
docker image pull alpine:3.14
```{{execute}}

> Check the output for the last command, the image layer already exists, do you know why?

## Compare Size

View the sizes of the different images `docker image ls | grep -E '(nginx|alpine)[ ]+[0-9].*'`{{execute}}

> The normal nginx image is based on Debian hence the big size difference. The alpine image is used as the base image for the nginx alpine variant.

## Inspect the Image

Use the **docker inspect** command to view information about the Debian based image `docker inspect nginx:1.20.2`{{execute}}

View the image history `docker history nginx:1.20.2 --no-trunc`{{execute}}

You can compare this with the [Dockerfile](https://github.com/nginxinc/docker-nginx/blob/b0e153a1b644ca8b2bd378b14913fff316e07cf2/stable/debian/Dockerfile) linked to by clicking the tag on [Docker Hub](https://hub.docker.com/_/nginx)

> Note that the history does not show the FROM instruction, it simply takes the layers from the parent image.