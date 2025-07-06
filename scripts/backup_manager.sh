#!/bin/bash

# Backup Manager Script
# Purpose: Creates timestamped backups of all service configurations and data
# Impact of removal: No automated backups of the monitoring stack

# Configuration
# Determine Project Root dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)" # Assumes scripts/ is one level below project root

BACKUP_ROOT="$PROJECT_ROOT/backups"  # Where to store backups
TIMESTAMP=$(date +%Y-%m-%d-%H%M)  # Current timestamp for backup directory
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"  # Full path to backup directory

# List of service configuration directories to backup (relative to PROJECT_ROOT)
# Purpose: Defines which services need their configurations backed up
# Impact of removal: No service configurations would be backed up
declare -A SERVICES_TO_BACKUP_CONFIGS=(\
    ["grafana"]="grafana" \
    ["prometheus"]="prometheus" \
    ["loki"]="loki" \
    ["promtail"]="promtail" \
)

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to clean up old backups
# Purpose: Removes backups older than specified time periods
# Impact of removal: No automatic cleanup of old backups
cleanup_old_backups() {
    echo "🧹 Cleaning up old backups..."
    
    # Remove backups older than 3 days
    find "$BACKUP_ROOT" -maxdepth 1 -type d -mtime +3 -exec rm -rf {} \;
    
    # Remove backup directories created within the last 60 minutes (excluding current)
    find "$BACKUP_ROOT" -maxdepth 1 -mindepth 1 -type d -mmin -60 ! -path "$BACKUP_DIR" -exec rm -rf {} \;

    # Remove empty directories
    find "$BACKUP_ROOT" -type d -empty -delete
}

# Function to backup a service's configuration
# Purpose: Creates a compressed archive of a service's configuration
# Impact of removal: No individual service configuration backups
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
# Purpose: Preserves the main stack configuration
# Impact of removal: No backup of the main stack configuration
if [ -f "$PROJECT_ROOT/docker-compose.yml" ]; then
    echo "📦 Backing up docker-compose.yml..."
    cp "$PROJECT_ROOT/docker-compose.yml" "$BACKUP_DIR/docker-compose.yml"
else
    echo "⚠️  Warning: docker-compose.yml not found at $PROJECT_ROOT/docker-compose.yml"
fi

# Backup scripts directory
# Purpose: Preserves all utility scripts
# Impact of removal: No backup of utility scripts
if [ -d "$PROJECT_ROOT/scripts" ]; then
    echo "📦 Backing up scripts..."
    tar -czf "$BACKUP_DIR/scripts.tar.gz" -C "$PROJECT_ROOT" scripts/
fi

# Backup environment files
# Purpose: Preserves environment variables and secrets
# Impact of removal: No backup of environment configuration
if [ -f "$PROJECT_ROOT/.env" ]; then
    echo "📦 Backing up environment file..."
    cp "$PROJECT_ROOT/.env" "$BACKUP_DIR/.env" # Copy to backup dir, not just root of it
fi

# Backup named volumes (if containers are running)
# Purpose: Preserves persistent data from Grafana, Prometheus, and Loki
# Impact of removal: No backup of persistent application data
echo "📦 Backing up named volumes..."
if command -v docker &> /dev/null; then
    # Backup Grafana data
    if docker volume ls | grep -q "the-thinking-cluster_grafana_data"; then
        echo "  - Backing up Grafana data volume..."
        docker run --rm -v "the-thinking-cluster_grafana_data:/data" -v "$BACKUP_DIR:/backup" alpine tar -czf /backup/grafana_data.tar.gz -C /data .
    fi
    
    # Backup Prometheus data
    if docker volume ls | grep -q "the-thinking-cluster_prometheus_data"; then
        echo "  - Backing up Prometheus data volume..."
        docker run --rm -v "the-thinking-cluster_prometheus_data:/data" -v "$BACKUP_DIR:/backup" alpine tar -czf /backup/prometheus_data.tar.gz -C /data .
    fi
    
    # Backup Loki data
    if docker volume ls | grep -q "the-thinking-cluster_loki_data"; then
        echo "  - Backing up Loki data volume..."
        docker run --rm -v "the-thinking-cluster_loki_data:/data" -v "$BACKUP_DIR:/backup" alpine tar -czf /backup/loki_data.tar.gz -C /data .
    fi
else
    echo "⚠️  Warning: Docker not available, skipping volume backups"
fi

# Create manifest
# Purpose: Documents the contents of the backup
# Impact of removal: No documentation of backup contents
echo "📝 Creating backup manifest..."
echo "Backup created on $(date)" > "$BACKUP_DIR/manifest.txt"
echo "Contents:" >> "$BACKUP_DIR/manifest.txt"
ls -R "$BACKUP_DIR" >> "$BACKUP_DIR/manifest.txt"

# Cleanup old backups
cleanup_old_backups

echo "✅ Backup process completed successfully!" 
