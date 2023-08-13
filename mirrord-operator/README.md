# mirrord Operator Helm Crate

To setup operator on your cluster you can use this helm crate where you must add `license.key` or license file to `values.yaml` 

Note: Must set `tls.data['tls.key']` and `tls.data['tls.crt']` if `certManager.enabled` is set to `false` 
