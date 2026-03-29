#!/bin/sh

set -e

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  # helm will wait forever for the volumes to be ready unless `--dry-run` is used
  if [ "$file" = "test_values/extra_volumes.yaml" ]; then
    echo "running with --dry-run"
    helm install --atomic -f "$file" mirrord-operator ./mirrord-operator --wait --dry-run
  else
    helm install --atomic -f "$file" mirrord-operator ./mirrord-operator --wait
    helm uninstall mirrord-operator --wait
  fi
  echo "::endgroup::"
done
