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
  elif [ "$file" = "test_values/mirrord-operator/extra_objects.yaml" ]; then
    echo "running with helm template"
    helm template -f "$file" mirrord-operator ./mirrord-operator > /dev/null
  elif [ "$file" = "test_values/mirrord-operator/operator_openshift.yaml" ]; then
    echo "running with helm template"
    helm template -f "$file" mirrord-operator ./mirrord-operator > /dev/null
  elif [ "$file" = "test_values/mirrord-operator/operator_db_branch_allowed_images.yaml" ]; then
    # Rendering alone can't catch a silently dropped value (helm ignores values no template
    # consumes, and an absent allowedImages list allows every image), so assert the lists
    # actually land in the rendered ConfigMap: one per engine. Update the count when adding
    # an engine - consciously, together with its allowlist support.
    echo "running with helm template and asserting rendered allowlists"
    rendered_allowlists=$(helm template -f "$file" mirrord-operator ./mirrord-operator | grep -c "allowedImages:")
    if [ "$rendered_allowlists" -ne 10 ]; then
      echo "expected 10 rendered allowedImages blocks (one per engine), got $rendered_allowlists"
      exit 1
    fi
  elif [ "$file" = "test_values/mirrord-operator/operator_no_resources.yaml" ]; then
    # Unset quantities have to disappear from the pod specs (operator, sidecar, and agent config)
    # and the ones left alone have to survive - dropping either would still install cleanly here,
    # so assert on the rendered manifests. The kept operator request is a zero, the quantity most
    # easily mistaken for "unset".
    echo "running with helm template and asserting resources render as configured"
    rendered=$(helm template -s templates/deployment.yaml -s templates/config-map.yaml -f "$file" mirrord-operator ./mirrord-operator)
    if echo "$rendered" | grep "limits:"; then
      echo "chart rendered resource limits that the values unset"
      exit 1
    fi
    if ! echo "$rendered" | grep -q "cpu: 0"; then
      echo "chart dropped the operator cpu request that the values kept"
      exit 1
    fi
    if ! echo "$rendered" | grep -q "cpu: 1m"; then
      echo "chart dropped the agent cpu request that the values kept"
      exit 1
    fi
    helm install -f "$file" mirrord-operator ./mirrord-operator --wait
    helm uninstall mirrord-operator --wait
  elif [ "$file" = "test_values/mirrord-operator/operator_existing_service_account.yaml" ]; then
    kubectl create namespace existing-service-account
    kubectl create serviceaccount existing-mirrord-operator --namespace existing-service-account
    helm install -f "$file" mirrord-operator ./mirrord-operator --wait
    helm uninstall mirrord-operator --wait
    kubectl delete namespace existing-service-account --wait
  elif [ "$file" = "test_values/mirrord-operator/extra_env_from.yaml" ]; then
    echo "running with --dry-run"
    # check env was interpreted correctly - failure will not cause an error in helm install
    if helm install -f "$file" mirrord-operator ./mirrord-operator --wait --dry-run="client" | grep "valueFrom:map"; then
        echo "chart did not render 'valueFrom' correctly"
        exit 1
    fi
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
