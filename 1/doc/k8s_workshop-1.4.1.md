# k8s workshop-1.4.1


<!-- MarkdownTOC -->

- [4.1 - Database](#41---database)
  - [Create a Volume](#create-a-volume)
  - [Create a Secrets](#create-a-secrets)
  - [Create the Deployment](#create-the-deployment)
  - [Create the Service](#create-the-service)
  - [Check your DB](#check-your-db)

<!-- /MarkdownTOC -->



### 4.1 - Database

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


> Notes
> --
>
> Since we are NOT using K8s cluster on a cloud provider, we will skip the PERSISTANT volume for now
>



#### Create a Secrets

We will store a "password" as a *Secret object* in kube and will see how to use it in a "deployment"

```
kubectl create secret generic mysql-passwords \
  --from-literal=root=myRootS3cr3t \
  --from-literal=ghost=myS3cr3t
```

```
kubectl describe secret mysql-passwords
```



#### Create the Deployment

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



#### Create the Service

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
> Rememeber the password in Secret section ;)
>


> Note02:
> --
>
> Notice the `SERVICE` discovery in k8s with DNS convention:
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

