We have looked at what happens if we change files in the read-write layer. We will now take a look at what happens when the lower directories change files from previous layers.

## Unmount

Unmount the overlay filesystem used in the previous step `umount mount`{{execute}}

Remove the file create in the previous step `rm read-write-layer/file-in-rw-layer`{{execute}}

Rename the read-write-layer directory to layer4 `mv read-write-layer layer4`{{execute}}

Create a new read-write-layer directory `mkdir read-write-layer`{{execute}}

Check the filesystem `ls -R`{{execute}}

> We now have 4 lower directories representing the read-only layers, in layer4 we have a modification to the file in layer1 and a deletion of the file in layer2.

## Mount

Mount the overlay filesystem again this time with the 4 lower directories:

```
mount -t overlay overlay-example \
-o lowerdir=/root/layer4:/root/layer3:/root/layer2:/root/layer1,upperdir=/root/read-write-layer,workdir=/root/workdir \
/root/mount
```{{execute}}

## Examine Filesystem

Check the contents of **file-in-layer-1** `cat mount/file-in-layer-1`{{execute}}

> This file contains the change we expected to see from layer 4

Look at the filesystem `ls -lR`{{execute}}

> The file deleted in layer4 is not in the mount directory, as before it is still present in layer1 though. This is an important concept to understand as it shows that in your container images every layer adds to the container size as a whole even if you are deleting files from a previous layer. Also if files in a previous layer contain sensitive information they can still be read even though they are not visible in the union file system of the container.

## Sharing Layers

One of the great things about container images and their use of the union file system is that read-only layers can be shared between different images. E.g. if you have lots of applications that use the same base image it is only the delta specific to each application that needs to be downloaded when running on the same host.

Lets see an example of this.

Create a second mount, read-write-layer and layer4 directory that we will use to simulate our second container instance `mkdir mount-b read-write-layer-b layer4-b`{{execute}}

Create a new mount using the new directories as well as the original layer1..3:

```
mount -t overlay overlay-example \
-o lowerdir=/root/layer4-b:/root/layer3:/root/layer2:/root/layer1,upperdir=/root/read-write-layer-b,workdir=/root/workdir \
/root/mount-b
```{{execute}}

Make a change in the mount-b directory `echo 'Mount-b file' >>mount-b/file-in-mount-b-rw-layer`{{execute}}

Now lets take a look at the filesystem `ls -lR`{{execute}}

> Sharing the same layer1..3 we can see that in mount-b we can't see any of the changes in layer4 and in mount we can't see the file just created in mount-b. This demonstrates how in running containers layers can be shared but we also have isolation between the read-write layers.