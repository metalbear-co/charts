# MetalBear Helm Charts

## Overview

This repository contains Helm charts for deploying [mirrord](https://metalbear.co/mirrord) components to Kubernetes:

- [`mirrord-operator`](./mirrord-operator): Manages concurrent usage of mirrord in multi-user environments.
- [`mirrord-license-server`](./mirrord-license-server): Handles license management without external telemetry (Enterprise only).

---

## mirrord Operator

The [mirrord Operator](https://metalbear.co/mirrord/docs/overview/teams/) is a Kubernetes component that facilitates the concurrent use of mirrord by multiple team members. 

For full feature details, visit the [mirrord pricing page](https://metalbear.co/mirrord/pricing/).

---

## mirrord License Server

The [mirrord License Server](https://metalbear.co/mirrord/docs/managing-mirrord/license-server/) enables on-prem license seat tracking without any data leaving your infrastructure. It aggregates metrics across clusters and provides centralized license visibility.

> ⚠️ Only available in the **Enterprise** plan.

---

## Quick Start

Add the MetalBear Helm repo:

```bash
helm repo add metalbear https://metalbear-co.github.io/charts
```

Download the default values file:

```bash
curl https://raw.githubusercontent.com/metalbear-co/charts/main/mirrord-operator/values.yaml --output values.yaml
```

Edit `values.yaml` to include your license:

- Team license key: insert your key in the `license` field.
- Enterprise license `.pem`: paste your certificate content.

Configure TLS:

- **Option A**: Use your own cert (`certManager.enabled: false`) and provide `tls.crt` / `tls.key`.
- **Option B**: Enable `certManager.enabled: true` and [install cert-manager](https://cert-manager.io/docs/installation/helm/).

Install the operator:

```bash
helm install -f values.yaml mirrord-operator metalbear/mirrord-operator
```

---

## Advanced Configuration

### Operator License

#### 🧑‍💻 Team License

Set the license key directly:

```yaml
license:
  key: "my-team-license-key"
```

Or use a Kubernetes secret:

```yaml
license:
  keyRef: "my-secret:OPERATOR_LICENSE_KEY"
```

#### 🧑‍💼 Enterprise License

Paste the `.pem` certificate:

```yaml
license:
  file:
    data:
      license.pem: |
        -----BEGIN CERTIFICATE-----
        ...
        -----END CERTIFICATE-----
        -----BEGIN PRIVATE KEY-----
        ...
        -----END PRIVATE KEY-----
```

Or reference a secret:

```yaml
license:
  pemRef: "mirrord-operator-license-pem:license.pem"
```

---

### Namespace & Role Configuration

Specify the namespace and control role-based access:

```yaml
namespace: mirrord
createNamespace: true
roleNamespaces: []
```

Set user privileges using `role` and `clusterRole` labels:

```yaml
role:
  mirrord-operator-user:
    labels:
      team: platform

clusterRole:
  mirrord-operator-user-basic:
    labels:
      team: basic
  mirrord-operator-user:
    labels:
      team: platform
```

> Learn more about [copy-target namespaces](https://metalbear.co/mirrord/docs/using-mirrord/copy-target/).

---

### Operator Settings

Basic configuration:

```yaml
operator:
  image: ghcr.io/metalbear-co/operator
  podAnnotations:
    prometheus.io/scrape: "true"
  podLabels:
    environment: staging
  limits:
    cpu: 200m
    memory: 200Mi
  metrics: true
  extraEnv:
    OPERATOR_METRICS_ADDR: "0.0.0.0:9000"
  disableTelemetries: false
  port: 443
  imagePullSecrets:
    - name: regcred
  jsonLog: false
```

---

### Feature Toggles

#### 👥 SQS Splitting

Enable SQS message routing for shared queues:

```yaml
operator:
  sqsSplitting: true
```

More info: [SQS Splitting Docs](https://metalbear.co/mirrord/docs/using-mirrord/queue-splitting/#sqs-splitting)

#### 🪶 Kafka Splitting

Enable topic-level session isolation for Kafka:

```yaml
operator:
  kafkaSplitting: true
  idleKafkaSplitTtlMillis: 30000
```

Learn about:
- [Kafka setup](https://metalbear.co/mirrord/docs/using-mirrord/queue-splitting/#kafka-splitting)
- [TTL behavior](https://github.com/metalbear-co/charts/tree/main/mirrord-operator#sqs-queue-splitting)

#### 📝 Copy Target

Control agent image usage:

```yaml
operator:
  copyTarget:
    useAgentImage: true
```

---

### mirrord-Agent Configuration

Customize the mirrord-agent container:

```yaml
agent:
  image: ghcr.io/metalbear-co/agent
  port: 7777
  tls: true
  extraConfig:
    agent:
      metrics: "0.0.0.0:9000"
      annotations:
        prometheus.io/scrape: "true"
      log_level: "mirrord=debug,warn"
```

Refer to the [agent configuration docs](https://metalbear.co/mirrord/docs/reference/configuration/#root-agent) for more details.

---

## mirrord License Server

[mirrord-license-server](./mirrord-license-server)

Configure this chart if you use a `.pem` license and want full control of your seat usage on-premise. See full instructions in the [license server docs](https://metalbear.co/mirrord/docs/managing-mirrord/license-server/).

---

## Useful Links

- 🌐 [mirrord Documentation](https://metalbear.co/mirrord/docs/overview/introduction/)
- 💰 [mirrord Pricing](https://metalbear.co/mirrord/pricing/)
