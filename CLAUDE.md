# CLAUDE.md

Context for Claude Code when working with the mirrord Helm charts repository.

## Quick Reference

```bash
# Render templates (validate syntax)
helm template mirrord-operator ./mirrord-operator --set license.key=test
helm template mirrord-license-server ./mirrord-license-server --set license.key=test

# Test all value file combinations
bash test_values_files.sh

# Generate changelog (after adding fragments)
towncrier build --version <VERSION> --config mirrord-operator/towncrier.toml --dir mirrord-operator
towncrier build --version <VERSION> --config mirrord-license-server/towncrier.toml --dir mirrord-license-server
```

## Overview

This repository contains Helm charts for deploying mirrord components to Kubernetes. It is separate from the operator codebase; changes here only affect Kubernetes deployment configuration, not the binaries themselves.

**Helm repo:** `helm repo add metalbear https://metalbear-co.github.io/charts`

**Published to:** GitHub Pages Helm repo + GHCR OCI registry

## Charts

### mirrord-operator

Deploys the mirrord operator for managing concurrent mirrord sessions in multi-user environments.

- **Chart version:** Check `mirrord-operator/Chart.yaml`
- **Templates:** 21 files (deployment, RBAC, CRDs, TLS, multi-cluster support)
- **Default namespace:** `mirrord`
- **Image:** `ghcr.io/metalbear-co/operator` (same image as license server, different entrypoint)

Key features configurable via values:
- SQS/Kafka queue splitting
- MySQL/PostgreSQL/MongoDB database branching
- Multi-cluster support (Envoy-based)
- ArgoCD/Flux integration
- OpenShift SCC support
- Prometheus metrics

### mirrord-license-server

On-premise license seat tracking and metrics aggregation (Enterprise only).

- **Chart version:** Check `mirrord-license-server/Chart.yaml`
- **Templates:** 8 files (deployment, service, PVC, TLS, license)
- **Default namespace:** `mirrord`
- **Image:** `ghcr.io/metalbear-co/operator` with entrypoint arg `license-server`
- **Storage:** 1Gi PVC for SQLite database
- **Deployment strategy:** Recreate (PVC is ReadWriteOnce)
- **Dashboard:** Serves frontend from `/dashboard/` when `DASHBOARD_DIR` is set

## Critical Constraint

Both charts **must have identical `appVersion`** in their Chart.yaml files. CI enforces this with the `check-app-versions-equal` job. They share the same Docker image.

## Directory Structure

```
charts/
├── mirrord-operator/
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── templates/           # 21 template files
│   ├── changelog.d/         # Towncrier fragments
│   └── CHANGELOG.md
├── mirrord-license-server/
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── templates/           # 8 template files
│   ├── changelog.d/         # Towncrier fragments
│   └── CHANGELOG.md
├── test_values/             # 22 test value files for CI
└── test_values_files.sh     # Tests all value combinations
```

## Testing

**Local validation:**
```bash
helm template <chart-name> ./<chart-dir> --set license.key=test
```

**CI runs:**
1. `helm template` sanity check (both charts)
2. App version equality check
3. Minikube install test with all 22 test value files
4. Full install-and-use test (operator + mirrord session, 1 and 3 replicas)
5. Integrated test (operator + license server together)

**Test values** (`test_values/`): Cover SQS, Kafka, affinity, node selectors, role labels, multi-cluster (bearer, EKS, mTLS), extra env vars, image tag overrides.

## Changelog

Uses **towncrier** for both charts independently. Fragments in `<chart>/changelog.d/` with naming: `<issue-number>.<type>` (types: added, changed, fixed, security, removed, deprecated, internal).

## Release Process

1. Create branch `app-version-X.Y.Z`
2. Bump `version` and `appVersion` in both Chart.yaml files (appVersion must match)
3. Run towncrier for both charts
4. Submit PR, merge after CI passes
5. Manually dispatch `publish.yaml` workflow
6. Charts published to GitHub Pages repo + GHCR OCI registry

## CI/CD

- **ci.yaml:** Changed file detection, towncrier check, helm template sanity, app version check, minikube install tests, full E2E with mirrord sessions
- **publish.yaml:** Manual dispatch, packages charts, publishes to GHCR and GitHub Pages

## Common Values Patterns

**License configuration** (both charts):
```yaml
license:
  key: ""              # Direct key
  file:
    secret: ""         # K8s secret name containing license file
  gsmRef: ""           # Google Secrets Manager reference
```

**Image override:**
```yaml
operator:
  image:
    repository: ghcr.io/metalbear-co/operator
    tag: ""            # Defaults to appVersion
```
