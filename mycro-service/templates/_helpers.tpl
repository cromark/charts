{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
create feature namespace
*/}}
{{- define "ns" -}}
{{- if .Values.feature -}}
{{- printf "%s-%s" .Release.Namespace .Values.feature | replace "/" "-" | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
create labels - not working
*/}}
{{- define "labels" -}}
  app: {{ .Release.Name }}
{{- if .Values.feature }}
  feature: {{ .Values.feature | replace "/" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}  
  app.kubernetes.io/instance: {{ .Release.Name }}
  app.kubernetes.io/part-of: {{ .Release.Name }}
  app.kubernetes.io/name: {{ .Release.Name }}
  version: {{ .Values.version | default "v1" }}
{{- end }}

{{/*
create hostname with feature
*/}}
{{- define "hostname" -}}
  {{- if .Values.feature }}
  {{- printf "%s-%s.%s.%s" .Release.Name .Values.feature (.Values.envname | default "dev") (.Values.domain | default "hci.aetna.com") | replace "/" "-" | trunc 63 | trimSuffix "-" }}
  {{- else }}
  {{- printf "%s.%s.%s" .Release.Name ( .Values.envname | default "dev" )  (.Values.domain | default "hci.aetna.com") | replace "/" "-" | trunc 63 | trimSuffix "-" }}
  {{- end }}
{{- end }}