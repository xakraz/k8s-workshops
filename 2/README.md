
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
  - [Note01](#note01-1)
  - [Note02](#note02-1)
  - [Note03](#note03-1)
  - [Note04](#note04-1)
- [3. Expose a Kubernetes Application using an Ingress (L7)](#3-expose-a-kubernetes-application-using-an-ingress-l7)
  - [Overview](#overview)
  - [Note01](#note01-2)
  - [Note02](#note02-2)
  - [Note03](#note03-2)
- [4. Leverage Network Policies to restrict access](#4-leverage-network-policies-to-restrict-access)
  - [Overview](#overview-1)
  - [Note01](#note01-3)
- [5. Leverage persistent storage using CSI](#5-leverage-persistent-storage-using-csi)
  - [Overview](#overview-2)
  - [Note01](#note01-4)
  - [Note02](#note02-3)
- [6. Deploy Jenkins using Helm](#6-deploy-jenkins-using-helm)
  - [Overview](#overview-3)
  - [Note01](#note01-5)
- [7. Deploy Apache Kafka using KUDO](#7-deploy-apache-kafka-using-kudo)
  - [Overview](#overview-4)
  - [Note01](#note01-6)
  - [Note02](#note02-4)
  - [Note03](#note03-3)
  - [Note04](#note04-2)
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


File: [redis.yml](./lab/2/redis.yml)

### Note01

```
kubectl apply -f lab/2/redis.yml
```

-> Pod
-> Service


### Note02

Get output in Json


```
kubectl get svc redis --output json
{
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "creationTimestamp": "2019-10-10T10:02:35Z",
        "labels": {
            "app": "redis"
        },
        "name": "redis",
        "namespace": "default",
        "resourceVersion": "9696",
        "selfLink": "/api/v1/namespaces/default/services/redis",
        "uid": "bc23762a-e1b1-4b69-a99b-83e5c0f0c72a"
    },
    "spec": {
        "clusterIP": "10.0.14.139",
        "externalTrafficPolicy": "Cluster",
        "ports": [
            {
                "nodePort": 32013,
                "port": 6379,
                "protocol": "TCP",
                "targetPort": 6379
            }
        ],
        "selector": {
            "app": "redis"
        },
        "sessionAffinity": "None",
        "type": "LoadBalancer"
    },
    "status": {
        "loadBalancer": {
            "ingress": [
                {
                    "hostname": "abc23762ae1b14b69a99b83e5c0f0c72-761579066.us-east-1.elb.amazonaws.com"
                }
            ]
        }
    }
}

```


### Note03

Get specific property from Json output:

```
kubectl get svc redis --output jsonpath={.status.loadBalancer.ingress[*].hostname}

abc23762ae1b14b69a99b83e5c0f0c72-761579066.us-east-1.elb.amazonaws.com
```


### Note04

By default, the `type: LoadBalancer` is cloud provider specific (k8s used to have cloud providers drivers built-in ...)





## 3. Expose a Kubernetes Application using an Ingress (L7)

### Overview

* Create 2 pods
* Create 2 services with `NodePort`
    - The services should be reachable by hiting a node witht the specified port 
* Publish via `Traefik` with L7


Resources: [3](labs/3/)


### Note01

How `traefik` was deloyed as an `ingress` ?

Because in the end:
-> we get AWS ELB IP,
-> which then redirect on `traefik`
-> which route to the `pod` according to the ingress rules ...


### Note02

```
$ kubectl get ingress -o wide

NAME   HOSTS                             ADDRESS                                                                 PORTS   AGE
echo   http-echo-1.com,http-echo-2.com   a2aae854f9cca4a23945922be797e718-54138659.us-east-1.elb.amazonaws.com   80      10s
```


```
$ curl -k -H "Host: http-echo-1.com" https://$(kubectl get ingress echo --output jsonpath={.status.loadBalancer.ingress[*].hostname})
Hello from http-echo-1
```


### Note03

Traefik ScreenShot





## 4. Leverage Network Policies to restrict access

### Overview

By default, every services are reachable from anywhere (pods, namespaces, ...)

When doing multitenant, need isolation

Objectives
1. [x] Create a network policy to deny any ingress
2. [x] Check that the Redis and the http-echo apps aren't accessible anymore
3. [x] Create network policies to allow ingress access to these apps only
4. [x] Check that the Redis and the http-echo apps are now accessible

=> Using `Calico`


### Note01

Steps:
* Create default policy
* Allow access to `http-echo-1` only
* Validate


```
[centos@ip-172-31-35-79 lab]$ curl -k -H "Host: http-echo-1.com" https://$(kubectl get svc traefik-kubeaddons -n kubeaddons --output jsonpath={.status.loadBalancer.ingress[*].hostname})
Hello from http-echo-1

[centos@ip-172-31-35-79 lab]$ curl -k -H "Host: http-echo-2.com" https://$(kubectl get svc traefik-kubeaddons -n kubeaddons --output jsonpath={.status.loadBalancer.ingress[*].hostname})
Gateway Timeout
```

=> Success





## 5. Leverage persistent storage using CSI

### Overview

1. [x] Create a `PersistentVolumeClaim` (pvc) to use the `AWS EBS` CSI driver
2. [x] Create a service that will use this PVC and dynamically provision an EBS volume
3. [x] Validate persistence


### Note01

Konvoy is deployed with `awsebscsiprvisioner`, which creates a `StorageClass`

```
$ kubectl get sc awsebscsiprovisioner -o yaml

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    kubernetes.io/description: AWS EBS CSI provisioner StorageClass
    storageclass.kubernetes.io/is-default-class: "true"
  creationTimestamp: "2019-10-10T09:21:16Z"
  name: awsebscsiprovisioner
  resourceVersion: "1666"
  selfLink: /apis/storage.k8s.io/v1/storageclasses/awsebscsiprovisioner
  uid: 2a6fdf13-3964-4caf-acf6-60c4e0a6ce7c
parameters:
  type: gp2
provisioner: ebs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```


### Note02

>
> As you can see, it is **waiting for a Pod** to use it to provision the AWS EBS volume.
>

```
volumeBindingMode: WaitForFirstConsumer
```


Events history

```
$ kubectl get pvc -o wide -w

NAME      STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS           AGE   VOLUMEMODE
dynamic   Pending                                      awsebscsiprovisioner   16s   Filesystem
dynamic   Pending                                      awsebscsiprovisioner   98s   Filesystem
dynamic   Pending                                      awsebscsiprovisioner   98s   Filesystem
dynamic   Pending   pvc-f4329fc9-68d3-4ab7-b3f2-a0aba91dfb41   0                         awsebscsiprovisioner   105s   Filesystem
dynamic   Bound     pvc-f4329fc9-68d3-4ab7-b3f2-a0aba91dfb41   1Gi        RWO            awsebscsiprovisioner   105s   Filesystem
```





## 6. Deploy Jenkins using Helm

### Overview

`Helm` = Package of kube resources


### Note01

Jenkins Helm package:
* ConfigMap
* Secret
* Pvc
* Role + RoleBinding
* Deployment
* Service
* ServiceAccount


```
$ helm install stable/jenkins --name jenkins --version 1.5.0 --set master.adminPassword=password


NAME:   jenkins
LAST DEPLOYED: Thu Oct 10 12:22:22 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/ConfigMap
NAME           DATA  AGE
jenkins        5     0s
jenkins-tests  1     0s

==> v1/Deployment
NAME     READY  UP-TO-DATE  AVAILABLE  AGE
jenkins  0/1    1           0          0s

==> v1/PersistentVolumeClaim
NAME     STATUS   VOLUME                CAPACITY  ACCESS MODES  STORAGECLASS  AGE
jenkins  Pending  awsebscsiprovisioner  0s

==> v1/Pod(related)
NAME                     READY  STATUS   RESTARTS  AGE
jenkins-c79f457cb-6jxxb  0/1    Pending  0         0s

==> v1/Role
NAME                     AGE
jenkins-schedule-agents  0s

==> v1/RoleBinding
NAME                     AGE
jenkins-schedule-agents  0s

==> v1/Secret
NAME     TYPE    DATA  AGE
jenkins  Opaque  2     1s

==> v1/Service
NAME           TYPE          CLUSTER-IP  EXTERNAL-IP  PORT(S)         AGE
jenkins        LoadBalancer  10.0.50.35  <pending>    8080:30833/TCP  0s
jenkins-agent  ClusterIP     10.0.38.18  <none>       50000/TCP       0s

==> v1/ServiceAccount
NAME     SECRETS  AGE
jenkins  1        0s
```





## 7. Deploy Apache Kafka using KUDO

### Overview

Kubernetes Universal Declarative Operator (KUDO).


### Note01

`Kudo` cli is available in a `kubectl` plugin (`/usr/local/bin/kubectl-kudo`)


### Note02

Install `kudo` in the cluster

```
$ kubectl kudo init
```

```
$ kubectl get pods -n kudo-system

NAME                        READY   STATUS    RESTARTS   AGE
kudo-controller-manager-0   1/1     Running   0          2m34s
```


### Note03

Internals:
* KUDO is creating `CRDs`

```
$ kubectl get crds | grep kudo

instances.kudo.dev                               2019-08-21T09:30:46Z
operators.kudo.dev                               2019-08-21T09:30:45Z
operatorversions.kudo.dev                        2019-08-21T09:30:45Z
planexecutions.kudo.dev                          2019-08-21T09:30:46Z
```

```
$ kubectl get instances.kudo.dev
NAME    AGE
kafka   5m55s
zk      9m6s

```


### Note04

Install Zookeeper, the operator way:

```
$ kubectl kudo install zookeeper --instance=zk
instance.kudo.dev/v1alpha1/zk created
```

```
$ kubectl kudo plan status --instance=zk
Plan(s) for "zk" in namespace "default":
.
└── zk (Operator-Version: "zookeeper-0.1.0" Active-Plan: "deploy")
    ├── Plan deploy (serial strategy) [IN_PROGRESS]
    │   ├── Phase zookeeper [IN_PROGRESS]
    │   │   └── Step everything (IN_PROGRESS)
    │   └── Phase validation [PENDING]
    │       └── Step validation (PENDING)
    |
    └── Plan validation (serial strategy) [NOT ACTIVE]
        └── Phase connection (parallel strategy) [NOT ACTIVE]
            └── Step connection (parallel strategy) [NOT ACTIVE]
                └── connection [NOT ACTIVE]
```

```
$ kubectl get pods | grep zk
zk-zookeeper-0   1/1     Running   0          2m32s
zk-zookeeper-1   1/1     Running   0          2m32s
zk-zookeeper-2   1/1     Running   0          2m32s
```



## 8. Scale a Konvoy cluster
## 9. Konvoy monitoring
## 10. Konvoy logging/debugging
## 11. Upgrade a Konvoy cluster
## 12. Destroy a Konvoy cluster

## Appendix
### 1. Setting up an external identity provider