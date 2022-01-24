In this step you will setup the Kubernetes cluster used in the rest of the steps. The steps use [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) to configure a single node control-plane and a single worker node.

## Initialize Control-plane

`kubeadm init --kubernetes-version $(kubeadm version -o short)`{{execute HOST1}}

> Check the output of the command, once complete you need to copy the `kubeadm join ...` command.

## Join Workder Node

Copy and paste the `kubeadm join...` command finto the bottom terminal for node01 e.g. (the token and cert hash will be different)

```
kubeadm join 172.17.0.43:6443 --token sapneu.ugsnyj5192zo27n8 \
    --discovery-token-ca-cert-hash sha256:a76468ab1433718fee1366edffa6f56d52c9cf4990a8159918cd1b96fe301a24 
```

## Configure Kube Config

The [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) CLI needs to be configured so that it can connect to the control plane of a cluster. Execute the commands below (also displayed in the kubeadm init output) to setup the kube config on the control-plane node.

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```{{execute HOST1}}

Check the status of the nodes in the cluster `kubectl get nodes`{{execute}}

> It doesn't matter if the nodes are not ready, in the rest of the steps in this scenario you are just working with the Kubernetes API.