#!/bin/sh

set -e

# Verify that --rollback-on-failure flag exists (replaces --atomic in Helm 4)
echo "::group::Verifying --rollback-on-failure flag exists"
if ! helm install --help 2>&1 | grep -q "rollback-on-failure"; then
  echo "::error::--rollback-on-failure flag not found. Wrong Helm version?"
  exit 1
fi
echo "Confirmed: --rollback-on-failure flag is available"
echo "::endgroup::"

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  helm install --rollback-on-failure --debug -f $file mirrord-operator ./mirrord-operator --wait
  helm uninstall mirrord-operator --wait
  echo "::endgroup::"
done
