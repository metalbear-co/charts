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
