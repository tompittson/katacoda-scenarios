Containers run as root by default which means that if the application is exploited or the parent image contains malware it has full permission within the container and can write files to the host as the root user (container breakout).

Some platforms, such as OpenShift, prevent containers running as root and it is good practice to run as a non-root user.

In this step you are going to change the runtime image to use a non-root user. The files for this step are in the step4 directory.
## Add Non-root User

Change to the step4 directory `cd ~/step4`{{execute}}

Take a look at the new Dockerfile for the application `step4/Dockerfile`{{open}}

> A non-root user is added to the alpine image, see the comments prefixed [New] for details of the changes.

Build the container image `docker image build -t step4:multi-alpine .`{{execute}}

Run the application to check it still works `docker run --rm step4:multi-alpine`{{execute}}

> The output should now show the nonroot user details for UID, username, GID, group name and home.