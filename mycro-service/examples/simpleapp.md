# simpleapp

## frontend

```
helm template \
     simpleapp-frontend \
     --namespace=hyperion   \
     --set envname=rc  \
     --set imagename=docker.nexus.aetnadigital.net/simpleapp:0.12.6 \
     -f ./values.yaml \
     -f examples/simpleapp-frontend.yaml  \
    . > simpleapp-frontend-mf.yaml
```

```
kubectl -n hyperion set image deployment/simpleapp-frontend simpleapp-frontend=docker.nexus.aetnadigital.net/simpleapp:0.12.6
watch kubectl get -n hyperion po -l app=simpleapp-frontend
```

## backend

```
helm template \
     simpleapp-backend \
     --namespace=hyperion   \
     --set envname=rc  \
     --set imagename=docker.nexus.aetnadigital.net/simpleapp:0.12.6 \
     -f ./values.yaml \
     -f examples/simpleapp-backend.yaml  \
    . > simpleapp-backend-mf.yaml
```

```
kubectl -n hyperion set image deployment/simpleapp-backend simpleapp-backend=docker.nexus.aetnadigital.net/simpleapp:0.12.6
watch kubectl get -n hyperion po -l app=simpleapp-backend
```