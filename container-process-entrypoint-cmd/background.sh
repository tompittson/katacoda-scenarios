#!/bin/bash

echo "done" >> /root/katacoda-finished

echo "Installing nerdctl"
mkdir /tmp/nerdctl
curl -L https://github.com/containerd/nerdctl/releases/download/v0.16.0/nerdctl-full-0.16.0-linux-amd64.tar.gz \
  -o /tmp/nerdctl/nerdctl-full.tar.gz
tar Cxzvvf /usr/ /tmp/nerdctl/nerdctl-full.tar.gz --no-overwrite-dir
rm -rf /tmp/nerdctl/nerdctl-full.tar.gz
rm -rf /tmp/nerdctl

echo "Resetting containerd"
systemctl stop containerd
systemctl disable containerd
systemctl daemon-reload
systemctl reset-failed
systemctl enable --now containerd

echo "Restart docker after updating containerd"
systemctl restart docker

echo "Enable buildkit"
cp /usr/bin/buildkitd /usr/local/bin/buildkitd
systemctl enable --now buildkit

echo "done" >> /root/katacoda-background-finished
