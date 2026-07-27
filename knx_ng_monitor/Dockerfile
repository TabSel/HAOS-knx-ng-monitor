# Home Assistant App-Wrapper für ingel81/knx-ng-monitor
# https://github.com/ingel81/knx-ng-monitor
#
# Upstream-Version zum Aktualisieren HIER anpassen. Auf der Tags-Seite
# https://hub.docker.com/r/ingel81/knx-ng-monitor/tags nachsehen, welches
# Tag-Format aktuell verwendet wird (z.B. "0.8.0" oder "v0.8.0"), und den
# exakten String hier eintragen. Docker Hub prüft bei einer konkreten
# Versionsnummer garantiert neu, "latest" kann dagegen aus dem lokalen
# Build-Cache bedient werden und bringt dann kein echtes Update.
ARG UPSTREAM_VERSION=latest

#
# Wichtig: Das Upstream-Image deklariert "VOLUME /app/data". Würde man
# einfach FROM darauf aufbauen, würde Docker beim Containerstart automatisch
# ein anonymes Volume über /app/data mounten - das würde einen dort
# angelegten Symlink auf den persistenten Supervisor-Ordner /data wieder
# überschreiben bzw. zu Fehlern führen, da ein Volume nicht sauber über
# einen Symlink gemountet werden kann.
#
# Deshalb: Multi-Stage-Build. Aus dem Upstream-Image wird nur der komplette
# Publish-Output kopiert (COPY --from ... kopiert NUR Dateien, keine
# Image-Metadaten wie VOLUME/ENTRYPOINT). Die eigentliche Laufzeit-Umgebung
# bauen wir hier selbst nach (gleiche Basis: debian:12-slim, gleiche
# Laufzeit-Abhängigkeiten, gleicher nicht-root User uid/gid 1000).
FROM ingel81/knx-ng-monitor:${UPSTREAM_VERSION} AS upstream

FROM debian:12-slim

# Laufzeit-Abhängigkeiten:
# - libicu72, ca-certificates: von der .NET-Binary benötigt (wie im Original)
# - wget: für den HEALTHCHECK
# - jq: liest die App-Optionen aus /data/options.json
# - gosu: sauberer Wechsel von root (für den chown-Fix) zum App-User
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libicu72 \
      ca-certificates \
      wget \
      jq \
      gosu && \
    rm -rf /var/lib/apt/lists/*

# Gleicher nicht-root User wie im Upstream-Image (uid/gid 1000)
RUN groupadd --system --gid 1000 app && \
    useradd --system --uid 1000 --gid app --home /app --shell /usr/sbin/nologin app

WORKDIR /app

# Den kompletten Publish-Output aus dem Upstream-Image übernehmen - nicht nur
# die Binary, sondern auch /app/wwwroot (das gebaute Angular-Frontend) und
# alle sonstigen Publish-Artefakte. Nur die Binary zu kopieren führt zu
# "WebRootPath was not found: /app/wwwroot" und einer leeren Seite im Browser.
COPY --from=upstream --chown=app:app /app /app
RUN chmod +x /app/KnxMonitor.Api

# Das beim Kopieren mitgekommene (leere) /app/data wieder entfernen und durch
# einen Symlink auf den Supervisor-verwalteten, persistenten Ordner /data
# ersetzen. Kein VOLUME-Statement hier - so bleibt der Symlink beim
# Containerstart erhalten, statt von einem anonymen Volume überschrieben
# zu werden.
RUN rm -rf /app/data && ln -s /data /app/data

ENV ASPNETCORE_URLS=http://+:8080 \
    ASPNETCORE_ENVIRONMENT=Production \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp/.net

EXPOSE 8080

COPY run.sh /run.sh
RUN chmod +x /run.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget --quiet --spider http://localhost:8080/healthz || exit 1

# Start als root (für den chown-Fix in run.sh), run.sh wechselt danach
# per gosu zum App-User, bevor die eigentliche Anwendung startet.
USER root
ENTRYPOINT ["/run.sh"]
