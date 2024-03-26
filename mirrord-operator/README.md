# mirrord Operator Helm Crate

To setup the mirrord Operator on your cluster you can use this Helm chart.
You must have a license key or a license certificate (Enterprise).

If you have a license key (usually obtained from https://app.metalbear.co) you can set it using:
* `license.key` in `values.yaml`
* Or you can create a secret with key `OPERATOR_LICENSE_KEY` and set the given key as value, then use `license.keyRef` to reference that secret.

If you have a certificate license (usually part of Enterprise offering) you can:
* Add license file to `license.file.secret.data.license.pem` in `values.yaml`
* Or you can create a secret with the following format:
    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
    name: secret
    namespace: mirrord
    stringData:
        license.pem: LICENSE_CONTENT
    ```
    then reference it using `license.pemRef` in `values.yaml`


### SQS queue splitting

When using EKS we need to allow the operator to modify `sqs` queues

```bash
export account_id=$(aws sts get-caller-identity --query "Account" --output text)

cat >mirrord-operator-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:*"
            ],
            "Resource": [
                "arn:aws:sqs:*:$account_id:*"
            ]
        }
    ]
}
EOF

aws iam create-policy --policy-name mirrord-operator-policy --policy-document file://mirrord-operator-policy.json

export oidc_provider=$(aws eks describe-cluster --name my-cluster --region $AWS_REGION --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

export namespace=mirrord
export service_account=mirrord-operator

cat >trust-relationship.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::$account_id:oidc-provider/$oidc_provider"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "$oidc_provider:aud": "sts.amazonaws.com",
          "$oidc_provider:sub": "system:serviceaccount:$namespace:$service_account"
        }
      }
    }
  ]
}
EOF

aws iam create-role --role-name mirrord-operator-role --assume-role-policy-document file://trust-relationship.json --description "Role for SQS splitting for mirrord-operator"

aws iam attach-role-policy --role-name mirrord-operator-role --policy-arn=arn:aws:iam::$account_id:policy/mirrord-operator-role

```
*[aws docs referance](https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html)*

And setting the `sa.roleArn` value in `values.yaml` or via `--set sa.roleArn=arn:aws:iam::$account_id:role/mirrord-operator-role`
