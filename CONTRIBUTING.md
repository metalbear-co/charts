# Contributing

Before submitting pull request features, please discuss them with us first by opening an issue or a discussion.
Feel free to join to our [Slack](https://metalbear.com/slack) for help and guidance.

# Contents

- [Release charts](#release-charts)

# Release charts

## Release PR

1. Create a new branch named after the new app version, e.g. `app-version-3.135.0`.
2. Bump the versions in `./mirrord-operator/Chart.yaml` and `./mirrord-license-server/Chart.yaml`.
  1. For `version`, bump a patch version if the new release only contains `internal` and `fixed` changes,
  e.g. `1.4.13` to `1.4.14`.
  Otherwise, bump a minor version, e.g. `1.42.0` to `1.43.0`.
  2. `appVersion` should be the released operator Docker image tag. Make sure operator and license
  server have the same `appVersion`.
3. Operator and license server each has its own `CHANGELOG.md` file. In the repository root directory,
run the following towncrier commands to generate changelogs. Use `version` from `Chart.yaml` for the `--version` argument.
  1. Operator: `towncrier build --version 1.43.0 --config mirrord-operator/towncrier.toml --dir mirrord-operator`
  2. License server: `towncrier build --version 1.4.14 --config mirrord-license-server/towncrier.toml --dir mirrord-license-server`
4. Review the two generated changelogs and fix any issues or typos.
5. Push the release branch and open a PR.

## Dispatch release

After the release PR is merged, manually dispatch the `Release` workflow.

**Note**: Ensure the branch or tag you use is attached to the release commit.

