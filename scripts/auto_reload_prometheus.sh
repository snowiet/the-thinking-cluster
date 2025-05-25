#!/bin/bash

# === Prometheus Auto Reload Script ===
# Watches Prometheus config & rule files and reloads on change

# Absolute paths to watch (adjust if you relocate them)
WATCHED_FILES="/mnt/d/documents/the-thinking-cluster/compose/monitoring/prometheus.yml /mnt/d/documents/the-thinking-cluster/compose/monitoring/alert_rules.yml"

# Prometheus reload endpoint
RELOAD_URL="http://localhost:9090/-/reload"

echo "👀 Watching Prometheus config and rule files for changes..."
echo "🔁 Will POST to $RELOAD_URL when something changes"

# Run forever — wait for file modifications
while true; do
  inotifywait -e modify $WATCHED_FILES >/dev/null 2>&1
  echo "🔧 Change detected. Reloading Prometheus..."
  curl -X POST $RELOAD_URL
  echo "✅ Reload complete."
done
