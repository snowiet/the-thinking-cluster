#!/bin/bash

# Backup Manager Script
# Handles automated backups of services and cleanup of old backups

# Configuration
# Determine Project Root dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)" # Assumes scripts/ is one level below project root

BACKUP_ROOT="$PROJECT_ROOT/backups"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"

# List of service configuration directories to backup (relative to PROJECT_ROOT)
declare -A SERVICES_TO_BACKUP_CONFIGS=(\
    ["grafana"]="grafana" \
    ["prometheus"]="prometheus" \
    ["alertmanager"]="alertmanager" \
    ["loki"]="loki" \
    ["promtail"]="promtail" \
)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to clean up old backups
cleanup_old_backups() {
    echo "🧹 Cleaning up old backups..."
    
    # Remove backups older than 3 days
    find "$BACKUP_ROOT" -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \\;
    
    # Remove auto-generated backups older than 45 minutes (if applicable to your naming)
    # find "$BACKUP_ROOT" -maxdepth 1 -type d -name "auto-*" -mmin +45 -exec rm -rf {} \\;
    
    # Remove empty directories
    find "$BACKUP_ROOT" -type d -empty -delete
}

# Function to backup a service's configuration
backup_service_config() {
    local service_name=$1
    local service_config_dir_relative=$2 # Relative path from PROJECT_ROOT e.g., "grafana"
    local service_config_full_path="$PROJECT_ROOT/$service_config_dir_relative"
    
    if [ -d "$service_config_full_path" ]; then
        echo "📦 Backing up $service_name configuration from '$service_config_dir_relative'..."
        tar -czf "$BACKUP_DIR/${service_name}_config.tar.gz" -C "$PROJECT_ROOT" "$service_config_dir_relative"
        return 0
    else
        echo "⚠️  Warning: $service_name configuration directory '$service_config_full_path' not found"
        return 1
    fi
}

# Main backup process
echo "🚀 Starting backup process..."

# Backup each service's configuration
for service_name in "${!SERVICES_TO_BACKUP_CONFIGS[@]}"; do
    backup_service_config "$service_name" "${SERVICES_TO_BACKUP_CONFIGS[$service_name]}"
done

# Backup docker-compose.yml file
if [ -f "$PROJECT_ROOT/docker-compose.yml" ]; then
    echo "📦 Backing up docker-compose.yml..."
    cp "$PROJECT_ROOT/docker-compose.yml" "$BACKUP_DIR/docker-compose.yml"
else
    echo "⚠️  Warning: docker-compose.yml not found at $PROJECT_ROOT/docker-compose.yml"
fi

if [ -d "$PROJECT_ROOT/scripts" ]; then
    echo "📦 Backing up scripts..."
    tar -czf "$BACKUP_DIR/scripts.tar.gz" -C "$PROJECT_ROOT" scripts/
fi

# Backup environment files
if [ -f "$PROJECT_ROOT/.env" ]; then
    echo "📦 Backing up environment file..."
    cp "$PROJECT_ROOT/.env" "$BACKUP_DIR/.env" # Copy to backup dir, not just root of it
fi

# Create manifest
echo "📝 Creating backup manifest..."
echo "Backup created on $(date)" > "$BACKUP_DIR/manifest.txt"
echo "Contents:" >> "$BACKUP_DIR/manifest.txt"
ls -R "$BACKUP_DIR" >> "$BACKUP_DIR/manifest.txt"

# Cleanup old backups
cleanup_old_backups

echo "✅ Backup process completed successfully!" 
