{{/* Common labels */}}
{{- define "mirrord-license-server.labels" -}}
app.kubernetes.io/name: {{ $.Chart.Name }}
helm.sh/chart: {{ printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ $.Release.Name }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- end }}

{{- define "mirrord-license-server.samlProxyConfigMapName" -}}
mirrord-license-server-saml-proxy-config
{{- end }}

{{- define "mirrord-license-server.samlProxyAssetsSecretName" -}}
mirrord-license-server-saml-proxy-assets
{{- end }}

{{- define "mirrord-license-server.samlProxyServerConfig" -}}
# Disable "forward proxy" mode.
# We only want Apache to proxy to our own localhost backends, never to arbitrary destinations.
ProxyRequests Off
# Forward the original Host header to the backend instead of rewriting it to 127.0.0.1.
# This preserves the externally visible hostname in case the backend needs it.
ProxyPreserveHost On
# Add standard proxy headers such as X-Forwarded-For and X-Forwarded-Proto.
ProxyAddHeaders On

# Remove any identity headers that arrived from the outside world.
# This prevents a client from spoofing authentication by sending these headers directly.
RequestHeader unset X-Remote-User
RequestHeader unset X-Remote-Group
RequestHeader unset X-Remote-Extra-NameID
RequestHeader unset X-Remote-Extra-SessionIndex

# Do not proxy the internal Mellon endpoints.
# The "!" target means "leave this path to Apache itself", which is required because
# mod_auth_mellon serves its own login/logout/assertion-consumer endpoints here.
ProxyPass "/mellon" "!"
# When the dashboard is enabled, its report endpoints live on the dashboard port.
# These must be matched before the broader "/api/" rule below.
ProxyPass "/api/" "http://127.0.0.1:{{ add .Values.dashboard.port 1 }}/api/"
# Rewrite redirects from the dashboard report endpoints back to the public URL space.
ProxyPassReverse "/api/" "http://127.0.0.1:{{ add .Values.dashboard.port 1 }}/api/"
# Send all non-API browser traffic to the dashboard web UI.
ProxyPass "/" "http://127.0.0.1:{{ add .Values.dashboard.port 1 }}/"
# Rewrite redirects from the dashboard web UI back to the public URL space.
ProxyPassReverse "/" "http://127.0.0.1:{{ add .Values.dashboard.port 1 }}/"
# Apply SAML authentication to everything by default.
# More specific Location blocks below carve out exceptions for health checks and Mellon's own
# internal endpoints.
<Location />
  # Tell Apache to use mod_auth_mellon as the authentication provider here.
  AuthType Mellon
  # Run the full SAML login flow on this path.
  MellonEnable auth
  # Allow any successfully authenticated user through.
  Require valid-user
  # Identity Provider (IdP) metadata:
  # describes the corporate SAML provider we redirect the browser to and trust assertions from.
  MellonIdPMetadataFile "{{ .Values.saml.proxy.assets.mountPath }}/idp-metadata.xml"
  # Service Provider (SP) metadata:
  # describes this Apache proxy as a SAML participant.
  MellonSPMetadataFile "{{ .Values.saml.proxy.assets.mountPath }}/sp-metadata.xml"
  # Private key belonging to this Service Provider.
  # Mellon uses it together with the certificate below when participating in SAML exchanges.
  MellonSPPrivateKeyFile "{{ .Values.saml.proxy.assets.mountPath }}/sp.key"
  # Public certificate that matches the Service Provider private key above.
  MellonSPCertFile "{{ .Values.saml.proxy.assets.mountPath }}/sp.cert"
  # URL prefix where Mellon exposes its own SAML helper endpoints such as login callbacks.
  MellonEndpointPath /mellon
  # The IdP returns the SAML assertion via a cross-site POST to the ACS endpoint, so the
  # browser must send Mellon's session cookie on that cross-site request. Browsers only do
  # this for SameSite=None cookies, and only honor SameSite=None when the cookie is Secure.
  # The proxy must therefore be reached over HTTPS (TLS terminated here or upstream).
  MellonSecureCookie On
  MellonCookieSameSite None
  # Copy the authenticated username into a trusted header for downstream Rust services.
  # mod_auth_mellon exports the SAML NameID as the MELLON_NAME_ID env var after login; it does
  # not expose REMOTE_USER as a CGI env var, so the header must be sourced from MELLON_NAME_ID.
  RequestHeader set X-Remote-User "%{MELLON_NAME_ID}e" env=MELLON_NAME_ID
  # Forward the SAML NameID in a generic "extra" header for downstream consumers that want it.
  RequestHeader set X-Remote-Extra-NameID "%{MELLON_NAME_ID}e" env=MELLON_NAME_ID
  # Forward the SAML SessionIndex in a generic "extra" header for downstream consumers.
  RequestHeader set X-Remote-Extra-SessionIndex "%{MELLON_SESSION_INDEX}e" env=MELLON_SESSION_INDEX
</Location>

# Expose Mellon's own helper endpoints without trying to protect them with another SAML round.
# These endpoints are part of the SAML handshake itself.
<Location /mellon>
  # "info" tells Mellon to handle its own endpoints here without requiring a normal protected
  # application request.
  MellonEnable info
  # Allow the browser and the Identity Provider to reach these helper endpoints.
  Require all granted
</Location>
{{- end }}
