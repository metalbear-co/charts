# mirrord License Server Helm Crate

### Additional Kubernetes resources

Use `extraObjects` to create additional Kubernetes resources as part of the Helm release. Each
object is rendered as a template, so it can reference chart values and release information. For
example, an External Secrets Operator `ExternalSecret` can provision database credentials that
the license server reads from a Kubernetes Secret:

```yaml
database:
  kind: postgres
  host: postgres.example.com
  name: mirrord-license-server
  auth:
    user:
      secretKeyRef:
        name: mirrord-license-server-database
        key: username
    password:
      secretKeyRef:
        name: mirrord-license-server-database
        key: password

extraObjects:
  - apiVersion: external-secrets.io/v1
    kind: ExternalSecret
    metadata:
      name: mirrord-license-server-database
      namespace: "{{ .Values.namespace }}"
    spec:
      secretStoreRef:
        name: cluster-secret-store
        kind: ClusterSecretStore
      target:
        name: mirrord-license-server-database
      data:
        - secretKey: username
          remoteRef:
            key: license-server-database
            property: username
        - secretKey: password
          remoteRef:
            key: license-server-database
            property: password
```

These resources are owned by the Helm release and are removed when the release is uninstalled.
