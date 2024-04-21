{{/* Common labels */}}
{{- define "mirrord-operator.labels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
helm.sh/chart: {{ printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ $.Release.Name }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
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
{{- end }}