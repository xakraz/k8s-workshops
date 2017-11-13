# k8s workshop-1.4.3


<!-- MarkdownTOC -->

- [4.3 - TroubleShoot](#43---troubleshoot)
  - [Get Pods](#get-pods)
  - [Get Pod Logs](#get-pod-logs)
  - [Describe the Deployment](#describe-the-deployment)
  - [Exec and Jump into a Pod](#exec-and-jump-into-a-pod)
  - [Resources ?](#resources-)

<!-- /MarkdownTOC -->




### 4.3 - TroubleShoot

#### Get Pods

```
kubectl get pods -w
```



#### Get Pod Logs

```
kubectl logs ghost-651739629-00h4j -c nginx --tail=5 -f
```



#### Describe the Deployment

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

