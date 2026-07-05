{{/* Common labels */}}
{{- define "mirrord-operator.labels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
helm.sh/chart: {{ printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ $.Release.Name }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- if .Values.operator.labels }}
{{- toYaml .Values.operator.labels | nindent 0 }}
{{- end }}
{{- end }}

{{/* Returns the effective agent priority class name */}}
{{- define "mirrord-operator.agentExtraConfigPriorityClassName" -}}
{{- if and .Values.agent.extraConfig (kindIs "map" .Values.agent.extraConfig) (hasKey .Values.agent.extraConfig "priority_class_name") -}}
{{- index .Values.agent.extraConfig "priority_class_name" -}}
{{- end -}}
{{- end }}

{{/* Returns the effective agent priority class name */}}
{{- define "mirrord-operator.agentPriorityClassName" -}}
{{- $extraPriorityClassName := include "mirrord-operator.agentExtraConfigPriorityClassName" . | trim -}}
{{- if $extraPriorityClassName -}}
{{- $extraPriorityClassName -}}
{{- else if .Values.agent.priorityClass.create -}}
{{- default "mirrord-agent-pod" .Values.agent.priorityClass.name -}}
{{- else if .Values.agent.priorityClass.name -}}
{{- .Values.agent.priorityClass.name -}}
{{- end -}}
{{- end }}

{{/* Validate license source configuration before rendering the chart */}}
{{- define "mirrord-operator.validateLicense" -}}
{{- $pemGsmRef := coalesce .Values.license.pemGsmRef .Values.license.gsmRef -}}
{{- if and .Values.license.pemGsmRef .Values.license.gsmRef -}}
{{- fail "license.pemGsmRef conflicts with a legacy PEM GSM value; only one can be set." -}}
{{- end -}}
{{- if and .Values.license.key .Values.license.keyRef -}}
{{- fail "Only one of license.key, license.keyRef, or license.keyGsmRef can be set." -}}
{{- end -}}
{{- if and .Values.license.key .Values.license.keyGsmRef -}}
{{- fail "Only one of license.key, license.keyRef, or license.keyGsmRef can be set." -}}
{{- end -}}
{{- if and .Values.license.keyRef .Values.license.keyGsmRef -}}
{{- fail "Only one of license.key, license.keyRef, or license.keyGsmRef can be set." -}}
{{- end -}}
{{- if and .Values.license.file.data .Values.license.pemRef -}}
{{- fail "Only one of license.file.data or license.pemRef can be set." -}}
{{- end -}}
{{- if and $pemGsmRef .Values.license.file.data -}}
{{- fail "Only one of license.pemGsmRef, license.file.data, or license.pemRef can be set." -}}
{{- end -}}
{{- if and $pemGsmRef .Values.license.pemRef -}}
{{- fail "Only one of license.pemGsmRef, license.file.data, or license.pemRef can be set." -}}
{{- end -}}
{{- $cloudApiKey := (.Values.cloud | default dict).apiKey | default dict -}}
{{- $hasCloudApiKey := or $cloudApiKey.key $cloudApiKey.keyRef $cloudApiKey.gsmRef -}}
{{- if not (or .Values.license.key .Values.license.keyRef .Values.license.keyGsmRef .Values.license.file.data .Values.license.pemRef $pemGsmRef $hasCloudApiKey) -}}
{{- fail "Set a credential: a cloud API key (cloud.apiKey.key, cloud.apiKey.keyRef, or cloud.apiKey.gsmRef) — the default, used to obtain the license over the API — or a license source (license.key, license.keyRef, license.keyGsmRef, license.file.data, license.pemRef, or license.pemGsmRef)." -}}
{{- end -}}
{{- end }}

{{/*
Validate the cloud API key: at most one source may be set. It is the default cloud credential; if
unset, the operator falls back to license-key authentication, so no source is strictly required.
*/}}
{{- define "mirrord-operator.validateCloudApiKey" -}}
{{- $apiKey := (.Values.cloud | default dict).apiKey | default dict -}}
{{- $sources := compact (list $apiKey.key $apiKey.keyRef $apiKey.gsmRef) -}}
{{- if gt (len $sources) 1 -}}
{{- fail "Only one of cloud.apiKey.key, cloud.apiKey.keyRef, or cloud.apiKey.gsmRef can be set." -}}
{{- end -}}
{{- end }}

{{/* rules needed to use mirrord and can be namespaced*/}}
{{- define "mirrord-operator.rules" -}}
- apiGroups:
  - operator.metalbear.co
  resources:
  - copytargets
  - targets
  - targets/port-locks
  verbs:
  - get
  - list
- apiGroups:
  - operator.metalbear.co
  resources:
  - copytargets
  verbs:
  - create
- apiGroups:
  - operator.metalbear.co
  resources:
  - targets
  - copytargets
  verbs:
  - proxy
- apiGroups:
  - operator.metalbear.co
  resources:
  - sessions
  verbs:
  - deletecollection
  - delete
- apiGroups:
  - profiles.mirrord.metalbear.co
  resources:
  - mirrordprofiles
  verbs:
  - get
  - list
{{- if .Values.operator.previewEnv }}
- apiGroups:
  - preview.mirrord.metalbear.co
  resources:
  - previewsessions
  verbs:
  - create
  - delete
  - get
  - list
  - watch
{{- end }}
{{- if (default false .Values.operator.mysqlBranching) }}
- apiGroups:
  - dbs.mirrord.metalbear.co
  resources:
  - mysqlbranchdatabases
  verbs:
  - get
  - list
  - create
  - watch
  - delete
{{- end }}
{{- if (default false .Values.operator.pgBranching) }}
- apiGroups:
  - dbs.mirrord.metalbear.co
  resources:
  - pgbranchdatabases
  verbs:
  - get
  - list
  - create
  - watch
  - delete
{{- end }}
{{- if (default false .Values.operator.mongodbBranching) }}
- apiGroups:
  - dbs.mirrord.metalbear.co
  resources:
  - mongodbbranchdatabases
  verbs:
  - get
  - list
  - create
  - watch
  - delete
{{- end }}
{{- if or (default false .Values.operator.pgBranching) (default false .Values.operator.mysqlBranching) (default false .Values.operator.dynamodbBranching) (default false .Values.operator.mongodbBranching) (default false .Values.operator.mssqlBranching) (default false .Values.operator.redisBranching) }}
- apiGroups:
  - dbs.mirrord.metalbear.co
  resources:
  - branchdatabases
  verbs:
  - get
  - list
  - create
  - watch
  - delete
{{- end }}
{{- if .Values.operator.dbBranchingLiteralCredentials }}
- apiGroups:
  - operator.metalbear.co
  resources:
  - branchcredentials
  verbs:
  - create
{{- end }}
{{- end }}

{{/* rules needed to use mirrord and needs to be cluster scoped */}}
{{- define "mirrord-operator.clusterRules" -}}
- apiGroups:
  - operator.metalbear.co
  resources:
  - mirrordoperators
  verbs:
  - get
  - list
- apiGroups:
  - operator.metalbear.co
  resources:
  - mirrordoperators/certificate
  verbs:
  - create
# `mirrord subscribe` streams interception events for a session over an SSE watch.
- apiGroups:
  - operator.metalbear.co
  resources:
  - events
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - profiles.mirrord.metalbear.co
  resources:
  - mirrordclusterprofiles
  verbs:
  - get
  - list
- apiGroups:
  - operator.metalbear.co
  resources:
  - mirrordclusteroperatorusercredentials
  verbs:
  - create
{{- end }}

{{/* Returns the effective agent priority class name */}}
{{- define "mirrord-operator.checked-bool-ternary" -}}
{{- if kindIs "string" . -}}
  {{ . | quote }}
{{- else -}}
  {{ default false . | ternary "true" "false" | quote }}
{{- end -}}
{{- end }}
