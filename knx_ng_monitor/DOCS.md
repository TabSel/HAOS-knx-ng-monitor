# KNX-NG-Monitor

Web-basiertes KNX-Bus-Monitoring: Live-Telegramme, DPT-Dekodierung, Charts,
Statistiken, Gebäude-Topologie, ETS-Projekt-Import (ETS 4/5/6) inkl. KNX
Secure, sowie Lese-/Schreibzugriff auf Gruppenadressen direkt aus der UI.

Mehr Details, Screenshots und die volle Feature-Liste:
https://github.com/ingel81/knx-ng-monitor

## Konfiguration

| Option      | Beschreibung                                                                 |
| ----------- | ----------------------------------------------------------------------------- |
| `log_level` | Log-Verbosität: `Verbose`, `Debug`, `Information` (Standard), `Warning`, `Error`, `Fatal` |

## Nach dem Start

1. Web-UI öffnen: `http://<home-assistant-ip>:8080`
2. Einrichtungsassistenten durchlaufen (legt den Admin-Benutzer an)
3. Optional ETS-Projekt importieren
4. Unter **Settings** das KNX-IP-Interface eintragen (IP, Port, Tunneling
   oder Routing)
5. **Monitor** öffnen und den Bus live beobachten

## Daten & Persistenz

Datenbank, Logs und (optionales) Langzeit-Archiv liegen im
Supervisor-verwalteten Datenordner der App und überleben Updates/Neustarts.

## KNX Routing (Multicast)

Falls statt Tunneling die Routing-Verbindungsart genutzt werden soll und
keine Verbindung zustande kommt, hilft meist `host_network: true` in der
`config.yaml` (danach die App neu installieren), da Docker-Bridge-Networking
Multicast nicht immer zuverlässig durchreicht.
