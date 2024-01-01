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
