## [mirrord-operator-license-server-1.1.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.1.0) - 2025-07-22

### Added

- Added an option to configure license server's log level.

## [mirrord-operator-1.32.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.32.0) - 2025-07-22

### Added

- Added an option to configure operator's log level.

## [mirrord-operator-license-server-1.0.24](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.24) - 2025-07-22

### Changed

- App version update to 3.118.1.


### Internal

- Add pushing the chart to OCI.

## [mirrord-operator-1.31.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.31.1) - 2025-07-22

### Changed

- App version update to 3.118.1.


### Internal

- Add pushing the chart to OCI.

## [mirrord-operator-license-server-1.0.23](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.23) - 2025-07-21

### Changed

- Adjusted mirrord-license-server strategy to fix an upgrade issue originating
 from a ReadWriteOnce PVC

## [mirrord-operator-1.31.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.31.0) - 2025-07-17

### Changed

- App version update to 3.118.0.

## [mirrord-operator-license-server-1.0.22](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.22) - 2025-07-17

### Changed

- App version update to 3.118.0.

## [mirrord-operator-1.30.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.30.0) - 2025-07-09

### Added
- Added the `sns` field to `MirrordWorkloadQueueRegistry` CRD - for splitting SQS queues based on SNS message attributes.


### Changed

- App version update to 3.117.0.
- Fix `keyRef` docs to talk about the secret.
- Added a custom strategy for restarting target workloads.
- Default license server port changed to be 8080, service port to be either service.port or 80


### Internal

- Adjusted operator's ClusterRole permissions for switching workload patch mode, added `OPERATOR_MUTATING_WEBHOOKS` env variable to the operator deployment.

## [mirrord-operator-license-server-1.0.20](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.20) - 2025-07-09


### Changed

- App version update to 3.117.0.

## [mirrord-operator-1.29.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.29.2) - 2025-07-01


### Changed

- App version update to 3.116.2.

## [mirrord-operator-license-server-1.0.19](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.19) - 2025-07-01


### Changed

- App version update to 3.116.2.

## [mirrord-operator-1.29.0](https://github.com/metalbear-co/charts/tree/1.29.0) - 2025-06-17


### Changed

- Allows the user to set `labels` to the `operator`.
- Add configuration value for the Jira webhook URL for mirrord Jira app integration.
- Added namespaced mirrord profile `MirrordProfile`. Granted get and list permission
to the mirrord-operator-user role.


## [mirrord-operator-license-server-1.0.17](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.17) - 2025-06-17


### Changed

- Version update to 1.0.17


## [mirrord-operator-1.28.0](https://github.com/metalbear-co/charts/tree/1.28.0) - 2025-06-11


### Changed

- Add cluster rules for allowing get and list mirrord cluster profiles.


## [mirrord-operator-license-server-1.0.16](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.16) - 2025-06-11


### Changed

- Version update to 1.0.16


## [mirrord-operator-1.27.4](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.27.4) - 2025-06-10


### Removed

- Removed the depcrecated `MirrordProfile` CRD. The name `MirrordProfile` will
  be re-introduced for namespaced profile CRD.


## [mirrord-operator-license-server-1.0.15](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.15) - 2025-06-10


### Changed

- Version update to 1.0.15


## [mirrord-operator-1.27.3](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.27.3) - 2025-06-10


### Changed

- App version update to 3.115.0.


## [mirrord-operator-license-server-1.0.14](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.0.14) - 2025-06-10


### Changed

- App version update to 3.115.0.


## [mirrord-operator-1.27.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.27.2) - 2025-06-09


### Changed

- App version update to 3.114.2.


### Internal

- Added a CI job that verifies appVersions in both charts are equal.

## [mirrord-operator-1.27.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.27.1) - 2025-06-04


### Changed

- App version update to `3.114.1`
- Improve readme.md with better docs for the charts.
  [#170](https://github.com/metalbear-co/charts/issues/170)
