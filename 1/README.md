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
- [4 - Workshop](#4---workshop)
  - [4.1 - Base de donnees](#41---base-de-donnees)
    - [Create a Volume](#create-a-volume)
    - [Create a Secrets](#create-a-secrets)
    - [Deploy the DB instance](#deploy-the-db-instance)
    - [Service](#service)
    - [Check your DB](#check-your-db)
  - [4.2 - The Ghost App](#42---the-ghost-app)
    - [Service](#service-1)
    - [Sercret](#sercret)
    - [ConfigMap](#configmap)
    - [Deployment](#deployment)
  - [4.3 - TroubleShoot](#43---troubleshoot)
    - [Get Pods](#get-pods)
    - [Logs](#logs)
    - [Describe](#describe)
    - [Exec and Jump into a Pod](#exec-and-jump-into-a-pod)
    - [Resources ?](#resources-)
  - [4.4 - Scale](#44---scale)
    - [Manually](#manually)
    - [Via Manifests](#via-manifests)
    - [Online](#online)
    - [AutoScale](#autoscale)
  - [4.5 - Rolling Update](#45---rolling-update)
    - [Update](#update)
    - [Rollback](#rollback)

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





## 4 - Workshop

### 4.1 - Base de donnees

#### Create a Volume

> Warning
> --
>
> Only these types of volumes are supported for now:
> - https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes
>


For info if using GCloud: Create a persistant volume

```
kubectl create -f app/database/mysql-pvc.yaml
```



#### Create a Secrets

We will store a "password" as a *Secret object* in kube and will see hot to use it in a deployment

```
kubectl create secret generic mysql-passwords \
  --from-literal=root=myRootS3cr3t \
  --from-literal=ghost=myS3cr3t
```

```
kubectl describe secret mysql-passwords
```



#### Deploy the DB instance

Have a look at the deployment Manifest: `app/database/mysql-deployment.yaml`


Deploy:
```
kubectl apply -f app/database/mysql-deployment.yaml
```


Check:
```
kubectl get pods --all-namespaces -o wide -l name=mysql
```

```
watch -n 2 'kubectl describe po mysql-'
```



#### Service

Create
```
kubectl create -f app/database/mysql-service.yaml
```


Check
```
kubectl get svc
```


Describe
```
kubectl describe svc
```



#### Check your DB

Run an MySQL Client in the k8s cluster

```
kubectl run -ti mysqlcli --image mysql --command /bin/bash
```


Try the DB service
```
mysql -h mysql.foo.svc.cluster.local -u ghost -p
```


> Notes01:
> --
>
> Rememeber the password in Secret section
>


> Note02:
> --
>
> Notice the SERVICE discovery in k8s with DNS convention:
>
> * `<service_name>.<namespace>.svc.<cluster_domain_name>`
>


Connect to Running Pod:
```
kubectl exec -ti <pod-name> [--namespace <namespace>] [-c <container-name>] -- /bin/bash
```


Cleanup:
```
kubectl delete deploy mysqlcli
```




### 4.2 - The Ghost App

#### Service

```
kubectl create -f app/ghost/ghost-service.yaml
```

```
kubectl get svc ghost -w
```



#### Sercret

Edit the `app/configs/config.js`

```
sed -i "s/NAMESPACE/${NAMESPACE}/g" app/configs/config.js
```

```
NODEPORT=$(kubectl describe svc ghost | grep -i 'NodePort:' | awk '{print $3}' | cut -d '/' -f1)
sed -i "s/NODEPORT/${NODEPORT}/g" app/configs/config.js
```


Create the Secret
```
kubectl create secret generic ghost --from-file=app/configs/config.js
```



#### ConfigMap

```
kubectl create configmap nginx-ghost --from-file=app/configs/ghost.conf
```



#### Deployment

```
kubectl create -f app/ghost/ghost-deployment.yaml
```





### 4.3 - TroubleShoot

#### Get Pods

```
kubectl get pods -w
```



#### Logs

```
kubectl logs ghost-651739629-00h4j -c nginx --tail=5 -f
```



#### Describe

```
kubectl describe deploy ghost
```



#### Exec and Jump into a Pod

```
kubectl exec -ti ghost-651739629-00h4j -- /bin/bash
```



#### Resources ?

```
kubectl top pod -l app=ghost
```




### 4.4 - Scale

#### Manually

```
kubectl scale deploy ghost --replicas=3
```



#### Via Manifests

Edit:
* `app/ghost/ghost-deployment.yaml`
* Change the `replicas` value

Apply changes
```
kubectl apply -f app/ghost/ghost-deployment.yaml
```



#### Online

```
kubectl edit deploy ghost
```



#### AutoScale

```
kubectl autoscale ghost --min=2 --max=5 --cpu-percent=80
```


> Notes
> --
>
> `kubectl get events -w`
>




### 4.5 - Rolling Update

#### Update

```
kubectl set image deployment/ghost ghost=kelseyhightower/ghost:0.7.8
```

```
kubectl get rs -w
kubectl get rs -l app=ghost -w
```



#### Rollback

```
kubectl rollout undo deployment/ghost
```



> Notes
> --
>
> Revision concept: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
>
> `kubectl deploy ... --record`
> `kubectl rollout history deployment/DEPLOY_NAME`
> `kubectl rollout history deployment/DEPLOY_NAME --revision=2`
> `kubectl rollout undo deployment/DEPLOY_NAME --to-revision=2`
>

