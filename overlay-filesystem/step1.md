In this step we will create the individual directories and files that will be combined into our union (overlay) filesystem. We will then mount that filesystem ready for the next step.

## Directories

Create a directory called **mount** `mkdir mount`{{execute}}

The **mount** directory will be the one that contains the union of all the directories we create.

Create the directories that represent the individual layers `mkdir layer1 layer2 layer3 read-write-layer`{{execute}}

Finally create a directory called **workdir** which is needed by the overlay filsystem `mkdir workdir`{{execute}}

Check the directories `ls`{{execute}}

>The directories have been named to make it easier to understand the scenario, the names can be changed to any other allowed values. In container images they are usually named based on the hash of the layer.

## Files

Create a file in each of the layers:

```sh
echo 'Layer 1' >>layer1/file-in-layer-1
echo 'Layer 2' >>layer2/file-in-layer-2
echo 'Layer 3' >>layer3/file-in-layer-3
```{{execute}}

Check the files `ls -R`{{execute}}

## Mount Filesystem

Overlay filesystems are created from a union of two or more directories. They are defined from a list of **lower** directories and an **upper** directory. The lower directories of the filesystem are read-only, whereas the upper directory is read-write. The lower directories are applied in **reverse** order to create the final filesystem visible in the mount, so the first directory in the list has the highest precedence and can change the files from previous directories (or layers).

Mount the filesystem using the directories created in the previous step:

```sh
mount -t overlay overlay-example \
-o lowerdir=/root/layer3:/root/layer2:/root/layer1,upperdir=/root/read-write-layer,workdir=/root/workdir \
/root/mount
```{{execute}}

Check the filesystem has been mounted as expected `ls -al mount`{{execute}}

> You should see the three different files from the separate layer1..3 directories all listed in the mount directory.
