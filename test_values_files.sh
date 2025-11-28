#!/bin/sh

set -e

# Verify that --rollback-on-failure behaves same as --atomic returns non-zero exit code on failure
echo "::group::Testing --rollback-on-failure exit code behavior"
set +e
helm install --rollback-on-failure --set operator.image.tag=nonexistent-tag-12345 \
  mirrord-operator ./mirrord-operator --wait --timeout 30s >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "::error::--rollback-on-failure returned 0 on failure. CI will not fail properly!"
  exit 1
fi
set -e
echo "Confirmed: --rollback-on-failure returns non-zero exit code on failure"
echo "::endgroup::"

# For each file in the `test_values` directory
# run helm install && helm uninstall.
for file in test_values/*.yaml; do
  echo "::group::Running test for $file" # Groups logs in the CI dashboard
  helm install --rollback-on-failure --debug -f $file mirrord-operator ./mirrord-operator --wait
  helm uninstall mirrord-operator --wait
  echo "::endgroup::"
done
