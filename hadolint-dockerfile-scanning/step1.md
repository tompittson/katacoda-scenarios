The Dockerfile we are using in this scenario should already be open in the editor. The purpose of the Dockerfile is to create a container image that can be used to run curl. The image is based on the [alpine](https://www.alpinelinux.org/) minimal linux distribution.

## Image Build

Build the image `docker image build -t curl .`{{execute}}

Test the image `docker run --rm curl --version`{{execute}}

## Hadolint Scan

Hadolint can be executed locally from the binary, as a Visual Studio Code extension or from a container image. In this example we will use Docker to run the latest vesion of hadolint from a container image.

Scan the Dockerfile `docker run --rm -i hadolint/hadolint < Dockerfile`{{execute}}

> Take a look at the output from hadolint, a number of issues have been highlighted that should be fixed. You can continue on to the next step to see the solution or try and fix them yourself by updating the Dockerfile and then re-running hadolint.
