# KNX-NG-Monitor – Home Assistant App

App für Home Assistant, die [ingel81/knx-ng-monitor](https://github.com/ingel81/knx-ng-monitor)
kapselt – ein modernes Web-Tool zum Live-Monitoring des KNX-Bus (Telegramme,
Charts, Statistiken, ETS-Projekt-Import, KNX Secure). Läuft auf Raspberry Pi 4
(64-Bit Home Assistant OS / Supervised, Architektur `aarch64`) sowie auf `amd64`.

Die App baut lediglich einen dünnen Wrapper um das offizielle, bereits
multi-arch verfügbare Docker-Image des Projekts – die eigentliche Anwendung
wird nicht neu kompiliert.

## Voraussetzungen

- Home Assistant OS oder Supervised (Container-basiert)
- Raspberry Pi 4 mit **64-Bit** Betriebssystem (32-Bit wird vom Upstream-Projekt
  nicht unterstützt)
- Netzwerkzugriff vom Pi zu deinem KNX-IP-Interface/-Router

## Installation

1. In Home Assistant: **Einstellungen → Apps → App installieren → ⋮ →
   Repositories** → die URL des Repos eintragen.
3. **KNX-NG-Monitor** erscheint in der Liste → installieren.

## Konfiguration

Nach der Installation der App unter **Konfiguration**:

```yaml
log_level: Information
```

Mögliche Werte: `Verbose`, `Debug`, `Information`, `Warning`, `Error`, `Fatal`
(siehe [Logging & Diagnostics](https://github.com/ingel81/knx-ng-monitor#logging--diagnostics)
im Upstream-Projekt).

Alle übrigen Einstellungen (KNX-IP-Interface, Tunneling/Routing, ETS-Import,
Benutzerverwaltung) werden – wie im Original-Projekt – direkt in der Web-UI
der Anwendung vorgenommen, nicht über die Konfiguration der App.

## Start & erste Einrichtung

1. App starten (Tab **Info** → Start).
2. Web-UI öffnen: `http://<home-assistant-ip>:8080`
   (Port ist im Tab **Netzwerk** der App änderbar).
3. alles weitere unter [First Time Setup](https://github.com/ingel81/knx-ng-monitor) First Time Setup

## Datenpersistenz

Alle Daten (SQLite-Datenbank, JWT-Signing-Key, Logs, optionales NDJSON-Archiv)
landen im Supervisor-verwalteten, update-sicheren Datenordner der App
(`/data`, im Container per Symlink auf den von der Anwendung erwarteten Pfad
`/app/data` verlinkt). Ein Update der App oder ein Neustart des Containers
löscht diese Daten nicht.

## KNX-Routing (Multicast) statt Tunneling

Die Anwendung unterstützt sowohl KNXnet/IP **Tunneling** (Unicast) als auch
**Routing** (Multicast, Gruppenadresse `224.0.23.12`). Docker-Bridge-Networking
(Standard für diese App) leitet Multicast nicht immer zuverlässig weiter.
Falls Routing benötigt wird und es zu keiner Verbindung kommt: In
`config.yaml` `host_network: true` setzen und die App neu installieren (dann
läuft der Container im Host-Netzwerk und der Port 8080 muss auf dem Pi selbst
frei sein).

## Hinweis zu Ingress

Diese App ist bewusst **ohne** Home-Assistant-Ingress konfiguriert
(`ingress: false`), da die Angular-Oberfläche der Anwendung nicht dafür
ausgelegt ist, hinter einem dynamischen Pfad-Präfix zu laufen. Der Zugriff
erfolgt direkt über Port 8080 (LAN).

## Lizenz / Trademark

Diese App enthält keinen eigenen Anwendungscode, sondern nutzt lediglich
das öffentlich verfügbare Docker-Image von `ingel81/knx-ng-monitor` (MIT-Lizenz
für den Projektcode; das enthaltene KNX-Falcon-SDK ist proprietär, siehe
[THIRD-PARTY-NOTICES.md](https://github.com/ingel81/knx-ng-monitor/blob/master/THIRD-PARTY-NOTICES.md)
im Upstream-Repo). "KNX" ist eine eingetragene Marke der KNX Association;
diese App steht in keiner Verbindung zur KNX Association.
