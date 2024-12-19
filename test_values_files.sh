#!/bin/sh

set -e

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  helm install --atomic --debug -f $file mirrord-operator ./mirrord-operator --wait
  helm uninstall mirrord-operator --wait
  echo "::endgroup::"
done
