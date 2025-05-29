#!/bin/bash

# Script to monitor container crashes and save their logs
# Usage: ./container_crash_monitor.sh

# Get current timestamp for the log file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Function to check container status and save logs
check_container_crashes() {
    # Get all containers that are restarting
    RESTARTING_CONTAINERS=$(docker ps -a --filter "status=restarting" --format "{{.Names}}")
    
    if [ -z "$RESTARTING_CONTAINERS" ]; then
        echo "No containers are currently in a restarting state."
        return
    fi

    # Process each restarting container
    for container in $RESTARTING_CONTAINERS; do
        echo "Container $container is in a restarting state. Saving logs..."
        
        # Create a log file with container name and timestamp
        LOG_FILE="../logs/crashes/${container}_${TIMESTAMP}.log"
        
        # Get container logs and save to file
        echo "=== Container Crash Log for $container ===" > "$LOG_FILE"
        echo "Timestamp: $(date)" >> "$LOG_FILE"
        echo "Container Status:" >> "$LOG_FILE"
        docker inspect --format='{{.State.Status}}' "$container" >> "$LOG_FILE"
        
        # Get health status if available
        HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
        if [ ! -z "$HEALTH_STATUS" ]; then
            echo "Health Status: $HEALTH_STATUS" >> "$LOG_FILE"
            echo -e "\n=== Health Check Logs ===" >> "$LOG_FILE"
            docker inspect --format='{{range .State.Health.Log}}{{.Output}}{{end}}' "$container" >> "$LOG_FILE"
        fi
        
        echo -e "\n=== Container Logs ===" >> "$LOG_FILE"
        docker logs "$container" --tail 1000 >> "$LOG_FILE" 2>&1
        
        echo "Logs saved to $LOG_FILE"
    done
}

# Main execution
echo "Checking for containers in restarting state..."
check_container_crashes 