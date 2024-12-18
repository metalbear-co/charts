#!/bin/sh

# for each file in the test_values directory
# run helm install && helm uninstall
for file in test_values/*.yaml; do
  echo "Running test for $file"
  helm install --atomic --debug -f $file mirrord-operator ./mirrord-operator --wait
  helm uninstall mirrord-operator --wait
done
