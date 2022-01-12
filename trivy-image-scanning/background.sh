#!/bin/bash

echo "done" >> /root/katacoda-finished

echo "Installing trivy"
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | \
    sh -s -- -b /usr/local/bin

echo "Downloading the latest trivy database"
trivy image --download-db-only

echo "done" >> /root/katacoda-background-finished
