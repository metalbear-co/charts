#!/bin/sh

set -e

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/mirrord-operator/*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  # helm will wait forever for the volumes to be ready unless `--dry-run` is used
  if [ "$file" = "test_values/mirrord-operator/extra_volumes.yaml" ]; then
    echo "running with --dry-run"
    helm install -f "$file" mirrord-operator ./mirrord-operator --wait --dry-run="client"
  elif [ "$file" = "test_values/mirrord-operator/operator_openshift.yaml" ]; then
    echo "running with helm template"
    helm template -f "$file" mirrord-operator ./mirrord-operator > /dev/null
  elif [ "$file" = "test_values/mirrord-operator/operator_existing_service_account.yaml" ]; then
    kubectl create namespace existing-service-account
    kubectl create serviceaccount existing-mirrord-operator --namespace existing-service-account
    helm install -f "$file" mirrord-operator ./mirrord-operator --wait
    helm uninstall mirrord-operator --wait
    kubectl delete namespace existing-service-account --wait
  else
    helm install -f "$file" mirrord-operator ./mirrord-operator --wait
    helm uninstall mirrord-operator --wait
  fi
  echo "::endgroup::"
done


# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/mirrord-license-server/*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  # helm will wait forever for the volumes to be ready unless `--dry-run` is used
  
  echo "running with --dry-run=\"server\""
  helm install -f "$file" mirrord-license-server ./mirrord-license-server --wait --dry-run="server"

  echo "::endgroup::"
done
