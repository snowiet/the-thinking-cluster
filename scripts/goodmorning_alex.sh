#!/bin/bash

set -e  # Stop if anything fails

# === PREP ===
echo "🌞 Good morning, Hun! Starting your morning sync..."
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
base_dir=~/morning_sync
config_dir=$base_dir/configs_$timestamp
mkdir -p $config_dir

# === COPY CONFIGS ===
echo "📦 Backing up config files..."
cp ~/grafana-demo/prometheus.yml $config_dir/
cp ~/grafana-demo/docker-compose.yml $config_dir/
cp ~/grafana-demo/alert_rules.yml $config_dir/
cp ~/grafana-demo/auto_reload_prometheus.sh $config_dir/

# === DOCKER STATUS ===
echo "🐳 Saving docker ps..."
docker ps -a > $config_dir/docker_status.txt

# === PROMETHEUS TARGETS ===
echo "📡 Checking Prometheus targets..."
curl -s http://localhost:9090/api/v1/targets | jq '.' > $config_dir/prometheus_targets.json || echo "❌ Failed to query Prometheus API" > $config_dir/prometheus_targets.json

# === TAR CREATION ===
echo "🗜️ Creating tarball..."
tarball_name="morning_snapshot_$timestamp.tar.gz"
tar -czf $base_dir/$tarball_name -C $base_dir $(basename $config_dir)

# === COPY TO WINDOWS DESKTOP ===
win_desktop="/mnt/d/Documents/goodmorning_alex"
cp $base_dir/$tarball_name $win_desktop

# === DONE ===
echo "✅ Alex has been fed. Snapshot saved as:"
echo "$tarball_name → $win_desktop"



