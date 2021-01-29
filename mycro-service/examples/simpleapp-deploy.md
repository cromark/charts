# simpleapp

## Env

```
export APP_NS=hyperion
export APP_ENVNAME=rc
export APP_VERSION=$(cat ./.version)
export APP_IMAGE=docker.nexus.aetnadigital.net/simpleapp:${APP_VERSION}

```

## deploy backend

```
pushd $(pwd)
cd ~/work/helm-charts/mycro-service
helm template      \
   simpleapp-backend  \
   --namespace=${APP_NS}  \
   --set envname=${APP_ENVNAME} \
   --set imagename=${APP_IMAGE}  \
   -f ./values.yaml \
   -f examples/simpleapp-backend.yaml   \
   . > simpleapp-backend-mf.yaml 

rc
k apply -f /Users/A810323/work/helm-charts/mycro-service/simpleapp-backend-mf.yaml
watch kubectl -n hyperion get po -l app=simpleapp-backend
#curl -s https://simpleapp-frontend.general.rc.hci.aetna.com/check
popd
```

## deploy frontend

```
pushd $(pwd)
cd ~/work/helm-charts/mycro-service

helm template      \
   simpleapp-frontend  \
   --namespace=${APP_NS}  \
   --set envname=${APP_ENVNAME} \
   --set imagename=${APP_IMAGE}  \
   -f ./values.yaml \
   -f examples/simpleapp-frontend.yaml   \
   . > simpleapp-frontend-mf.yaml
rc
k apply -f /Users/A810323/work/helm-charts/mycro-service/simpleapp-frontend-mf.yaml
watch kubectl -n hyperion get po -l app=simpleapp-frontend
# curl -s https://simpleapp-frontend.general.rc.hci.aetna.com
popd
```