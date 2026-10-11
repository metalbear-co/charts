#!/bin/sh

set -e

# Optional first argument selects filenames containing this text.
filter=${1:-}

# A namespace the chart created can still be Terminating after `helm uninstall --wait`
# returns, and a terminating namespace rejects the next release's resources with a
# `forbidden` error. Block until it is actually gone.
wait_for_namespace_deletion() {
  namespace=$(awk '$1 == "namespace:" { print $2 }' "$1")
  namespace=${namespace:-mirrord}
  waited=0
  while kubectl get "namespace/$namespace" > /dev/null 2>&1; do
    if [ "$waited" -ge 180 ]; then
      echo "namespace $namespace was still present 180s after uninstalling the release"
      kubectl get "namespace/$namespace" -o yaml
      exit 1
    fi
    waited=$((waited + 1))
    sleep 1
  done
}

# Helm ignores a value no template consumes, so a misspelled key installs cleanly and leaves the
# operator on its built-in default. Fail unless the operator container gets the variable `$2` with
# the value `$3` from the values file `$1`.
assert_rendered_env() {
  echo "running with helm template and asserting that $2 renders as $3"
  rendered=$(helm template -s templates/deployment.yaml -f "$1" mirrord-operator ./mirrord-operator)
  if ! echo "$rendered" | grep -A1 "$2" | grep -q "\"$3\""; then
    echo "chart did not render $2 with the value $3"
    exit 1
  fi
}

# `$1` is the values file. `$2` is `yes` when queue splitting stays on. `list` and `delete` are
# always required and are not limited to one name. `get` and `patch` on the chart-owned
# configuration appear only while a splitting broker is on.
assert_webhook_verbs() {
  echo "running with helm template and asserting webhook verbs (manage=$2)"
  if [ "$2" = "yes" ]; then
    rendered=$(helm template -s templates/cluster-role.yaml -f "$1" mirrord-operator ./mirrord-operator)
  else
    rendered=$(helm template -s templates/cluster-role.yaml -f "$1" --set operator.sqsSplitting=false mirrord-operator ./mirrord-operator)
  fi
  rules=$(echo "$rendered" | awk '
    /^- apiGroups:/ { if (block ~ /mutatingwebhookconfigurations/) print block; block="" }
    { block = block $0 "\n" }
    END { if (block ~ /mutatingwebhookconfigurations/) print block }
  ')
  unscoped=$(echo "$rules" | awk '
    /^- apiGroups:/ { if (block != "" && block !~ /resourceNames:/) print block; block="" }
    { block = block $0 "\n" }
    END { if (block != "" && block !~ /resourceNames:/) print block }
  ')
  if ! echo "$unscoped" | grep -q -- "- list$"; then
    echo "chart dropped unscoped list on mutatingwebhookconfigurations"
    exit 1
  fi
  if ! echo "$unscoped" | grep -q -- "- delete$"; then
    echo "chart dropped unscoped delete on mutatingwebhookconfigurations"
    exit 1
  fi
  for verb in create update deletecollection; do
    if echo "$rules" | grep -q -- "- ${verb}$"; then
      echo "chart granted ${verb} on mutatingwebhookconfigurations"
      exit 1
    fi
  done
  if [ "$2" = "yes" ]; then
    if ! echo "$rules" | grep -q "mirrord-operator-pod-mutator"; then
      echo "chart did not scope webhook management to mirrord-operator-pod-mutator"
      exit 1
    fi
    for verb in get patch; do
      if ! echo "$rules" | grep -q -- "- ${verb}$"; then
        echo "chart dropped ${verb} on the chart-owned webhook configuration"
        exit 1
      fi
    done
  elif echo "$rules" | grep -q "mirrord-operator-pod-mutator"; then
    echo "chart scoped webhook management with queue splitting off"
    exit 1
  fi
}

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/mirrord-operator/*.yaml; do
  case "${file##*/}" in
    *"$filter"*) ;;
    *) continue ;;
  esac
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
  elif [ "$file" = "test_values/mirrord-operator/operator_communication_timeout.yaml" ]; then
    assert_rendered_env "$file" OPERATOR_COMMUNICATION_TIMEOUT_MILLIS 90000
  elif [ "$file" = "test_values/mirrord-operator/operator_hide_headers_and_properties.yaml" ]; then
    assert_rendered_env "$file" OPERATOR_HIDE_HEADERS_AND_PROPERTIES true
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
    wait_for_namespace_deletion "$file"
  elif [ "$file" = "test_values/mirrord-operator/operator_mutating_webhooks.yaml" ]; then
    # Queue splitting edits the chart-owned webhook configuration, so get and patch on that
    # name appear only while a broker is on. list and delete stay unscoped either way: an
    # older image still calls them from do_initial_cleanup on startup, and a 403 there wedges
    # the process. Both renders install cleanly, so assert on the ClusterRole.
    echo "running with helm template and asserting webhook RBAC follows queue splitting"
    assert_webhook_verbs "$file" yes
    assert_webhook_verbs "$file" no
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
    wait_for_namespace_deletion "$file"
  fi
  echo "::endgroup::"
done


# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/mirrord-license-server/*.yaml; do
  case "${file##*/}" in
    *"$filter"*) ;;
    *) continue ;;
  esac
  echo "::group::Running test for $file" # Groups logs in the CI dashboard

  # helm will wait forever for the volumes to be ready unless `--dry-run` is used
  echo "running with --dry-run=\"server\""
  helm install -f "$file" mirrord-license-server ./mirrord-license-server --wait --dry-run="server"

  echo "::endgroup::"
done
