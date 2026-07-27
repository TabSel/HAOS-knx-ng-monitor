#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

if [ -f "$OPTIONS_FILE" ]; then
    LOG_LEVEL="$(jq -r '.log_level // "Information"' "$OPTIONS_FILE")"
else
    LOG_LEVEL="Information"
fi

export KNX_LOG_LEVEL="$LOG_LEVEL"

echo "[knx-ng-monitor] Log-Level: ${KNX_LOG_LEVEL}"

# /data gehört initial root (Supervisor-Mount) - für den nicht-root
# App-User beschreibbar machen, bevor wir dorthin wechseln.
mkdir -p /data
chown -R app:app /data

exec gosu app /app/KnxMonitor.Api
