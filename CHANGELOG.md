## [mirrord-operator-1.43.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.43.0) - 2026-01-06


### Added

- Added an option to configure mirrord Operator's deployment replicas (`operator.replicas` in values.yaml).
- Support for limiting outgoing connections from mirrord sessions using a kubernetes policy has been added to the operator.


## Changed

- Bumped `appVersion` to `3.135.1`.

## [mirrord-operator-license-server-1.4.14](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.14) - 2026-01-06


### Changed

- Bumped `appVersion` to `3.135.1`.

## [mirrord-operator-1.42.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.42.0) - 2025-12-24


### Added

- Added `envFrom` as a new type of connection source for DB branching.


## Changed

- Bumped `appVersion` to `3.134.0`.

## [mirrord-operator-license-server-1.4.13](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.13) - 2025-12-24


## Changed

- Bumped `appVersion` to `3.134.0`.

## [mirrord-operator-1.41.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.41.0) - 2025-12-22


### Added

- Added `ciInfo` to mirrordclusterssessions spec.


## Changed

- Bumped `appVersion` to `3.133.0`.

## [mirrord-operator-license-server-1.4.12](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.12) - 2025-12-22


## Changed

- Bumped `appVersion` to `3.133.0`.

## [mirrord-operator-1.40.3](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.40.3) - 2025-12-10


### Internal

- Added `MirrordClusterExternalResource` CRD.

## Changed

- Bumped `appVersion` to `3.132.1`.

## [mirrord-operator-license-server-1.4.11](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.11) - 2025-12-10

## Changed

- Bumped `appVersion` to `3.132.1`.


## [mirrord-operator-license-server-1.4.10](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.10) - 2025-12-04

## Changed

- Bumped `appVersion` to `3.131.0`.

## [mirrord-operator-1.40.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.40.2) - 2025-12-04

### Changed

- Bumped `appVersion` to `3.131.0`.

### Removed

- Removed `operator.mutatingWebhooks` setting from the mirrord-operator chart's `values.yaml`. Mutating webhooks are now always enabled.

### Internal

- Added CRD for HA copy target.
- Added CRD for PostgreSQL branching.

## [mirrord-operator-1.40.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.40.1) - 2025-11-20


### Added

- You can now override the chart's `imagePullPolicy` value with
  `server.imagePullPolicy` and `operator.imagePullPolicy` when installing the
  license server and operator, respectively.


### Changed

- Bumped `appVersion` to `3.130.0`.
- Improved docs for operator.noPodTargetsSessionTimeoutMillis value.


### Internal

- Fail when we fail to download the mirrord binary instead of downloading a
  "Not Found" response and trying to use it a mirrord binary.

## [mirrord-operator-1.40.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.40.0) - 2025-11-06

## Added

- You can now override the image tag (which defaults to the `appVersion`) by setting the `operator.imageTag` value.

## Changed

- Bumped `appVersion` to `3.129.1`.
- Added labels and annotations to the mysql branch config example.

## [mirrord-operator-license-server-1.4.8](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.8) - 2025-11-06

## Changed

- Bumped `appVersion` to `3.129.1`.

## [mirrord-operator-1.39.4](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.39.4) - 2025-10-29


## Changed

- Bumped `appVersion` to `3.129.0`.

### Internal

- Added `contents` and `packages` write permissions to the release workflow.
- Updated MySQL branch CRD with data copy configuration.

## [mirrord-operator-license-server-1.4.7](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.7) - 2025-10-29


## Changed

- Bumped `appVersion` to `3.129.0`.

### Internal

- Added `contents` and `packages` write permissions to the release workflow.

## [mirrord-operator-1.39.3](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.39.3) - 2025-10-28


## Fixed

- Fixed handling of `false` value for `queueSplittingWaitForReadyTarget`.

### Internal

- Added delete db branches permission to the operator user role.
- Added `MirrordClusterSession` CRD.

## [mirrord-operator-license-server-1.4.6](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.6) - 2025-10-22


### Changed

- Bumped appVersion to 3.128.0.


## [mirrord-operator-1.39.2](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.39.2) - 2025-10-22


## Fixed

- Fixed `queueSplittingwaitForReadyTarget` indent.

### Changed

- `values.yaml` now uses a default of 60s for lingering SQS queues timeout.
- Bumped appVersion to 3.128.0.


## [mirrord-operator-license-server-1.4.5](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.5) - 2025-10-09


### Changed

- Bump license-server to 3.127.1


## [mirrord-operator-1.39.1](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.39.1) - 2025-10-09


### Changed

- Bump operator to 3.127.1


## [mirrord-operator-license-server-1.4.4](https://github.com/metalbear-co/charts/tree/mirrord-operator-license-server-1.4.4) - 2025-10-06


### Changed

- Bump license-server to 3.127.0


## [mirrord-operator-1.39.0](https://github.com/metalbear-co/charts/tree/mirrord-operator-1.39.0) - 2025-10-06


### Changed

- Bump operator to 3.127.0
- `operator.mutatingWebhooks` setting is now enabled by default.

### Internal

- Added custom resource definitions for HA patching.
- Added the RBAC permission required for clients to create `MirrordClusterOperatorUserCredential`.

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
