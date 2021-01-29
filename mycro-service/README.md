# micro-service



## Introduction

`micro-service` is a generic helm chart which is used for deployment. The `micro-service` chart will create the following resources

- deployment
- service

and optionally create the following resources

- ingress
- configmap

Advanced features include support for vault secrets, horizontal pod autoscaling, health check setup and ingress  host setup for f5 



## Chart Usage

Typically the chart is used by the [deployment process] and application teams need only worry about the **configuration** parameters as used by their application services. The micro-service chart configuration uses sensible *defaults* which can be easily overriden when required. The section  Configuration below describes the configurable parameters and subsquent sections also describe specific senarios for configuration.



> ref see how used in spinnaker harness



## Configuration

The following table lists the configurable parameters of the `micro-service` chart and their default values.

Default values are found in the file **values.yaml**

| Parameter                              | Description                                                                                                                  | Default                                           |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| `replicas`                                              | The number of replicas to run                                | `1`                                                 |
| `pullSecret`            | The pullsecret to pull image from. **Note**: pullSecret is required for bansai mutating webhook | `registry`                             |
| `imageTag`                             |                                        |                                            |
| `image.pullPolicy`                                      | The image pull policy                                        | `IfNotPresent`                                      |
|                                                         |                                                              |                                                     |
| `metadataAnnotations`                                   | Optional metadataAnnotations                                 | `{}`                                                |
| `specTemplateMetadataAnnotations`                       | Optional specTemplateMetadataAnnotations                     | `{}`                                                |
| `ports.http.externalPort`                               | The microservice external port                               | `8080`                                              |
| `ports.http.internalPort`                               | The microservice internal port                               | `8080`                                              |
| `ports.http.protocol`                                   | The microservice protocol                                    | `TCP`                                               |
| `service.annotations` | Optional service annotations                     | `{}`                                       |
| `ingress.enabled`                                       | Enable ingress                                               | `false`                                             |
| `ingress.host`      | Optional Ingress host                                                                              | None                                          |
| `ingress.tls`  | Enable TLS                                                                                            | `""`                                              |
| `ingress.tlsSecret`             | TLS Secret | `[]`                          |
| `ingress.annotations`      | Ingress annotations                                                                | `{}`                                              |
| `livenessProbe` | liveness probe. See section Readiness and Liveness below | `{}` |
| `readinessProbe` | readiness probe. See section Readiness and Liveness below | `{}` |
| `env` | Environment variables for the container | `{}` |
|   |     |      |
| `secrets.enabled` | Enable vault secrets support | `false` |
| `secrets.env` | Secrets variables for the container | `{}` |
|   |     |      |
| `hpa.enabled` | Enabled HPA support | `false` |
| `hpa.memAverageUtilizationPercentage` | memory avg utilization | None |
| `hpa.cpuAverageUtilizationPercentage` | cpu avg utilization  | None |
| `hpa.minReplicas` | minimum replicas | value of `replicas` |
| `hpa.maxReplicas` | maximum replicas | value of `replicas` + 2 |
|   |     |      |
| `resources`                       |                                                              | `{}`           |
|                                   |                                                              |                |
| `securityContext`                 | Security context                                             | `{}`           |
| `nodeSelector`                         | Node labels for pod assignment                                                                                               | `{}`                                              |
| `affinity`                             | Affinity settings                                                                                                            | `{}`                                              |
| `tolerations`                          | List of node taints to tolerate                                                                                              | `[]`                                              |



### Secrets

The `secrets` configuration allow you to specify application secrets as they are defined in **vault**

Secrets are enabled by the setting `secrets.enabled: true`. This will automatially configure the annotations in the pod to provision the vault secrets support

> Note: secrets support for application , role and it's namespace for **vault** **must** be previously enabled by operations. Please reach out to operations in order to verify if vault enablement has been configured for your application prior to setting these variables



Example

```yaml
secrets: 
  enabled: true
  env:
    SPRING_DATA_MONGODB_PASSWORD: vault:kv/digital-cloud/dev/doc-db#password
```



### Port Settings and Health Checks

The `port` configuration allow you to specify application ports to be used in pod and service settings. By default a port name `http` is set for the main service port which is assumed to be an HTTP web listener

The default settings look like the following 

```yaml
ports:
  http:
    externalPort: 8080
    internalPort: 8080
    protocol: TCP
```

The example above assumes that the internal port (aka pod) is _listening_ on `8080` for incoming connections. (for example, this is the default for Spring Boot applications)



### Ingress

Ingress allows applications **optionally** to expose their services outside the default kubernetes network. Typically ingresses are mapped to a **local balancer** either internally (i.e _**intranet**_) or externally (i.e _**extranet**_)

The typical ingress  look like the following 

```yaml
ingress:
  enabled: true
  tls: true
```

The `url` defined by the ingress is **automatically on constructed** based on the applications variables.

​	`${application-name}.${environment-name}.hci.aetna.com`

Where `${application-name}` is
and `${environment-name}` is 



##### Example

if `${application-name}` is `kuard` and `${environment-name}` is `dev` and `tls: true`

