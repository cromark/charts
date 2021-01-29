# squid testing

## netshoot

```
k exec -it netshoot sh
```

## env

```
export http_proxy=http://squid.cromark.svc:3128
```


> Note:  no ssl , gets 400 error

```
#export https_proxy=http://squid.cromark.svc:3128
```

## curl

```
curl -vLs -o /dev/null http://www.example.com
```

## api/com

```
curl -vLs https://qaapih1.aetna.com/identitymanagement/qapath1/v9/auth/oauth2/token
```