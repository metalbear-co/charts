## [mirrord-operator-license-server-1.4.3](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.3) - 2025-09-17


### Changed

- Bump license-server to 3.126.0


## [mirrord-operator-1.38.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.38.1) - 2025-09-17


### Changed

- Bump operator to 3.126.0


## [mirrord-operator-license-server-1.4.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.2) - 2025-09-11


### Changed

- Bump mirrord to 3.125.0

## [mirrord-operator-1.38.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.38.0) - 2025-09-11


### Added

- Add queueSplittingWaitForReadyTarget flag

### Changed

- Bump mirrord to 3.125.0

## [mirrord-operator-license-server-1.4.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.1) - 2025-09-10

### Fixed

- Fixed a bug in the templates that prevented using the license stored in a pre-existing Kubernetes secret.

## [mirrord-operator-1.37.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.37.1) - 2025-09-10

### Changed

- `operator.isolatePodsRestart` is now enabled by default.

## [mirrord-operator-license-server-1.4.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.0) - 2025-09-02

### Changed

- Updated app version to 3.124.0.

## [mirrord-operator-1.37.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.37.0) - 2025-09-02

### Changed

- Updated app version to 3.124.0.
- Added CRD, feature flag and config map for MySQL branching.
- `workloadRestartTimeout` field for `MirrordWorkloadQueueRegistry`, that controls the timeout for the target workload to restart on the first SQS session start of a target.

### Internal

- Link to license server section in `README.md` license key config.

## [mirrord-operator-license-server-1.3.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.3.2) - 2025-09-01

### Changed

- Updated app version to 3.123.1.

## [mirrord-operator-1.36.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.36.1) - 2025-09-01

### Changed

- Updated app version to 3.123.1.

## [mirrord-operator-license-server-1.3.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.3.1) - 2025-08-27

### Changed

- Updated app version to 3.123.0.

## [mirrord-operator-1.36.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.36.0) - 2025-08-27

### Added

- Added a configuration option for SQS split linger timeout.

### Changed

- Updated app version to 3.123.0.

## [mirrord-operator-license-server-1.3.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.3.0) - 2025-08-22

### Changed

- Updated app version to 3.122.0.

## [mirrord-operator-1.35.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.35.0) - 2025-08-22

### Changed

- Updated app version to 3.122.0.

## [mirrord-operator-license-server-1.2.4](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.2.4) - 2025-08-13

### Changed

- Updated app version to 3.121.0.

## [mirrord-operator-1.34.4](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.34.4) - 2025-08-13

### Changed

- Updated app version to 3.121.0.

## [mirrord-operator-license-server-1.2.3](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.2.3) - 2025-08-08

### Changed

- Updated app version to 3.120.0.

## [mirrord-operator-1.34.3](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.34.3) - 2025-08-08

### Changed

- Updated app version to 3.120.0.

## [mirrord-operator-license-server-1.2.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.2.2) - 2025-08-07

### Changed

- Updated app version to 3.119.2.

## [mirrord-operator-1.34.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.34.2) - 2025-08-07

### Changed

- Updated app version to 3.119.2.
- The operator's cluster role now always allows for fetching itself.
- Added definition of policy for blocking scaledown when copying the target.

## [mirrord-operator-license-server-1.2.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.2.1) - 2025-07-30

### Changed

- Updated app version to 3.119.1.

## [mirrord-operator-1.34.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.34.1) - 2025-07-30

### Changed

- Updated app version to 3.119.1.

## [mirrord-operator-license-server-1.2.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.2.0) - 2025-07-29

### Added

- Added an option to fetch the license from Google Secret Manager.

## [mirrord-operator-1.34.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.34.0) - 2025-07-29

### Added

- Added an option to fetch the license from Google Secret Manager.
- Added an option to specify additional authentication config in the `MirrordKafkaClientConfig`.

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
