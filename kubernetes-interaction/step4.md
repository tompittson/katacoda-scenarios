In the previous step you created a pod using `kubectl run`, this is an example of using an [imperative command](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/imperative-command/).

## Imperative Commands

The *kubectl create* command allows you to create certain resource types in an imperative way.

`kubectl create --help`{{execute}}

> There isn't a *kubectl create pod*, instead *kubectl run* is used as seen in the previous step.

View the help for creating a ConfigMap `kubectl create configmap --help`{{execute}}

> A [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) is used to store non-sensitive key-value pairs on the cluster. The key-value pairs can include full files or simple string literals. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files mounted using a volume.

Create a ConfigMap using *kubectl* in the imperative form:

`kubectl create configmap step4-config --from-literal=key=value --from-literal=foo=bar`{{execute}}

Check the created ConfigMap `kubectl get configmap -o yaml`{{execute}}

> A ConfigMap is an example of a object that exists purely in the Kubernetes API and is then consumed by other other objects such as pods.

## Declarative Commands

The declarative form of the command is `kubectl apply`, this command can work on single files or a whole directory of files.

Create the yaml file for a simple pod:

`kubectl run step4-pod --image=nginx:latest --namespace default --dry-run=client -o yaml | tee pod.yaml`{{execute}}

Apply the yaml file to create the pod `kubectl apply -f pod.yaml`{{execute}}

Update the file to use a specific tag for the nginx image:

`kubectl run step4-pod --image=nginx:1.20 --namespace default --dry-run=client -o yaml | tee pod.yaml`{{execute}}

Apply the updated yaml file to modify the pod `kubectl apply -f pod.yaml`{{execute}}

## Which To Use?

> The Kubernetes documentation has a [comparison between the different approaches](https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/), typically in a CI/CD pipeline you will use the declarative approach although often an additional tool like [Helm](https://helm.sh/) or [Kustomize](https://kustomize.io/) is used to generate the definitions before they are applied to the cluster. 