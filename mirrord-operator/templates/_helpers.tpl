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

{{/* Common annotations */}}
{{- define "mirrord-operator.annotations" -}}
{{- if .Values.operator.annotations }}
{{- toYaml .Values.operator.annotations }}
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
# The previews API extension the CLI reads multicluster status from (RBAC is
# version-agnostic, so this covers the alpha group-version it is served under).
- apiGroups:
  - operator.metalbear.co
  resources:
  - previews
  verbs:
  - get
  - list
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
{{- if or (default false .Values.operator.pgBranching) (default false .Values.operator.mysqlBranching) (default false .Values.operator.mariadbBranching) (default false .Values.operator.dynamodbBranching) (default false .Values.operator.mongodbBranching) (default false .Values.operator.mssqlBranching) (default false .Values.operator.redisBranching) (default false .Values.operator.spannerBranching) (default false .Values.operator.clickhouseBranching) (default false .Values.operator.cockroachdbBranching) (default false .Values.operator.genericBranching) }}
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
  # The CLI merges a session's migrations into `spec.migrations` on the branch it
  # is about to use (fresh or reused), so branch migrations need `patch`.
  - patch
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
{{- if .Values.operator.previewEnv }}
# Preview secret mounts are created over the operator's aggregated API at cluster
# scope, so the rule must live in a ClusterRole even for namespaced-Role users.
- apiGroups:
  - operator.metalbear.co
  resources:
  - previewsecretmounts
  verbs:
  - create
{{- end }}
{{- if or .Values.operator.sqsSplitting .Values.operator.kafkaSplitting .Values.operator.rmqSplitting .Values.operator.gcpPubsubSplitting .Values.operator.azureServiceBusSplitting .Values.operator.temporalSplitting .Values.operator.bullmqSplitting .Values.operator.redisPubsubSplitting }}
# `mirrord queues status` reads split sessions over the aggregated API; its
# --all-namespaces form lists at cluster scope, so the rule must live in a
# ClusterRole even for namespaced-Role users.
- apiGroups:
  - operator.metalbear.co
  resources:
  - queuesplits
  verbs:
  - get
  - list
{{- end }}
{{- end }}

{{/*
Renders a container `resources:` block from a `requests` map and a `limits` map.

Every quantity is optional: dropping one from the values (`operator.limits.cpu: null`), or dropping a
whole map (`operator.limits: null`), leaves it out of the rendered pod spec instead of rendering an
empty value. Clusters that manage container resources themselves - with a LimitRange, a VPA, or by
deliberately running without a CPU limit to avoid throttling - need that, since Kubernetes has no
quantity that means "no constraint". With nothing left to render this emits `resources: {}`.

Used both for containers in the operator Deployment and for the agent config in the ConfigMap
(where `resources: {}` replaces the agent's built-in default requests and limits with nothing).

Takes a dict of the two maps, and renders unindented so the caller controls placement:

  {{- include "mirrord-operator.resources" (dict "requests" .Values.operator.requests "limits" .Values.operator.limits) | nindent 8 }}
*/}}
{{- define "mirrord-operator.resources" -}}
{{- $resources := dict -}}
{{- range $section := list "requests" "limits" -}}
  {{- $quantities := dict -}}
  {{- range $name, $quantity := (get $ $section | default dict) -}}
    {{- /* Only null and the empty string mean "unset". `empty` would also swallow a numeric 0,
           which is a valid quantity and a deliberate one to request. */ -}}
    {{- if not (kindIs "invalid" $quantity) -}}
      {{- if ne (printf "%v" $quantity) "" -}}
        {{- $_ := set $quantities $name $quantity -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- if $quantities -}}
    {{- $_ := set $resources $section $quantities -}}
  {{- end -}}
{{- end -}}
{{- if $resources -}}
resources:
{{ toYaml $resources | indent 2 -}}
{{- else -}}
resources: {}
{{- end -}}
{{- end }}

{{/* Returns the effective agent priority class name */}}
{{- define "mirrord-operator.checked-bool-ternary" -}}
{{- if kindIs "string" . -}}
  {{ . | quote }}
{{- else -}}
  {{ default false . | ternary "true" "false" | quote }}
{{- end -}}
{{- end }}
