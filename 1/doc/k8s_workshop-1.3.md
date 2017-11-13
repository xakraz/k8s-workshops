# k8s workshop-1.3


<!-- MarkdownTOC -->

- [3 - Get around Kube](#3---get-around-kube)
  - [3.1 - Nodes](#31---nodes)
  - [3.2 - Namespaces](#32---namespaces)
    - [Create Namespace](#create-namespace)
    - [Get Namespaces](#get-namespaces)
    - [Configure your context to use your namespace](#configure-your-context-to-use-your-namespace)

<!-- /MarkdownTOC -->



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
> Do NOT forget to initialize the environment variable `NAMESPACE` for the rest of the workshop !
>


#### Get Namespaces

```
kubectl get ns
```


#### Configure your context to use your namespace

```
kubectl config set-context $(kubectl config current-context) --namespace=${NAMESPACE}
```

