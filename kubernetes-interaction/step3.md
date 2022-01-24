In this step you will look at how objects/resources are represented in Kubernetes .

> One thing that is key to understand is that when you create a Kubernetes object **it is only a "record of intent"**. Depending on the type of resource one or more Kubernetes system componenets will constantly work to ensure that, what you defined in the object, is implemented. By creating an object, you're defining the **desired state** but there are no guarantees that it can be fulfilled.

## Different Resource Types

Resources in Kubernetes fall into two different categories, namespaced resources and cluster-wide resources. Namespaces provide a mechanism for isolating groups of resources within a single cluster. View the [documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) for an overview of working with namespaces.

View the namespaced resources `kubectl api-resources --namespaced=true`{{execute}}

View the cluster-wide resources `kubectl api-resources --namespaced=false`{{execute}}

> The Kubernetes API is **extensible**. New types of resource can be created through [custom resource definitions](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) and new controllers or operators can be deployed that act on the objects created for the custom resources.

## Resource Manifests

Each resource type has its own schema, you can view the schema definition for a particular resource using the `kubectl explain` command.

View the top level schema for a pod `kubectl explain pod`{{execute}}

Drill down into the spec of the pod resource

`kubectl explain pod.spec`{{execute}}

`kubectl explain pod.spec.containers`{{execute}}

`kubectl explain pod.spec.containers.resources`{{execute}}

There are four fields defined for nearly all objects:

- **apiVersion** - The API group that the object belongs to
- **kind** - The type of object to create
- **metadata** - Data to uniquely identify the object (name, namespace) and additional metadata (labels and annotations)
- **spec** - The definition for the object to create, specific to the resource type

## Create a Resource

Use **kubectl** to create a pod `kubectl run step3-pod --image=nginx:latest`{{execute}}

> This creates a new pod called *step3-pod* running the latest nginx image. The pod is created in the *default* namespace as no specific namespace was given in the command.

List the pod created `kubectl get pods`{{execute}}

View the pod object `kubectl get pod step3-pod -o yaml`{{execute}}

You can also view the object definition before it is created using the *--dry-run=client* flag.

`kubectl run step3-pod2 --image=busybox:latest --dry-run=client -o yaml`{{execute}}

## API Verbs

Take a look at the list of all API resource types again (the *-o wide* flag can be used on some resource types to get additional information)

`kubectl api-resources -o wide`{{execute}}

> An extra column is included called VERBS which lists the operations you can perform against that resource type.

- **get** - retrieve a specific resource object by name
- **list** - list all resource objects of a specific type (by namespace)
- **watch** - stream results for an object(s) as it is changed
- **create** - create a resource object
- **update** - replace an existing resource object
- **patch** - apply a change to specific field(s) in a resource object
- **delete** - delete a resource object (child objects may or may not be deleted - depends on resource type)

The `kubectl api-resources` command does not tell you what versions of the API groups are in use on the current cluster. You can find this information using another command.

`kubectl api-versions`{{execute}}