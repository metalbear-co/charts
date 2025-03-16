#!/bin/sh

set -e

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/$1_*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  helm install --atomic --debug -f $file "mirrord-$1" "./mirrord-$1" --wait
  helm uninstall "mirrord-$1" --wait
  echo "::endgroup::"
done
