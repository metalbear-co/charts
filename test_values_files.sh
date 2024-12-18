#!/bin/sh

# for each file in the test_values directory
# run helm install --dry-run=server
for file in test_values/*.yaml; do
  echo "Running test for $file"
  helm install --dry-run=server --debug -f $file mirrord-operator ./mirrord-operator
done
