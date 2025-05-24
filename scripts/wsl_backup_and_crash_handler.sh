#!/bin/bash

# WSL Backup and Crash Handler Script
# This script handles WSL crash logging and creates backups of project components
# It also cleans up backups older than 3 days

STAMP_FILE="$HOME/.wsl_last_exit_clean"
CRASH_LOG_DIR="/mnt/d/documents/the-thinking-cluster/logs/dmesg"
mkdir -p "$CRASH_LOG_DIR"

# Clean up old backups (older than 3 days)
BACKUP_ROOT="$PROJECT_ROOT/backups"
find "$BACKUP_ROOT" -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \;

if [ ! -f "$STAMP_FILE" ]; then
  LOG_FILE="$CRASH_LOG_DIR/dmesg_$(date +%F_%H-%M-%S).log"
  dmesg > "$LOG_FILE"
  echo "🧠 Crash log dumped to $LOG_FILE"
else
  echo "✅ Clean exit. No crash log."
fi

# Always clear the stamp after boot is handled (whether clean or crash)
rm -f "$STAMP_FILE"

# Set backup directory with absolute path
PROJECT_ROOT="/mnt/d/documents/the-thinking-cluster"
BACKUP_DIR="$PROJECT_ROOT/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup Docker volumes
for volume in grafana_data prometheus_data node_exporter_data alertmanager_data; do
  if [ -d "$PROJECT_ROOT/$volume" ]; then
    tar -czf "$BACKUP_DIR/${volume}.tar.gz" -C "$PROJECT_ROOT" "$volume"
  fi
done

# Backup configuration files
if [ -d "$PROJECT_ROOT/compose" ]; then
  tar -czf "$BACKUP_DIR/compose_configs.tar.gz" -C "$PROJECT_ROOT" compose/
fi

if [ -d "$PROJECT_ROOT/scripts" ]; then
  tar -czf "$BACKUP_DIR/scripts.tar.gz" -C "$PROJECT_ROOT" scripts/
fi

# Backup environment files (if they exist)
if [ -f "$PROJECT_ROOT/.env" ]; then
  cp "$PROJECT_ROOT/.env" "$BACKUP_DIR/"
fi

# Backup logs (optional, depending on your retention policy)
if [ -d "$PROJECT_ROOT/logs" ]; then
  tar -czf "$BACKUP_DIR/logs.tar.gz" -C "$PROJECT_ROOT" logs/
fi

# Create a manifest file
echo "Backup created on $(date)" > "$BACKUP_DIR/manifest.txt"
echo "Contents:" >> "$BACKUP_DIR/manifest.txt"
ls -R "$BACKUP_DIR" >> "$BACKUP_DIR/manifest.txt"
