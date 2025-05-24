#!/bin/bash

# WSL Backup and Crash Handler Script
# This script handles WSL crash logging and creates backups of project components
# It also cleans up backups older than 3 days

# Dynamically detect the root of this project based on the script's location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/..")"

STAMP_FILE="$HOME/.wsl_last_exit_clean"
CRASH_LOG_DIR="$PROJECT_ROOT/logs/dmesg"
mkdir -p "$CRASH_LOG_DIR"

# Clean up old backups (older than 3 days)
BACKUP_ROOT="$PROJECT_ROOT/backups"
if [ -d "$BACKUP_ROOT" ]; then
  find "$BACKUP_ROOT" -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \;
else
  echo "⚠️ No backups folder found at $BACKUP_ROOT — skipping cleanup"
fi

# Check for crash
if [ ! -f "$STAMP_FILE" ]; then
  LOG_FILE="$CRASH_LOG_DIR/dmesg_$(date +%F_%H-%M-%S).log"
  dmesg > "$LOG_FILE"
  echo "🧠 Crash log dumped to $LOG_FILE"
else
  echo "✅ Clean exit. No crash log."
fi

# Always clear the stamp after boot is handled (whether clean or crash)
rm -f "$STAMP_FILE"

# Create new backup directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
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
