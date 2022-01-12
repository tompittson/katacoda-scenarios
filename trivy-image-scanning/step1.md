Scan a local image using the [Trivy](https://aquasecurity.github.io/trivy/) image scanner. The latest version of the trivy command line should already be included in the environment.

## Trivy Version

Check the trivy command line exists `trivy --help`{{execute}}

## Scan Old Image

Pull an image locally `docker image pull nginx:1.8-alpine`{{execute}}

Scan the image using trivy `trivy image --severity "HIGH,CRITICAL" nginx:1.8-alpine`{{execute}}

> This scan is only checking for high or critical severity issues. We are scanning an old nginx image so there will be a lot of vulnerabilities.

## Scan Latest Image

Pull the latest nginx:alpine image `docker image pull nginx:alpine`{{execute}}

Scan the image using trivy `trivy image --severity "HIGH,CRITICAL" nginx:alpine`{{execute}}

> Hopefully there were no vulnerabilities in the latest image. This demonstrates the importance of using the most up-to-date parent/base image you can and keeping that up-to-date.
