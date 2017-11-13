# k8s workshop-1.2


<!-- MarkdownTOC -->

- [2 - Bootstrap](#2---bootstrap)
  - [2.1 - Get the sources](#21---get-the-sources)
  - [2.2 - Init the requirements](#22---init-the-requirements)
    - [Optional](#optional)
  - [2.3 - Configure kubectl](#23---configure-kubectl)

<!-- /MarkdownTOC -->


## 2 - Bootstrap

### 2.1 - Get the sources

Clone the repo:
```
git clone https://github..com/xavier-krantz/k8s-workshops
cd k8s-workshops/1
```



### 2.2 - Init the requirements

Get `Kubectl`:
```
./scripts/get_kubectl.sh
```


Init the Shell:
```
eval "$(../env.sh)"
```


#### Optional

For the sake of this workshop, we will use [**Kubernetes-Dind**](https://github.com/Mirantis/kubeadm-dind-cluster):

```
./scripts/get_dind_cluster.sh
```

-> Follow the instructions




### 2.3 - Configure kubectl

Doc:
- https://lukemarsden.github.io/docs/user-guide/kubectl/kubectl_config/

Keywords:
* Cluster
* User
* Context = Cluster + User


See the "Aggregated" config
```
kubectl config view
```


Define a "Context" for this session:
```
kubectl config use-context dind
```

