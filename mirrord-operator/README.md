# mirrord Operator Helm Crate

To setup the mirrord Operator on your cluster you can use this Helm chart.
You must have a license key or a license certificate (Enterprise).

If you have a license key (usually obtained from https://app.metalbear.co) you can set it using:
* `license.key` in `values.yaml`
* Or you can create a secret with key `OPERATOR_LICENSE_KEY` and set the given key as value, then use `license.keyRef` to reference that secret.
* Or you can store the key in Google Secret Manager and set `license.keyGsmRef` to the secret version reference.

If you have a certificate license (usually part of Enterprise offering) you can:
* Add the contents of your license file to `license.file.secret.data.license.pem` in `values.yaml`
* Or you can create a secret with the following format:
    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
        name: mirrord-operator-license-pem
        namespace: mirrord
    stringData:
        license.pem: LICENSE_CONTENT
    ```
    then reference it using `license.pemRef` in `values.yaml`
* Or you can store the license PEM in Google Secret Manager and set `license.pemGsmRef` to the secret version reference.

### Cloud API key

The **cloud API key** is the default way the operator authenticates to the mirrord cloud. The
operator exchanges it for a short-lived token, then uses that token to fetch its license and make
its other cloud calls over the API. It replaces the standalone license key as the primary
credential.

Existing installs that set only `license.*` keep working (the operator falls back to license-key
authentication), but new installs should set the cloud API key.

Set the key through exactly one of:
* `cloud.apiKey.key` in `values.yaml` (simplest for dev/test; the value lands in the pod spec).
* A Kubernetes secret holding the key under the `apiKey` data key, referenced via
  `cloud.apiKey.keyRef` (recommended for production).
* `cloud.apiKey.gsmRef` to read it from Google Secret Manager (used by us and by customers on
  GCP), accessed via Application Default Credentials like `license.gsmRef` (see `sa.gcpSa`).


### Using an existing ServiceAccount

By default, the chart creates the ServiceAccount named by `sa.name`. To use a ServiceAccount managed outside the chart, create it in the operator namespace and install with:

```yaml
sa:
  create: false
  name: platform-managed-operator
```

The chart still binds its RBAC resources to `sa.name` and configures the operator Deployment to use it.


### Additional Kubernetes resources

Use `extraObjects` to create additional Kubernetes resources as part of the Helm release. Each
object is rendered as a template, so it can reference chart values and release information. For
example, a Secrets Store CSI `SecretProviderClass` can be created alongside the operator:

```yaml
extraObjects:
  - apiVersion: secrets-store.csi.x-k8s.io/v1
    kind: SecretProviderClass
    metadata:
      name: "{{ .Release.Name }}-license"
      namespace: "{{ .Values.namespace }}"
    spec:
      provider: gcp
      parameters:
        secrets: |
          - resourceName: projects/example/secrets/mirrord-license/versions/latest
            path: license
```

These resources are owned by the Helm release and are removed when the release is uninstalled.


### SQS queue splitting

#### IAM Role for the operator's service account

For mirrord's SQS queue splitting feature, the operator has to be able to create, read from, write to, and delete SQS queues.
If the queue messages are encrypted, the operator also needs the `kms:Encrypt`, `kms:Decrypt` and `kms:GenerateDataKey` permissions.

For that, an IAM role with an appropriate policy has to be assigned to the operator's service account.
Follow AWS's documentation on how to do that:

https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html

Pass the ARN of the role in `sa.roleArn` in `values.yaml` or via `--set sa.roleArn=arn:aws:iam::$account_id:role/mirrord-operator-role`.

#### Permissions for target workloads

In order to be targeted with SQS queue splitting, a workload has to be able to read from queues that are created by mirrord.
Any temporary queues created by mirrord are created with the same policy as the original queues they are splitting (with the single change of the queue name in the policy), so if a queue has a policy that allows the target workload to call `ReceiveMessage` on it, that is enough.
However, if the workload gets its access to the queue by an IAM policy (and not an SQS policy, see [SQS docs](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-using-identity-based-policies.html#sqs-using-sqs-and-iam-policies)) that grants access to that specific queue by its exact name, you would have to add a policy that would allow that workload to also read from new temporary queues created by mirrord on the run.


> **Note:** the names of all queues created and deleted by mirrord begin with "mirrord-".
