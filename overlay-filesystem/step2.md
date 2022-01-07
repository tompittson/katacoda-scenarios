Now that we have created our overlay filesystem lets see what happens when we add, edit or delete files in the upper (read-write) directory.

## Add File

Create file in the mount directory `echo 'File in mount directory' >>mount/file-in-rw-layer`{{execute}}

Lets look at the changed filesystem `ls -R`{{execute}}

> Notice that the **file-in-rw-layer** appears in both the read-write-layer directory and the mount directory.

## Edit File

Lets see what happens when we modify a file created in one of the lower (read-only) directories.

First check the contents of **file-in-layer-1** `cat mount/file-in-layer-1`{{execute}}

Now add some content to the file `echo 'I have been changed' >>mount/file-in-layer-1`{{execute}}

Now check the contents again `cat mount/file-in-layer-1`{{execute}}

We can see that the file has been updated but what about the file in the layer1 directory? `cat layer1/file-in-layer-1`{{execute}}

Lets look at the changed filesystem again `ls -R`{{execute}}

> The file in layer1 is still unmodified, you will notice that now there is a file with the same name in the read-write-layer and that is the one that has been modified and you see under the mount directory.

## Delete File

Delete the file from layer2 and see what happens `rm mount/file-in-layer-2`{{execute}}

Lets look at the changed filesystem `ls -R`{{execute}}

> The file has gone from the mount directory but it still exists in the layer2 directory. It is also in the read-write-layer directory as well.

Lets take a closer look at the new file in the read-write-layer `ls -al read-write-layer/file-in-layer-2`{{execute}}

> A character file has been created in the read-write layer. This kind of file is called a "whiteout" file and is how the overlay filesystem represents a file being deleted.