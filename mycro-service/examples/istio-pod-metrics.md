## pod metrics for istio

Add the following annotations to deployment(statefulset)

```
spec:
  template:
    metadata:
      annotations:
        prometheus.io/path: /stats/prometheus
        prometheus.io/port: "15020"
        prometheus.io/scrape: "true"  
```

## prometheus scraper

ref:

https://istio.io/latest/faq/metrics-and-logs/#prometheus-application-metrics
