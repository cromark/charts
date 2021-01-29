## testing

### lint

```
helm lint      --namespace=${_NS}     --set imagename=gcr.io/kuar-demo/kuard-amd64:2      --set envname=${_ENV}     -f flagger.values.${_ENV}.yaml      -f ${_ROOT_DIR}/values.yaml  ${_ROOT_DIR}
```

### flagger

```
helm template  \
    sample \
    --namespace=foo \
    --set imagename=gcr.io/kuar-demo/kuard-amd64:2  \
    --set envname=dev \
    -f examples/flagger.values.dev.yaml  \
    -f ./values.yaml \
    --show-only templates/canary.yaml \
    --show-only templates/deployment.yaml \
    . 
```

### deployment

```
helm template  \
    sample \
    --namespace=foo \
    --set envname=dev \
    -f examples/deployment.values.dev.yaml  \
    -f ./values.yaml \
    --set gateway.enabled=true \
    --set gateway.hostPath=sample.general.dev.hci.aetna.com \
    --set gateway.hostOverride=sample-override.general.dev.hci.aetna.com \
    . 
```

```
    --show-only templates/deployment.yaml 
```

### gateway

```
helm template  \
    sample  \
    --namespace=foo \
    --set imagename=gcr.io/kuar-demo/kuard-amd64:2 \
    --set envname=dev  \
    -f examples/deployment.values.dev.yaml \
    -f ./values.yaml  \
    .
```