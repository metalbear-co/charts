#!/bin/bash

helm install mirrord-operator \
    --set license.file.data."license\\.pem"="$(cat ../licenses/ci-license.pem)" \
    ./mirrord-operator --wait
