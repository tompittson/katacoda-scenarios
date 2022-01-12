In this step you will use a script to scan all of the local images for a specific critical vulnerabilty.

## Scan Local Images

Take a look at the script `scan-local-images.sh`{{open}}

Pull a logstash image `docker image pull logstash:7.6.1`{{execute}}

> The image is an older version of logstash that contains Log4j [CVE-2021-44228](https://www.cve.org/CVERecord?id=CVE-2021-44228) critical vulnerability that gained a lot of attention at the end of 2021.

Execute the script to check the local images for the vulnerability `./scan-local-images.sh CVE-2021-44228`{{execute}}

> The output will show that the logstash:7.6.1 image contains the vulnerability. The script can be modified to scan different sets of images e.g. those in a registry or all those used by pods on a kubernetes cluster.