The ingress url would be `https://kuard.dev.hci.aetna.com`



#### Optional ingress configurations

The ingress configuration allows some additional settings for special senarios. These special senarios are described in the follow sections.

#### tls secret

he typical ingress  look like the following 

```yaml
ingress:
  enabled: true
  tls: true
  tlsSecret: superSecret
```



> Note: It is **extremely rare** that you woul need to set this value. Use care in setting this value and verify this setting with an operation prior to setting this value

#### 

#### external host

The variable `externalHost`  can be used to create a **second** ingress the typically is used to create an external host for example on hosted **f5** that acts as a `passthru` to the application service.

You define an external host by setting the `externalHost` variable as shown in the following example

```yaml
ingress:
  enabled: true
  tls: true
  externalHost: api.health-cloud.aetna.com
```



> Note: You must first get the value for the `externalHost` from the operations team.



### Health Checks

An optional `health check` port can be defined which will allow application readiness and liveness checks (see below) to be performed on the application. A best practice is to perform the readiness and liveness checks on a _separate_ port than the main application port. In order to support a separate port you create a port block called `maintenance` with an internal and external port defined

An example would looks as follows.

```yaml
ports:
  ...
  maintenance:
    externalPort: 8888
    internalPort: 8888
    protocol: TCP
```

**Notes**:

The name `mainteance` can be any value but is recommended. The name is referenced in the readiness and liveness checks (see below)

`internalPort` corresponds to the port **in** the *pod*. `externalPort` corresponds to the port **defined** by the *service*



### Readiness and Liveness

The optional readiness and liveness checks are defined in the corresponding `readinessProbe` and `livenessProbe` sections

Readiness and liveness checks are specified as `yaml` like in the following example.  

```yaml
readinessProbe:
  httpGet:
    port: maintenance  
    path: /healthz
  initialDelaySeconds: 30
  periodSeconds: 30

livenessProbe:
  httpGet:
    port: maintenance  
    path: /healthz
  initialDelaySeconds: 30
  periodSeconds: 30
```

**Notes**:

It is _highly recommended_ that the health check port is **not** the main application port (eg. http) so health checks are only visible internally and are no mapped to **ingress** definitions

The port `mainteance` is referenced in the port definition (see above)

**Reference**:

### Resources

The `resources` configuration allow you to specify cpu and memory allocations for your application components. Resources are specified as `yaml` like in the following example 

```yaml
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 100m
    memory: 128Mi
```


You can include both `requests` and `limit` blocks and `cpu`and `memory` values for each



> Note:
>
> The recommendation is to make  `requests` and `limit` blocks the same. See references section below for advanced configuration information.

**References**:

https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/#specify-a-cpu-request-and-a-cpu-limit

### Support for standard Labels

Resources should include support for standard labels

> https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/

## Testing the Chart

This section describes how chart developers or application users can test the `micro-service`chart in order to observe the behavior of the configuration settings.

### Prerequisites

In order to test locally you must install  `helm`. On a Mac use the [homebrew tools](https://brew.sh/) and us the following command



> Note: The version 2.0 of helm is used. Do **not** install the 3.0 version

`brew install kubernetes helm` 



### Testing

examples are found in the **examples** folder

The examples tempate expects

| Variable  | Description      | Notes                                                        |
| --------- | ---------------- | ------------------------------------------------------------ |
| name      | application name |                                                              |
| namespace | namespace        |                                                              |
| imagename | image name       |                                                              |
| envname   | environment      | Possible Values<br />lab<br />infra<br />**dev**<br />**test**<br />**prod** |
|           |                  |                                                              |
|           |                  |                                                              |



##### Input files

| Variable                                           | Description           | Notes |
| -------------------------------------------------- | --------------------- | ----- |
| ../examples/mongostarter.values.${DEPLOY_ENV}.yaml | application variables |       |
| ../values.meta.yaml                                | **global variables ** |       |

Where `${DEPLOY_ENV}` is name of environment



#### Example 1: just output ingress template


```bash
cd examples

unset _ROOT_DIR _ENV _APP _NS

export _ROOT_DIR=$(dirname $(pwd))
export _ENV=dev
export _APP=kuard2
export _NS=digital-cloud

helm template  \
    --name=${_APP} \
    --namespace=${_NS} \
    --set imagename=gcr.io/kuar-demo/kuard-amd64:2  \
    --set envname=${_ENV} \
    -f kuard.values.${_ENV}.yaml  \
    -f values.meta.yaml \
    ${_ROOT_DIR} | kubectl apply -f - 
```

#### Example 2: just output ingress template

**hint** use `-x`
example `-x -x ${_ROOT_DIR}/templates/deployment.yaml`

```bash
helm template  \
    --name=${_APP} \
    --namespace=${_NS} \
    --set imagename=gcr.io/kuar-demo/kuard-amd64:2  \
    --set envname=${_ENV} \
    -f kuard.values.${_ENV}.yaml  \
    -f values.meta.yaml \
    -x ${_ROOT_DIR}/templates/deployment.yaml \
    ${_ROOT_DIR} | kubectl apply -f -
```



