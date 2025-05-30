#!/bin/bash

# WSL Crash Handler Script
# Purpose: Monitors and logs WSL crashes, providing diagnostic information
# Impact of removal: No automatic crash detection and logging

# Configuration
PROJECT_ROOT="$HOME/the-thinking-cluster"  # Root directory of the project
STAMP_FILE="$HOME/.wsl_last_exit_clean"  # File to track clean exits
CRASH_LOG_DIR="$PROJECT_ROOT/logs/crashes"  # Where to store crash logs
SYSTEM_LOG_DIR="$PROJECT_ROOT/logs/system"  # Where to store system logs
TIMESTAMP=$(date +%Y-%m-%d-%H%M)  # Current timestamp for log files

# Create necessary directories
mkdir -p "$CRASH_LOG_DIR"
mkdir -p "$SYSTEM_LOG_DIR"

# Function to collect system information
# Purpose: Gathers detailed system state information
# Impact of removal: No system state information in crash logs
collect_system_info() {
    local log_file=$1
    echo "🔍 Collecting system information..." >> "$log_file"
    echo "=== System Information ===" >> "$log_file"
    uname -a >> "$log_file" 2>&1  # OS and kernel information
    echo "" >> "$log_file"
    
    echo "=== Memory Information ===" >> "$log_file"
    free -h >> "$log_file" 2>&1  # Memory usage statistics
    echo "" >> "$log_file"
    
    echo "=== Disk Usage ===" >> "$log_file"
    df -h >> "$log_file" 2>&1  # Disk space usage
    echo "" >> "$log_file"
    
    echo "=== Running Processes ===" >> "$log_file"
    ps aux >> "$log_file" 2>&1  # List of running processes
    echo "" >> "$log_file"
}

# Purpose: Gathers WSL-specific diagnostic information
# Impact of removal: No WSL-specific information in crash logs
collect_wsl_info() {
    local log_file=$1
    echo "🔍 Collecting WSL information..." >> "$log_file"
    echo "=== WSL Version ===" >> "$log_file"
    wsl --version >> "$log_file" 2>&1  # WSL version information
    echo "" >> "$log_file"
    
    echo "=== WSL Status ===" >> "$log_file"
    wsl --status >> "$log_file" 2>&1  # Current WSL status
    echo "" >> "$log_file"
    
    echo "=== WSL List ===" >> "$log_file"
    wsl --list --verbose >> "$log_file" 2>&1  # List of WSL distributions
    echo "" >> "$log_file"
}

# Main crash handling logic
if [ ! -f "$STAMP_FILE" ]; then
    # Crash detected
    LOG_FILE="$CRASH_LOG_DIR/crash_$TIMESTAMP.log"
    echo "🚨 WSL crash detected! Creating crash log..." > "$LOG_FILE"
    
    # Collect various logs and information
    echo "📝 Collecting dmesg output..." >> "$LOG_FILE"
    dmesg >> "$LOG_FILE" 2>&1  # Kernel ring buffer messages
    echo "" >> "$LOG_FILE"
    
    collect_system_info "$LOG_FILE"
    collect_wsl_info "$LOG_FILE"
    
    echo "✅ Crash log created at: $LOG_FILE"
    
    # Trigger backup after crash
    # Purpose: Preserve system state after a crash
    # Impact of removal: No automatic backup after crashes
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
