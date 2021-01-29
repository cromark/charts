cat <<-EOF | kubectl apply -f -
--- 
apiVersion: v1
kind: Namespace
metadata:
  name: mjc
  annotations:
    linkerd.io/inject: enabled
---
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyJkb2NrZXIubmV4dXMuYWV0bmFkaWdpdGFsLmNvbSI6eyJ1c2VybmFtZSI6ImhjY2lyb3N2YyIsInBhc3N3b3JkIjoiNFlFVFdrczNyVGJNNlM4bmsxUmZtMVZZd0UxVVk4MjM9IiwiZW1haWwiOiJsb2NhbEBoYy5hZXRuYS5jb20iLCJhdXRoIjoiYUdOamFYSnZjM1pqT2pSWlJWUlhhM016Y2xSaVRUWlRPRzVyTVZKbWJURldXWGRGTVZWWk9ESXpQUT09In19fQ==
kind: Secret
metadata:
  name: registry
  namespace: mjc
type: kubernetes.io/dockerconfigjson
EOF

```
helm upgrade --install simpleapp2 \
  --namespace=mjc  \
  --set ingress.hostOverride=simpleapp2.192.168.1.29.xip.io \
  --set envname=${_ENV}   \
  -f ${_ROOT_DIR}/values.yaml  \
  -f ${_ROOT_DIR}/examples/deployment.values.${_ENV}.yaml \
  chartmuseum-local/mycro-service
```

## run chartmuseum in docker
```
docker run -d \
  -p 18080:8080 \
  --name=chartmuseum \
  -v $(pwd)/charts:/charts \
  -e STORAGE=local \
  -e STORAGE_LOCAL_ROOTDIR=/charts \
  chartmuseum/chartmuseum:latest
```

## publish/replace chart
```
cd ~/work/helm-charts/mycro-service
V=$(yq r Chart.yaml version)
N=$(yq r Chart.yaml name) # basename $(pwd)
CM=http://chartmuseum.192.168.1.29.xip.io

rm -rf ${N}-${V}.tgz

helm package .
curl -s -XDELETE ${CM}/api/charts/${N}/${V}
curl --data-binary "@${N}-${V}.tgz"  ${CM}/api/charts
```

```
curl -s ${CM}/api/charts | jq .
{
  "mycro-service": [
    {
      "name": "mycro-service",
      "home": "https://git.aetna.com/digital-cloud",
      "sources": [
        "https://git.aetna.com/digital-cloud/helm-charts"
      ],
      "version": "0.10.0",
      "description": "generic micro-service",
      "icon": "https://payorsolutions.cvshealth.com/sites/default/files/cvs-health-payor-solutions-transforming-the-consumer-health-care-model-main-icon-image.gif",
      "apiVersion": "v2",
      "appVersion": "1.0.0",
      "urls": [
        "charts/mycro-service-0.10.0.tgz"
      ],
      "created": "2020-06-06T20:35:01Z",
      "digest": "a693c1ef30bba282c50f2ad1a9614b8224b74dbbaec3273de8a2b2f9d5589cfe"
    }
  ]
}
```

## add to helm
```
helm repo add chartmuseum-local http://chartmuseum.${MY_IP}.xip.io:18080
```

## add to argocd
```
argocd repo add http://${MY_IP}:18080 \
  --type helm  \
  --upsert  \
  --name chartmuseum-local
```

## add to application repo to argocd (TBD)
```
argocd repo add http://${MY_IP}:18080 \
  --type helm  \
  --upsert  \
  --na