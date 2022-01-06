#!/bin/bash

echo "done" >> /root/katacoda-finished

echo "Downloading crane"
mkdir /tmp/crane
curl -L https://github.com/google/go-containerregistry/releases/download/v0.8.0/go-containerregistry_Linux_x86_64.tar.gz \
  -o /tmp/crane/go-containerregistry.tar.gz
tar -xvf /tmp/crane/go-containerregistry.tar.gz -C /tmp/crane/
mv /tmp/crane/crane /usr/bin
rm -rf /tmp/crane/go-containerregistry.tar.gz
rm -rf /tmp/crane

echo "done" >> /root/katacoda-background-finished
