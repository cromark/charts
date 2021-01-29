# k3s node (vagrant)
> https://rancher.com/docs/k3s/latest/en/quick-start/

## run agent

> must set flannel interface to eth1 because it uses wireless

```
export K3S_URL=https://ubuntu:6443
export K3S_TOKEN=K101ab32ef2bc60acbf18aeab47eecb0a67655ef71699aaf9ad4505642beb9b7f31::server:d198a33311f69c4b58df51635ef28a43
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-label worker=vagrant --flannel-iface=eth1" sh -s - 
```

## status

```
systemctl status k3s-agent
```

## remove

> issue with nodes  https://github.com/rancher/k3s/issues/872

```
/usr/local/bin/k3s-uninstall.sh
```
