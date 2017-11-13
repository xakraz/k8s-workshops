# k8s workshop-1.4.5


<!-- MarkdownTOC -->

- [4.5 - Rolling Update](#45---rolling-update)
  - [Update](#update)
  - [Rollback](#rollback)

<!-- /MarkdownTOC -->




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
> - `kubectl deploy ... --record`
> - `kubectl rollout history deployment DEPLOY_NAME`
> - `kubectl rollout history deployment DEPLOY_NAME --revision=2`
> - `kubectl rollout undo deployment DEPLOY_NAME --to-revision=2`