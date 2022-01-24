So far you have interacted with the Kubernetes API using just the *kubectl* command line tool. In this step you will connect to the API directly using standard HTTP requests.

## API Proxy

The *kubectl* command line tool provides an easy way to create a local proxy to the Kubernetes API using port-forwarding.

View the API proxy help `kubectl proxy --help`{{execute}}

Create the API proxy in the background `kubectl proxy &`{{execute}}

Call the API `curl http://localhost:8001`{{execute}}

> All of the API endpoints are listed, in addition to the resource group endpoints it includes endpoints for metrics, logs, health and version information.

> API groups make it easier to extend the Kubernetes API. The API group is specified in the REST path and in the apiVersion field of a serialized object. There are several API groups in Kubernetes:

> - The core (also called legacy) group is found at the REST path /api/v1. The core group is not specified as part of the apiVersion field, for example, apiVersion: v1.
> - The named groups are at REST path /apis/$GROUP_NAME/$VERSION and use apiVersion: $GROUP_NAME/$VERSION (for example, apiVersion: networking.k8s.io/v1). You can find the full list of supported API groups in Kubernetes API reference.

Get the pods using the API `curl http://localhost:8001/api/v1/pods`{{execute}}

## API Token

The proxy created by kubectl is convienient but not required, you can connect directly to the API.

Find the address of the API `kubectl config view`{{execute}}

Store the cluster address in an environment variable `export CLUSTER_ADDRESS=$(kubectl config view -o json | jq -r '.clusters[0].cluster.server')`{{execute}}

Try to access the API using the cluster address `curl $CLUSTER_ADDRESS`{{execute}}

> The previous command will fail because the certificate authority is not trusted, you can pass the *--insecure* flag to curl but then it will fail with a 403 error.

View the default ServiceAccount `kubectl get serviceaccount default -o yaml`{{execute}}

> Each namespace has a default [ServiceAccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) that can access the API server. You can use the token for the default ServiceAccount in your own HTTP calls.

Get the default ServiceAccount secret name `export SECRET_NAME=$(kubectl get serviceAccount default -o json | jq -r '.secrets[0].name')`{{execute}}

View the secret `kubectl get secret $SECRET_NAME -o yaml`{{execute}}

Get the CA certficate `kubectl get secret $SECRET_NAME -o json | jq -r '.data."ca.crt"' | base64 -d >cacert.cer`{{execute}}

Get the token `export TOKEN=$(kubectl get secret $SECRET_NAME -o json | jq -r '.data.token' | base64 -d)`{{execute}}

Call the API `curl --cacert cacert.cer --header "Authorization: Bearer ${TOKEN}" -X GET $CLUSTER_ADDRESS/api/v1/namespaces/default/pods`{{execute}}

> This command still fails but because the default ServiceAccount does not have permission to list pods in the default namespace. You can fix this by creating a Role and RoleBinding to grant the access.

Create a Role to list pods in the default namespace `kubectl create role pod-list --verb=list --resource pods --namespace default`{{execute}}

Create a RoleBinding to allow the default service account in the default namespace to use the *pod-list* role `kubectl create rolebinding pod-list --role=pod-list-default --serviceaccount=default:default`{{execute}}

Call the API `curl --cacert cacert.cer --header "Authorization: Bearer ${TOKEN}" -X GET $CLUSTER_ADDRESS/api/v1/namespaces/default/pods`{{execute}}

> The Kubernetes documentation has more details on [service accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/), [roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) and [role bindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding).