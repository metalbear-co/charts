#!/bin/sh

# Renders the mirrord-operator chart with default values into a single multi-document YAML
# manifest, published as a release asset next to the packaged chart. This is used for the
# `mirrord operator install` command. Hooks are deliberately left out since the installation
# itself is not carried out by the helm CLI.
#
# Usage: render_default_manifest.sh <output-file>

set -e

API_KEY_PLACEHOLDER=__MIRRORD_OPERATOR_API_KEY__

output=${1:?usage: $0 <output-file>}
chart_dir=$(dirname "$0")/mirrord-operator

helm template mirrord-operator "$chart_dir" \
  --no-hooks \
  --set cloud.apiKey.key="$API_KEY_PLACEHOLDER" \
  > "$output"


# Sanity checks

if grep -q 'helm.sh/hook' "$output"; then
  echo "rendered manifest contains helm hooks, which would run immediately when applied outside of helm" >&2
  exit 1
fi

placeholder_count=$(grep -c "$API_KEY_PLACEHOLDER" "$output" || true)
if [ "$placeholder_count" -ne 1 ]; then
  echo "expected the API key placeholder exactly once in the rendered manifest, found $placeholder_count" >&2
  exit 1
fi
