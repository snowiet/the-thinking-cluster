#!/bin/bash

# Backup Manager Script
# Handles automated backups of services and cleanup of old backups

# Configuration
PROJECT_ROOT="$HOME/the-thinking-cluster"
BACKUP_ROOT="$PROJECT_ROOT/backups"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

# List of services to backup
declare -A SERVICES=(
    ["grafana"]="grafana_data"
    ["prometheus"]="prometheus_data"
    ["node_exporter"]="node_exporter_data"
    ["alertmanager"]="alertmanager_data"
)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to clean up old backups
cleanup_old_backups() {
    echo "🧹 Cleaning up old backups..."
    
    # Remove backups older than 3 days
    find "$BACKUP_ROOT" -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \;
    
    # Remove auto-generated backups older than 45 minutes
    find "$BACKUP_ROOT" -maxdepth 1 -type d -name "auto-*" -mmin +45 -exec rm -rf {} \;
    
    # Remove empty directories
    find "$BACKUP_ROOT" -type d -empty -delete
}

# Function to backup a service
backup_service() {
    local service_name=$1
    local service_dir=$2
    
    if [ -d "$PROJECT_ROOT/$service_dir" ]; then
        echo "📦 Backing up $service_name..."
        tar -czf "$BACKUP_DIR/${service_name}.tar.gz" -C "$PROJECT_ROOT" "$service_dir"
        return 0
    else
        echo "⚠️  Warning: $service_name directory not found"
        return 1
    fi
}

# Main backup process
echo "🚀 Starting backup process..."

# Backup each service
for service_name in "${!SERVICES[@]}"; do
    backup_service "$service_name" "${SERVICES[$service_name]}"
done

# Backup configuration files
if [ -d "$PROJECT_ROOT/compose" ]; then
    echo "📦 Backing up compose configurations..."
    tar -czf "$BACKUP_DIR/compose_configs.tar.gz" -C "$PROJECT_ROOT" compose/
fi

if [ -d "$PROJECT_ROOT/scripts" ]; then
    echo "📦 Backing up scripts..."
    tar -czf "$BACKUP_DIR/scripts.tar.gz" -C "$PROJECT_ROOT" scripts/
fi

# Backup environment files
if [ -f "$PROJECT_ROOT/.env" ]; then
    echo "📦 Backing up environment file..."
    cp "$PROJECT_ROOT/.env" "$BACKUP_DIR/"
fi

# Create manifest
echo "📝 Creating backup manifest..."
echo "Backup created on $(date)" > "$BACKUP_DIR/manifest.txt"
echo "Contents:" >> "$BACKUP_DIR/manifest.txt"
ls -R "$BACKUP_DIR" >> "$BACKUP_DIR/manifest.txt"

# Cleanup old backups
cleanup_old_backups

echo "✅ Backup process completed successfully!" 
