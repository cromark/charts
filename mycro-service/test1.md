```
kubectl create ns foo
```

## mainstream deploy
```
helm template \
    podinfo  \
    --namespace=foo \
    --set imagename=stefanprodan/podinfo:5.1.2 \
    -f ./values.yaml \
    -f examples/flagger.values.dev.yaml  \
    --set domain=$(echo $MY_IP).xip.io \
     . | kubectl apply -f -
```

```
k get -n foo po,svc,ing,sa,cm
```

```
kubectl create ns foo-feature-mjc0
```

## feature deploy
```
helm template \
    podinfo  \
    --namespace=foo \
    --set imagename=stefanprodan/podinfo:5.1.2 \
    -f ./values.yaml \
    -f examples/flagger.values.dev.yaml  \
    --set domain=$(echo $MY_IP).xip.io \
    --set feature=feature/mjc0 . | kubectl apply -f -
```

```
k get -n foo-feature-mjc0 po,svc,ing,sa,cm
```

```
watch kubectl get -n foo-feature-mjc0 po
```

## env

```
env:
  PODINFO_UI_COLOR: blue
  PODINFO_UI_MESSAGE: "Eat at Joe's"
```

## check content

```
curl -s http://podinfo.dev.192.168.1.58.xip.io
{
  "hostname": "podinfo-bbd55ccc8-wj5qf",
  "version": "5.1.2",
  "revision": "",
  "color": "blue",
  "logo": "https://raw.githubusercontent.com/stefanprodan/podinfo/gh-pages/cuddle_clap.gif",
  "message": "Eat at Joe's",
  "goos": "linux",
  "goarch": "amd64",
  "runtime": "go1.15.6",
  "num_goroutine": "9",
  "num_cpu": "4"
}
```

## load

```
hey -n 200 -c 50 http://podinfo.dev.192.168.1.58.xip.io
```