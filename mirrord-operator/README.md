# mirrord Operator Helm Crate

To setup the mirrord Operator on your cluster you can use this Helm chart.
You must have a license key or a license certificate (Enterprise).

If you have a license key (usually obtained from https://app.metalbear.co) you can set it using:
* `license.key` in `values.yaml`
* Or you can create a secret with key `OPERATOR_LICENSE_KEY` and set the given key as value, then use `license.keyRef` to reference that secret.

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


### SQS queue splitting

#### IAM Role for the operator's service account

For mirrord's SQS queue splitting feature, the operator has to be able to create, read from, write to, and delete SQS queues.
If the queue messages are encrypted, the operator also needs the `kms:Encrypt`, `kms:Decrypt` and `kms:GenerateDataKey` permissions.

For that, an IAM role with an appropriate policy has to be assigned to the operator's service acount.
Follow AWS's documentation on how to do that:

https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html

Pass the ARN of the role in `sa.roleArn` in `values.yaml` or via `--set sa.roleArn=arn:aws:iam::$account_id:role/mirrord-operator-role`.

#### Permissions for target workloads

In order to be targeted with SQS queue splitting, a workload has to be able to read from queues that are created by mirrord.
Any temporary queues created by mirrord are created with the same policy as the orignal queues they are splitting (with the single change of the queue name in the policy), so if a queue has a policy that allows the target workload to call `ReceiveMessage` on it, that is enough.
However, if the wokrload gets its access to the queue by an IAM policy (and not an SQS policy, see [SQS docs](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-using-identity-based-policies.html#sqs-using-sqs-and-iam-policies)) that grants access to that specific queue by its exact name, you would have to add a policy that would allow that workload to also read from new temporary queues created by mirrord on the run.


> **Note:** the names of all queues created and deleted by mirrord begin with "mirrord-".
