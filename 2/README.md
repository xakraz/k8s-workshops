
# D2iQ Kubernetes Workshop

Date: 2019-10-10
Resources URL: http://tinyurl.com/y66pm5ne
Workshop: https://github.com/mesosphere/konvoy-training



<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [0. Prerequisites](#0-prerequisites)
- [1. Deploy a Konvoy cluster](#1-deploy-a-konvoy-cluster)
  - [Note01](#note01)
  - [Note02](#note02)
  - [Note03](#note03)
  - [Note04](#note04)
  - [Note05](#note05)
- [2. Expose a Kubernetes Application using a Service Type Load Balancer (L4)](#2-expose-a-kubernetes-application-using-a-service-type-load-balancer-l4)
- [3. Expose a Kubernetes Application using an Ingress (L7)](#3-expose-a-kubernetes-application-using-an-ingress-l7)
- [4. Leverage Network Policies to restrict access](#4-leverage-network-policies-to-restrict-access)
- [5. Leverage persistent storage using CSI](#5-leverage-persistent-storage-using-csi)
- [6. Deploy Jenkins using Helm](#6-deploy-jenkins-using-helm)
- [7. Deploy Apache Kafka using KUDO](#7-deploy-apache-kafka-using-kudo)
- [8. Scale a Konvoy cluster](#8-scale-a-konvoy-cluster)
- [9. Konvoy monitoring](#9-konvoy-monitoring)
- [10. Konvoy logging/debugging](#10-konvoy-loggingdebugging)
- [11. Upgrade a Konvoy cluster](#11-upgrade-a-konvoy-cluster)
- [12. Destroy a Konvoy cluster](#12-destroy-a-konvoy-cluster)
- [Appendix](#appendix)
  - [1. Setting up an external identity provider](#1-setting-up-an-external-identity-provider)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## 0. Prerequisites

Junp server

* Download key in `tmp/`
* `chmod 400 tmp/id_rsa_student_xx`
* `ssh-add tmp/id_rsa_student_xx`

```
ssh centos@54.173.172.254
```



## 1. Deploy a Konvoy cluster

`Konvoy` is based on existing tooling:
* `terraform`: For cloud infrastructure resources provisioning
* `ansible`: For compute instance configuration and k8s bootstrap


### Note01

```
$ konvoy up --yes

This process will take about 15 minutes to complete (additional time may be required for larger clusters)

STAGE [Provisioning Infrastructure]

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "local" (1.4.0)...
- Downloading plugin for provider "random" (2.2.1)...
- Downloading plugin for provider "aws" (2.31.0)...

Terraform has been successfully initialized!
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

...


```



### Note02

`konvoy` internal steps:

1. STAGE [Provisioning Infrastructure]  : `terraform`
2. STAGE [Running Preflights]           : `ansible`
3. STAGE [Fetching Node Configuration]  : `ansible`
4. STAGE [Preparing Machines]           : `ansible`
5. STAGE [Deploying Kubernetes]         : `ansible`
    PLAY [Bootstrap First Control Plane]
    PLAY [Bootstrap Additional Control Plane]
    PLAY [Bootstrap Nodes]
6. STAGE [Deploying Container Networking] : `ansible`
7. STAGE [Deploying Enabled Addons]



### Note03

Addons deployed with `konvoy`

```
STAGE [Deploying Enabled Addons]

helm                                                                   [OK]

dashboard                                                              [OK]
opsportal                                                              [OK]

awsebscsiprovisioner                                                   [OK]

traefik                                                                [OK]
traefik-forward-auth                                                   [OK]

kommander                                                              [OK]

prometheus                                                             [OK]
prometheusadapter                                                      [OK]

fluentbit                                                              [OK]
elasticsearch                                                          [OK]
elasticsearchexporter                                                  [OK]
kibana                                                                 [OK]

dex                                                                    [OK]
dex-k8s-authenticator                                                  [OK]

velero                                                                 [OK]
```



### Note04

Konvoy internals

```
runs/
│
├── Provisioning\ Infrastructure
│   └── 2019-10-10-08-48-47
│       └── tf.log
│
├──  Running\ Preflights
│   └── 2019-10-10-09-13-54
│       ├── ansible.log
│       ├── cluster.yaml
│       └── inventory.yaml
│
├── Fetching\ Node\ Configuration
│   └── 2019-10-10-09-14-07
│       ├── ansible.log
│       └── inventory.yaml
│
├── Preparing\ Machines
│   └── 2019-10-10-09-14-11
│       ├── ansible.log
│       ├── cluster.yaml
│       └── inventory.yaml
│
├── Deploying\ Kubernetes
│   └── 2019-10-10-09-15-40
│       ├── ansible.log
│       ├── cluster.yaml
│       └── inventory.yaml
│
├── Deploying\ Container\ Networking
│   └── 2019-10-10-09-20-43
│       ├── ansible.log
│       ├── cluster.yaml
│       └── inventory.yaml
│
└── Fetching\ Admin\ Kubeconfig
    └── 2019-10-10-09-33-57
        ├── ansible.log
        └── inventory.yaml
```



### Note05

```
$ konvoy apply kubeconfig


STAGE [Fetching Admin Kubeconfig]

PLAY [Fetch Kubeconfig] ***************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [10.0.194.84]

TASK [fetch-kubeconfig : fetch admin kubeconfig] **************************************************************************************
changed: [10.0.194.84]

TASK [fetch-kubeconfig : add a warning about modifying admin.conf file] ***************************************************************
changed: [10.0.194.84 -> localhost]

PLAY RECAP ****************************************************************************************************************************
10.0.194.84                : ok=3    changed=2    unreachable=0    failed=0   


Kubeconfig activated successfully!
```

```
$ kubectl get nodes
NAME                           STATUS   ROLES    AGE   VERSION
ip-10-0-128-184.ec2.internal   Ready    <none>   18m   v1.15.2
ip-10-0-128-187.ec2.internal   Ready    <none>   17m   v1.15.2
ip-10-0-128-208.ec2.internal   Ready    <none>   18m   v1.15.2
ip-10-0-130-46.ec2.internal    Ready    <none>   18m   v1.15.2
ip-10-0-130-60.ec2.internal    Ready    <none>   18m   v1.15.2
ip-10-0-194-110.ec2.internal   Ready    master   19m   v1.15.2
ip-10-0-194-84.ec2.internal    Ready    master   21m   v1.15.2
ip-10-0-195-218.ec2.internal   Ready    master   20m   v1.15.2
```

=> SUCCESS





## 2. Expose a Kubernetes Application using a Service Type Load Balancer (L4)
## 3. Expose a Kubernetes Application using an Ingress (L7)
## 4. Leverage Network Policies to restrict access
## 5. Leverage persistent storage using CSI
## 6. Deploy Jenkins using Helm
## 7. Deploy Apache Kafka using KUDO
## 8. Scale a Konvoy cluster
## 9. Konvoy monitoring
## 10. Konvoy logging/debugging
## 11. Upgrade a Konvoy cluster
## 12. Destroy a Konvoy cluster

## Appendix
### 1. Setting up an external identity provider