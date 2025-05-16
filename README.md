# Metalbear Helm Charts

## mirrord operator

The [mirrod operator](https://metalbear.co/mirrord/docs/overview/teams/) is a component
that runs in your Kubernetes cluster and manages the concurrent use of mirrord by multiple
users in the organization. With the operator, users don't need Kubernetes API permissions
(RBAC is managed through the operator); agents are reused so multiple agents don't
impersonate the same pod; and deployments can be impersonated so that traffic from all
their pods is stolen/mirrored.

- [mirrord-operator](./mirrord-operator)

## mirrord license server

The [mirrord license server](https://metalbear.co/mirrord/docs/managing-mirrord/license-server/)
enables you to manage your organization’s seats without sending any data to mirrord’s
servers. It can aggregate license metrics from multiple operators
(useful if you’re running mirrord across multiple clusters) and provides visibility into
seat usage across your organization.

- [mirrord-license-server](./mirrord-license-server)

## Quick setup

```bash
helm repo add metalbear https://metalbear-co.github.io/charts
```

Then download the accompanying `values.yaml`:

```bash
curl https://raw.githubusercontent.com/metalbear-co/charts/main/mirrord-operator/values.yaml --output values.yaml
```

Open `values.yaml` and populate the `license` with either your license key, or with your
license `.pem` file contents.

Additionally, the mirrord Operator requires a certificate. You can either:
* Set `certManager.enabled` to `false` and provide your own certificate in `tls.key`, `tls.crt`
* Set `certManager.enabled` to `true` and [install cert-manager](https://cert-manager.io/docs/installation/helm/) in your cluster.

Finally, install the chart:

```bash
helm install -f values.yaml mirrord-operator metalbear/mirrord-operator 
```

## Detailed setup

Some mirrord operator features come **disabled** by default, and some additional
configuration might be needed to tailor the operator for your environment.

In the following sections we'll help you in setting up `values.yaml` for both the mirrord
operator and the mirrord license server (relevant only if you have a license `.pem` file
and want to run the server on-premise).

- Before proceeding, you'll need mirrord for Teams, you can find more information about
  acquiring it from our [metalbear.co pricing](https://metalbear.co/mirrord/pricing/) page.

### mirrord operator

#### Operator namespace and namespaced roles

You can configure the kubernetes `namespace` that the operator will be deployed in. It also
affects where the mirrord agent pod is spawned when using the
[copy target feature](https://metalbear.co/mirrord/docs/using-mirrord/copy-target/).

- `createNamespace` is set to `true` by default, meaning that the `namespace`
  (default `mirrord`) will be created on chart install, if it's set to `false`, then you
  must create the `namespace`;
- `roleNamespaces` can be set to create namespaced `role`s. (What is this? I had to create the namespace before being able to use it, so mention that.)

```yaml
namespace: mirrord
createNamespace: true
roleNamespaces: []
```

### mirrord license server {#mirrord-license-server}
