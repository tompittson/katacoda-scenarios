In this scenario you will use [trivy](https://aquasecurity.github.io/trivy/) to scan different container images.

Image scanning is an important part of the container security strategy. Although image scanning can't protect you from all possible security vulnerabilities, it's the primary means of defense against security flaws or insecure libraries within container images.

Typically, image scanning works by parsing through the packages or other dependencies that are defined in a container image file, then checking to see whether there are any known vulnerabilities in those packages or dependencies.

It's important to note that security scanning by no means provides full security coverage. There are several potential security problems that container image scanning can't find:

- Security problems in your container environment or orchestrator configuration
- Insecure shared resources outside of the container image e.g. shared volumes
- Unknown security vulnerabilities
- Vulnerabilities in packages not known to the public security vulnerabilities databases