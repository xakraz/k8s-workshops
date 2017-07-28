# k8s workshop-1


## Table Of Content

<!-- MarkdownTOC -->

- [1 - Requirements](#1---requirements)
- [2 - Bootstrap](#2---bootstrap)
  - [2.1 - Get the sources](#21---get-the-sources)
    - [Optional](#optional)
  - [2.2 - Configure kubectl](#22---configure-kubectl)
- [3 - Get around Kube](#3---get-around-kube)
  - [3.1 - Nodes](#31---nodes)
  - [3.2 - Namespaces](#32---namespaces)
    - [Create Namespace](#create-namespace)
    - [Get Namespaces](#get-namespaces)
    - [Configure your context to use your namespace](#configure-your-context-to-use-your-namespace)
- [4 - Setup the App](#4---setup-the-app)
  - [4.1 - Volume](#41---volume)
  - [4.2 - Secrets](#42---secrets)

<!-- /MarkdownTOC -->



Based on Kelsey Hightower [Kubecon Talk](https://github.com/kelseyhightower/talks/tree/master/kubecon-eu-2016/demo)

What you will do:
* Create / manage Secrets
* Create / manage ConfigMaps
* Deploy a pod
* Deploy a service
* Troubleshoot :D





## 1 - Requirements

* A running Kubernetes cluster

OR

* Docker
  - From your favorite Package manager
  - Or `curl -fsSl https://get.docker.com/ | $SHELL`

OR

* [Minikube](https://github.com/kubernetes/minikube)
  - `curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/`





## 2 - Bootstrap

### 2.1 - Get the sources

Clone the repo:
```
git clone https://github.schibsted.io/xavier-krantz/k8s-workshops && cd k8s-workshops/1
```

Get `Kubectl`:
```
./scripts/get_kubectl.sh
```

-> Follow the instructions


#### Optional

For the sake of this workshop, we will use [**Kubernetes-Dind**](https://github.com/Mirantis/kubeadm-dind-cluster):

```
./scripts/get_dind_cluster.sh
```

-> Follow the instructions




### 2.2 - Configure kubectl

```
kubectl config view
```

```
kubectl config use-context dind
```




## 3 - Get around Kube

### 3.1 - Nodes

```
kubectl get nodes -o wide
```



### 3.2 - Namespaces

Doc:
- https://kubernetes.io/docs/tasks/administer-cluster/namespaces/


#### Create Namespace

```
kubectl create namespace foo
export NAMESPACE=foo
```


> Warning:
> --
>
> Ne pas oublier d’initialiser la variable d'environnement NAMESPACE
>


#### Get Namespaces

```
kubectl get ns
```


#### Configure your context to use your namespace

```
kubectl config set-context $(kubectl config current-context) --namespace=${NAMESPACE}
```




## 4 - Setup the App

### 4.1 - Volume

Create a persistant volume

```
kubectl create -f app/database/mysql-pvc.yaml
```

> Warning
> --
>
> Only these types of volumes are supported for now:
> - https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes
>
>



### 4.2 - Secrets

We will store a "password" as a *Secret object* in kube and will see hot to use it in a deployment

```
kubectl create secret generic mysql-passwords --from-literal=root=myRootS3cr3t --from-literal=ghost=myS3cr3t
```

```
kubectl describe secret mysql-passwords
```

