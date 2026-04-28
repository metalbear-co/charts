# WARNING: This repository is read-only

Following the merge of the charts code into the operator repository, this repository will act as a read-only mirror. If you would like to suggest changes, please open an issue or a discussion.
Feel free to join to our [Slack](https://metalbear.com/slack) for help and guidance.

## Contents

- [Prose linting with Vale](##prose-linting-with-vale)
- [Release charts](##release-charts)

## Prose linting with Vale

Markdown and YAML files are linted with [Vale](https://vale.sh) on every PR. Install Vale (`brew install vale`) and run it locally with:

```bash
vale .
```

### Adding exceptions

**Allow a word or term** — add a regex line to [.vale/styles/config/vocabularies/Metalbear/accept.txt](.vale/styles/config/vocabularies/Metalbear/accept.txt):

```
fluxcd
mirrord('s)?
```

**Enforce correct capitalization/spelling** — add a swap pair to [.vale/styles/Metalbear/Terms.yml](.vale/styles/Metalbear/Terms.yml):

```yaml
swap:
  wrongSpelling: CorrectSpelling
```

**Suppress** — wrap the text with Vale directives (use sparingly):

```markdown
<!-- vale off -->
The button is clicked by the user.
<!-- vale on -->
```

## Regenerating CRD definitions

The Helm chart's `templates/crd.yaml` is **auto-generated** from the Rust CRD types, do NOT edit it manually. The `generate_helm_crd_yaml` test produces the full file (schemas, document separators, Helm conditionals) so the chart stays in sync with the Rust types without hand-writing OpenAPI schemas.

Whenever you modify a CRD type (in `operator-crd` or `mirrord-operator`), regenerate the chart by running:

```bash
cargo test -p operator-crd generate_helm_crd_yaml -- --ignored --nocapture
```

The only thing the generator does **not** handle automatically is Helm conditional guards. When you add a new CRD type you need to:

1. Add an entry to the `entries` list in `generate_helm_crd_yaml` (`operator-crd/src/crd.rs`).
2. Choose the right `HelmCondition` -- `Always` if the CRD should always be installed, `If(".Values.operator.someFeature")` if it is behind a feature flag, or `IfOr` for multiple flags.

After regenerating, review the git diff to make sure only your intended changes are present.

## Release charts

Refer to the operator `contributing.md` at `contributing.md`.
