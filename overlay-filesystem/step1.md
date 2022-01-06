In this step we will create the individual directories and files that will later be combined into our union (overlay) filesystem.

## Directories

Create a directory called overlay `mkdir overlay`{{execute}}

The **overlay** directory will be the one that contains the union of all the directories we create.

Create the directories for the individual layers `mkdir layer1 layer2 layer3 read-write-layer`{{execute}}

Finally create a directory called workdir which is needed by the overlay filsystem `mkdir workdir`{{execute}}

Check the directories `ls`{{execute}}

>The directories have been named to make it easier to understand the scenario, the names can be changed to any other allowed values. In container images they are usually named based on the hash of the layer.

## Files

Create a file in each of the layers:

```sh
echo 'Layer 1' >>layer1/file-in-layer-1
echo 'Layer 2' >>layer1/file-in-layer-2
echo 'Layer 3' >>layer1/file-in-layer-3
```{{execute}}

## Mount Filesystem

Overlay filesystems (also called union filesystems) allow creating a union of two or more directories: a list of lower directories and an upper directory. The lower directories of the filesystem are read only, whereas the upper directory can be used for both reads and writes.

Mount the filesystem using the directories created in the previous step:

```sh
sudo mount -t overlay overlay-example \
-o lowerdir=/root/layer1:/root/layer2:/root/layer3,upperdir=/root/read-write-layer,workdir=/root/workdir \
/root/mount
```{{execute}}


