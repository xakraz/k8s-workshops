# k8s workshop-1.4.2


<!-- MarkdownTOC -->

- [4.2 - The Ghost App](#42---the-ghost-app)
  - [Service](#service)
  - [Sercret](#sercret)
  - [ConfigMap](#configmap)
  - [Deployment](#deployment)

<!-- /MarkdownTOC -->




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
sed -i "s/foo/${NAMESPACE}/g" app/configs/config.js
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


> Question:
> --
>
> Does everything work ?
>
> => Answer is "nope", that would be too easy ^^
>
> Time for debugging:

