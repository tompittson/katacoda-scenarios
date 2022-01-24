In the last step you executed a command using kubectl, in this step you are going to explore it some more.

kubectl (pronounced kube-control, or kube-cuttle, or kube-C-T-L) is a command line tool that lets you control Kubernetes clusters. For configuration, kubectl looks for a file named config in the $HOME/.kube directory.

The basic syntax is:

`kubectl [command] [type] [name] [flags]`

See the [overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) for more information.

## General Information

Current version `kubectl version`{{execute}}

Cluster info `kubectl cluster-info`{{execute}}

Component statuses `kubectl get componentstatuses`{{execute}}

Help `kubectl --help`{{execute}}

## Context

In this scenario you are executing kubectl on the control-plane node. However, normally you would never do this and instead you connect to a remote cluster as defined in the current context.

List contexts `kubectl config get-contexts`{{execute}}

View the current context `kubectl config view`{{execute}}

> kubectl uses the client cerficate and key to authenticate against the cluster API.

## Common Commands

kubectl is just a convienient way to interact with the Kubernetes API, it is important to understand that almost every command you execute with kubectl is performing an operation against the API and not any other componenent within the cluster.

Get all the pods running in the cluster `kubectl get pods --all-namespaces`{{execute}}

Describe a node `kubectl describe nodes node01`{{execute}}

View the logs from a pod `kubectl logs kube-apiserver-controlplane --namespace kube-system`{{execute}}

> The last command included a flag for the namespace, namespaces are used to group namespaces scoped resources. This will be explored more in the next step.

## Abbreviations and Aliases

The *kubectl* executeable is often aliased to just *k* and this should already be applied in the terminal session.

Get pods in the kube-system namespace `k get pods --namespace kube-system`{{execute}}

Many of the resources also have abbreviations and there are short versions of many of the command line switches e.g.

`k get po -n kube-system`{{execute}}

You can also get multiple resources at the same time e.g.

`kubectl get pods,services,configmaps,secrets -n kube-system`{{execute}}

## Output Formatting

There are lots of options to control the output from kubectl commands e.g.

Change columns `kubectl get pods -o custom-columns=NAME:.metadata.name,CREATED:.metadata.creationTimestamp -n kube-system`{{execute}}

Get pod in yaml format `kubectl get pod kube-apiserver-controlplane -o yaml -n kube-system`{{execute}}

Get pod in json format `kubectl get pod kube-apiserver-controlplane -o json -n kube-system`{{execute}}

> This has only scratched the surface of the different commands you can execute, explore the kubectl help and [documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands) for more information.