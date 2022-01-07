The Dockerfile we are using in this scenario should be listed in the editor. The purpose of the Dockerfile is to create a container image that can be used to run curl. The image is based on the [alpine](https://www.alpinelinux.org/) minimal linux distribution.

Open the Dockerfile in the editor `Dockerfile`{{open}}

> Take a look through the instructions defined. The main ones are adding curl using __apk add__ and setting the ENTRYPOINT so that curl is the default executable when the image runs as a container.

## Image Build

Build the image `docker image build -t curl .`{{execute}}

Test the image `docker run --rm curl --version`{{execute}}

## Hadolint Scan

Hadolint can be executed locally from the binary, as a Visual Studio Code extension, or from a container image. In this scenario we will use Docker to run the latest vesion of hadolint from a container image.

Scan the Dockerfile `docker run --rm -i hadolint/hadolint < Dockerfile`{{execute}}

> Take a look at the output from hadolint, a number of issues have been highlighted that should be fixed. You can continue on to the next step to see the solution or try and fix them yourself by updating the Dockerfile and then re-running hadolint.
