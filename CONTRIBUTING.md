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

## Release charts

Refer to the operator `contributing.md`.
