In this scenario, you will step through some of the good practice you can follow when creating container images such as minimising size, multi-stage builds, version pinning, running as non-root and image hardening.

Using a minimal container parent image is a good practice as it decreases the attack surface for your own containers. With less libraries in the image, it also reduces the frequency in which the image needs to be patched or updated. The runtime image should only include the packages that are necessary to run the application. When choosing a parent image, note how well maintained the image is and its default installed software. Choose official images where possible and go for the most minimal image that satisfies the needs of the application.

## Useful Information

In the Dockerfile
- The FROM command imports all the layers from the parent image
- Only RUN, COPY, ADD commands create new layers - other instructions are metadata