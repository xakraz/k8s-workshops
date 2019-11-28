# 20191128 Workshop Rancher


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [0 - Overview](#0---overview)
- [1 - Prez](#1---prez)
  - [1.1 - Goal of the day](#11---goal-of-the-day)
  - [1.2 - K8s intro](#12---k8s-intro)
  - [1.3 - Rancher intro](#13---rancher-intro)
- [2 - Workshop](#2---workshop)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## 0 - Overview

Rancher is now 2.0
- Management of k8s
- Management of k8s ecosystem

Other software in container worl
- k3s
- Rio
- Submariner
- ...

In France, Rancher
- Offers support for enterprise version
- Dedicated support



## 1 - Prez

### 1.1 - Goal of the day

* Explain Docker and k8s
* Provision HobbyFarm
* ...

Env up till 7:00 PM


### 1.2 - K8s intro


### 1.3 - Rancher intro

* Provision / Ingest existing k8s cluster
* Integration
    - Monitoring
    - Helm charts registry
    - Auth management



## 2 - Workshop

https://learn.eu1.hobbyfarm.io/login


### 2.1 - Provision the cluster

Running Single-Node Rancher Server

```
sudo docker run -d \
    --restart=unless-stopped \
    -p 80:80 -p 443:443 \
    -v /opt/rancher:/var/lib/rancher \
    rancher/rancher:stable
```

-> Access public IP

```
URL: https://34.244.234.62/
Username: admin
Password: ddHHzDmfPDgm17SH
```


### 2.2 - Interact with cluster

Download provided `kubeconfig` file and get CLI from laptop:

```
kubectl --kubeconfig=${PWD}/kubeconfig.cfg get pods -A              
NAMESPACE       NAME                                      READY   STATUS      RESTARTS   AGE
cattle-system   cattle-cluster-agent-6f5df8c5c5-qkwpw     1/1     Running     1          6m34s
cattle-system   cattle-node-agent-fp6mz                   1/1     Running     0          6m34s
cattle-system   kube-api-auth-h2vqh                       1/1     Running     0          6m34s

ingress-nginx   default-http-backend-67cf578fc4-s2h6l     1/1     Running     0          6m52s
ingress-nginx   nginx-ingress-controller-bfln7            1/1     Running     0          6m52s

kube-system     canal-kxt52                               2/2     Running     0          7m7s
kube-system     coredns-5c59fd465f-h7c95                  1/1     Running     0          7m5s
kube-system     coredns-autoscaler-d765c8497-sz6pj        1/1     Running     0          7m3s
kube-system     metrics-server-64f6dffb84-vpmrr           1/1     Running     0          7m
kube-system     rke-coredns-addon-deploy-job-585bz        0/1     Completed   0          7m6s
kube-system     rke-ingress-controller-deploy-job-kw2zf   0/1     Completed   0          6m56s
kube-system     rke-metrics-addon-deploy-job-fqhp7        0/1     Completed   0          7m1s
kube-system     rke-network-plugin-deploy-job-xwz8n       0/1     Completed   0          7m11s
```



