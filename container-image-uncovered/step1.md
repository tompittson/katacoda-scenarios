Crane, a tool for working with container images, has been pre-installed into the environment. For more information visit <https://github.com/google/go-containerregistry/tree/main/cmd/crane>

Validate the install with the command `crane help`{{execute}}.

## Download Image

In this example we are using the [redis image](https://hub.docker.com/_/redis) but the same steps can be performed on any image.

Pull the image `crane pull --format oci --platform linux/amd64 redis:6.2@sha256:563888f63149e3959860264a1202ef9a644f44ed6c24d5c7392f9e2262bd3553 redis`{{execute}}

The command above creates a directory containing all the image files in the [OCI](https://github.com/opencontainers/image-spec/blob/main/spec.md) layout format.

View the pulled image files from the tar `ls -alR redis`{{execute}}

View the **oci-layout** file contents `cat redis/oci-layout`{{execute}}

View the **index.json** file contents `cat redis/index.json | jq`{{execute}}

The index.json file points at the manifest file which is one of the blobs downloaded.

View the manifest file `cat redis/blobs/sha256/563888f63149e3959860264a1202ef9a644f44ed6c24d5c7392f9e2262bd3553 | jq`{{execute}}

We now have a list of the image layers and also a reference to the config which is stored in another blob.

View the config file `cat redis/blobs/sha256/7614ae9453d1d87e740a2056257a6de7135c84037c367e1fffa92ae922784631 | jq`{{execute}}

> Note the history stored in the config, this shows all of the different layers, many of these are empty layers which do not modify the filesystem but instead contain metadata which when built from a Dockerfile set the configuration of the container at runtime.


