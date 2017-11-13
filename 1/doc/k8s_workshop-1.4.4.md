# k8s workshop-1.4.4


<!-- MarkdownTOC -->

- [4.4 - Scale](#44---scale)
  - [Manually](#manually)
  - [Via Manifests](#via-manifests)
  - [Online](#online)
  - [AutoScale](#autoscale)

<!-- /MarkdownTOC -->




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