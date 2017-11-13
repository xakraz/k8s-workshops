# k8s workshop-1


## Slides - Introduction

[K8s - Concepts introduction](sre-workshop-k8s_1.pdf)



## Table Of Content

<!-- MarkdownTOC -->

- [1 - Requirements](#1---requirements)
- [2 - Bootstrap](#2---bootstrap)
- [3 - Get around Kube](#3---get-around-kube)
- [4 - Workshop](#4---workshop)
  - [4.1 - Database](#41---database)
  - [4.2 - The Ghost App](#42---the-ghost-app)
  - [4.3 - TroubleShoot](#43---troubleshoot)
  - [4.4 - Scale](#44---scale)
  - [4.5 - Rolling Update](#45---rolling-update)
- [5 - References](#5---references)

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

[BootStrap](doc/k8s_workshop-1.2.md)



## 3 - Get around Kube

[Kubectl and nodes](doc/k8s_workshop-1.3.md)



## 4 - Workshop

### 4.1 - Database

[Database](doc/k8s_workshop-1.4.1.md)


### 4.2 - The Ghost App

[App](doc/k8s_workshop-1.4.2.md)


### 4.3 - TroubleShoot

[Troublshoot](doc/k8s_workshop-1.4.3.md)


### 4.4 - Scale

[Scale](doc/k8s_workshop-1.4.4.md)


### 4.5 - Rolling Update

[Rolling Updates](doc/k8s_workshop-1.4.5.md)





## 5 - References

Leaning material
- https://kubernetesbootcamp.github.io/kubernetes-bootcamp/
- http://kubernetesbyexample.com/

Presentations
- https://speakerdeck.com/superbrothers/an-introduction-to-kubernetes
- https://www.slideshare.net/resouer/kubernetes-walk-through-zhanglei
- https://speakerdeck.com/thesandlord/kubernetes-best-practices

Doc:
- https://kubernetes.io/docs/home/


