# MetalBear Helm Charts

## mirrord Operator

The [mirrord operator](https://metalbear.co/mirrord/docs/overview/teams/) is a component
that runs in your Kubernetes cluster and manages the concurrent use of mirrord by multiple
users in the organization. For more details and a list of features of the mirrord Operator
see [this](https://metalbear.co/mirrord/pricing/).

- [mirrord-operator](./mirrord-operator)

## mirrord License Server

The [mirrord license server](https://metalbear.co/mirrord/docs/managing-mirrord/license-server/)
enables you to manage your organization’s seats without sending any data to mirrord’s
servers. It can aggregate license metrics from multiple operators
(useful if you’re running mirrord across multiple clusters) and provides visibility into
seat usage across your organization.

- [mirrord-license-server](./mirrord-license-server)

## Quick Setup

```bash
helm repo add metalbear https://metalbear-co.github.io/charts
```

Then download the accompanying `values.yaml`:

```bash
curl https://raw.githubusercontent.com/metalbear-co/charts/main/mirrord-operator/values.yaml --output values.yaml
```

Open `values.yaml` and populate the `license` with either your license key, or with your
license `.pem` certificate contents.

Additionally, the mirrord Operator requires a certificate. You can either:
* Set `certManager.enabled` to `false` and provide your own certificate in `tls.key`, `tls.crt`
* Set `certManager.enabled` to `true` and [install cert-manager](https://cert-manager.io/docs/installation/helm/) in your cluster.

Finally, install the chart:

```bash
helm install -f values.yaml mirrord-operator metalbear/mirrord-operator
```

## Advanced Configuration

Some mirrord operator features come **disabled** by default, and some additional
configuration might be needed to tailor the operator for your environment.

In the following sections we'll help you in setting up `values.yaml` for both the mirrord
operator and the mirrord license server (relevant only if you have a license `.pem` certificate
and want to run the server on-premise).

- Before proceeding, you'll need mirrord for Teams, you can find more information about
  acquiring it from our [metalbear.co pricing](https://metalbear.co/mirrord/pricing/) page.

### mirrord operator

#### Operator license

- Team license key

If you're subscribed to mirrord for Teams for a Team license, then all you have to do is set the
`license` field to use your key, either directly, or create a secret with the key `OPERATOR_LICENSE_KEY`,
then use `license.keyRef` to reference it. You can find your license key in the
[app.metalbear page](https://app.metalbear.co/).

```yaml
license:
  key: "my-team-license-key"
```

Or with `keyRef.

```yaml
license:
  keyRef: "secret-name:key-name"
```

- Enterprise license

Enterprise users receive a `.pem` certificate that you can add directly to
`license.data.license.pem`.

```yaml
license:
  file:
    data:
      license.pem: |
        -----BEGIN CERTIFICATE-----
        thecertificate
        -----END CERTIFICATE-----
        -----BEGIN PRIVATE KEY-----
        thekey
        -----END PRIVATE KEY-----
```

Or you can create a secret with the following format:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: mirrord-operator-license-pem
    namespace: mirrord
stringData:
    license.pem: LICENSE_CONTENT
```

Then reference it in the `license.pemRef` field.

```yaml
license:
  pemRef: "mirrord-operator-license-pem:license.pem"
```

#### Operator namespace and user roles

You can configure the kubernetes `namespace` that the operator will be deployed in. It also
affects where the mirrord agent pod is spawned when using the
[copy target feature](https://metalbear.co/mirrord/docs/using-mirrord/copy-target/).

- `createNamespace` is set to `true` by default, meaning that the `namespace`
  (default `mirrord`) will be created on chart install, if it's set to `false`, then you
  must create the `namespace`;

If you want to limit which `namespace`s user's may use mirrord in, it can be accomplished
with the `roleNamespaces` setting. Note that the `namespace`s must be created beforehand,
this does **not** create them. We do not recommend doing it this way, instead prefer
to have a role binding (or a cluster role binding) that references a cluster role.

```yaml
namespace: mirrord
createNamespace: true
roleNamespaces: []
```

The operator uses the `mirrord-operator-user.labels` to manage and identify user prileveges
and roles. You can configure this at a namespaced level, under `role`, or at a cluster
level under `clusterRole`.
They are used in RBAC to manage the access of a user to operator features.

```yaml
role:
  mirrord-operator-user:
    labels:
      app.kubernetes.io/component: "debugging"
      team: "platform"
```

- At a cluster level, there's also support for a _basic_ operator user, that can be used to
  grant limited permissions (only the minimal things you must have on the cluster role).
  Think of this as a minimally privileged access that a user may have, when using mirrord.

```yaml
clusterRole:
  mirrord-operator-user-basic:
    labels:
      app.kubernetes.io/component: "debugging"
      team: "basic"
  mirrord-operator-user:
    labels:
      app.kubernetes.io/component: "debugging"
      team: "platform"
```

#### General operator configuration

The operator `image` is sourced by default from `ghcr.io/metalbear-co/operator`, but you can
change that to your own repository.

You can set `annotations` and `labels` to the operator pod, to enable things like
[prometheus](https://prometheus.io/) for the operator. The operator may spawn mirrord-agent
pods, but those pods have their own `annotations` and `labels` configuration.

```yaml
operator:
  image: ghcr.io/metalbear-co/operator
  podAnnotations:
    prometheus.io/scrape: "true"
  podLabels:
    environment: staging
```

By default, `limits` is set to a value that should accomodate roughly 200 concurrent mirrord
sessions.

```yaml
operator:
  limits:
    cpu: 200m
    memory: 200Mi
```

If you have [prometheus](https://prometheus.io/) running in your cluster, you can enable
the operator metrics endpoint (on `0.0.0.0:9000` by default) by changing `metrics` to `true`
(it comes as `false` by default). It's possible to chage the address by setting the
`OPERATOR_METRICS_ADR` environment variable in `extraEnv`.

```yaml
operator:
  metrics: true
  extraEnv:
    OPERATOR_METRICS_ADDR: "0.0.0.0:9000"
```

- `extraEnv` may be used for more than just changing the prometheus address. It can be
  especially useful when debugging the operator itself, or to change something in the operator
  that hasn't been exposed by the chart.

It's possible to disable the operator telemetries (only for Enterprise license) by changing
the default `disableTelemetries` to `true`.

```yaml
operator:
  disableTelemetries: false
```

The operator listens on port `443` by default, and this too can be changed.

```yaml
operator:
  port: 443
```

Set `imagePullSecrets` if your operator or agent images are not public.

```yaml
operator:
  imagePullSecrets:
  - name: regcred
```

The operator logs can be shown in a terminal friendly way, or as JSON.

```yaml
operator:
  jsonLog: false
```

#### Configuring operator features

- [SQS splitting](https://metalbear.co/mirrord/docs/using-mirrord/queue-splitting/#sqs-splitting)

Change the default `sqsSplitting` from `false` to `true`. You can get more details on
[getting started with SQS splitting](https://metalbear.co/mirrord/docs/using-mirrord/queue-splitting/#getting-started-with-sqs-splitting).

```yaml
operator:
  sqsSplitting: true
```

You can find more information on what's needed for the operator to work with SQS
[here](https://github.com/metalbear-co/charts/tree/main/mirrord-operator#sqs-queue-splitting).

- [Kafka splitting](https://metalbear.co/mirrord/docs/using-mirrord/queue-splitting/#kafka-splitting)

Change the default `kafkaSplitting` from `false` to `true`. You can get more details on
[getting started with Kafka splitting](https://metalbear.co/mirrord/docs/using-mirrord/queue-splitting/#getting-started-with-kafka-splitting).

You can change the default TTL (in milliseconds) for idle Kafka splits with
`idleKafkaSplitTtlMillis`.For any given topic, starting the first Kafka splitting session
requires patching the target workload. Similarly, stopping the last Kafka splitting session
requires another patch, that reverts the first one. If the target workload takes a long
time to restart, it may be desirable to keep the Kafka splits alive longer, so that the next
Kafka splitting session will not have to patch the workload again.
It can be overridden per topic with the `spec.splitTtl` field in the
`MirrordKafkaTopicsConsumer` custom resource.

```yaml
operator:
  kafkaSplitting: true
  idleKafkaSplitTtlMillis: 30000
```

- [Copy target](https://metalbear.co/mirrord/docs/using-mirrord/copy-target/)

The operator creates a dummy container using the mirrord-agent image by default. Doing so
ensures that it has a `sleep` binary available. If you want the operator to use the target's
image, you can change `copyTarget.useAgentImage` to `false` and make sure it has the `sleep` binary.

```yaml
operator:
  copyTarget:
    useAgentImage: true
```

#### Configuring the mirrord-agent

The agent `image` is sourced by default from `ghcr.io/metalbear-co/agent`, but you can change that
to your own repository.

```yaml
agent:
  image: ghcr.io/metalbear-co/agent
```

You can set on which port the agent accepts connections from the operator with the `agent.port`
config, by default a random port is assigned. These connections can be secured with TLS by setting
`agent.tls` to `true`.

```yaml
agent:
  port: 7777
  tls: true
```

It's possible to change
[mirrord-agent settings](https://metalbear.co/mirrord/docs/reference/configuration/#root-agent)
that are not exposed by the chart with the `agent.extraConfig` config, these include (but are not
limited by).

```yaml
agent:
  extraConfig:
    agent:
      metrics: "0.0.0.0:9000
      annotations: { prometheus.io/scrape: "true" }
      log_level: "mirrord=debug,warn"
```

### mirrord license server {#mirrord-license-server}

[mirrord-license-server](./mirrord-license-server)
