# Changelog

## 0.8.0.2

- Upstream-Version ist jetzt zentral als `ARG UPSTREAM_VERSION` oben im
  Dockerfile pflegbar, statt fest auf `:latest` zu verweisen. Zum
  Aktualisieren nur diese eine Zeile anpassen (Tag von
  https://hub.docker.com/r/ingel81/knx-ng-monitor/tags übernehmen).

## 0.8.0.1

- Fix: Dockerfile kopierte nur die Binary, nicht `/app/wwwroot` (das gebaute
  Angular-Frontend) - führte zu "WebRootPath was not found" im Log und einer
  leeren Seite im Browser. Jetzt wird der komplette Publish-Output aus dem
  Upstream-Image übernommen.

## 0.8.0

- Erste Version der App, basierend auf `ingel81/knx-ng-monitor` v0.8.0
- Multi-Stage-Wrapper um das Upstream-Docker-Image (kein VOLUME-Konflikt
  mit dem Supervisor-Datenordner)
- Persistenz über den Datenordner der App (`/data` → `/app/data`)
- Konfigurierbares Log-Level (`KNX_LOG_LEVEL`)
- Unterstützung für `aarch64` (Raspberry Pi 4, 64-Bit) und `amd64`
