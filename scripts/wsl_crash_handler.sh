#!/bin/bash

# WSL Crash Handler Script
# Monitors and logs WSL crashes, providing diagnostic information

# Configuration
PROJECT_ROOT="/mnt/d/documents/the-thinking-cluster"
STAMP_FILE="$HOME/.wsl_last_exit_clean"
CRASH_LOG_DIR="$PROJECT_ROOT/logs/crashes"
SYSTEM_LOG_DIR="$PROJECT_ROOT/logs/system"
TIMESTAMP=$(date +%Y-%m-%d-%H%M)

# Create necessary directories
mkdir -p "$CRASH_LOG_DIR"
mkdir -p "$SYSTEM_LOG_DIR"

# Function to collect system information
collect_system_info() {
    local log_file=$1
    echo "🔍 Collecting system information..." >> "$log_file"
    echo "=== System Information ===" >> "$log_file"
    uname -a >> "$log_file" 2>&1
    echo "" >> "$log_file"
    
    echo "=== Memory Information ===" >> "$log_file"
    free -h >> "$log_file" 2>&1
    echo "" >> "$log_file"
    
    echo "=== Disk Usage ===" >> "$log_file"
    df -h >> "$log_file" 2>&1
    echo "" >> "$log_file"
    
    echo "=== Running Processes ===" >> "$log_file"
    ps aux >> "$log_file" 2>&1
    echo "" >> "$log_file"
}

# Function to collect WSL-specific information
collect_wsl_info() {
    local log_file=$1
    echo "🔍 Collecting WSL information..." >> "$log_file"
    echo "=== WSL Version ===" >> "$log_file"
    wsl --version >> "$log_file" 2>&1
    echo "" >> "$log_file"
    
    echo "=== WSL Status ===" >> "$log_file"
    wsl --status >> "$log_file" 2>&1
    echo "" >> "$log_file"
    
    echo "=== WSL List ===" >> "$log_file"
    wsl --list --verbose >> "$log_file" 2>&1
    echo "" >> "$log_file"
}

# Main crash handling logic
if [ ! -f "$STAMP_FILE" ]; then
    # Crash detected
    LOG_FILE="$CRASH_LOG_DIR/crash_$TIMESTAMP.log"
    echo "🚨 WSL crash detected! Creating crash log..." > "$LOG_FILE"
    
    # Collect various logs and information
    echo "📝 Collecting dmesg output..." >> "$LOG_FILE"
    dmesg >> "$LOG_FILE" 2>&1
    echo "" >> "$LOG_FILE"
    
    collect_system_info "$LOG_FILE"
    collect_wsl_info "$LOG_FILE"
    
    echo "✅ Crash log created at: $LOG_FILE"
    
    # Trigger backup after crash
    if [ -f "$PROJECT_ROOT/scripts/backup_manager.sh" ]; then
        echo "🔄 Triggering backup after crash..."
        bash "$PROJECT_ROOT/scripts/backup_manager.sh"
    fi
else
    echo "✅ Clean exit. No crash detected."
fi

# Always clear the stamp after handling
rm -f "$STAMP_FILE"

# Create a new stamp file for next boot
touch "$STAMP_FILE" 