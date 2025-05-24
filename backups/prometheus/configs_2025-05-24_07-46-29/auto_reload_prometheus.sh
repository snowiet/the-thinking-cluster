#!/bin/bash

# Path to the files you want to watch
WATCHED_FILES="./prometheus.yml ./alert_rules.yml"

# Your Prometheus reload endpoint
RELOAD_URL="http://localhost:9090/-/reload"

echo "👀 Watching Prometheus config and rule files for changes..."
echo "🔁 Will POST to $RELOAD_URL when something changes"

# Use inotifywait (from inotify-tools) to monitor files
while true; do
  inotifywait -e modify $WATCHED_FILES >/dev/null 2>&1
  echo "🔧 Change detected. Reloading Prometheus..."
  curl -X POST $RELOAD_URL
  echo "✅ Reload complete."
done
