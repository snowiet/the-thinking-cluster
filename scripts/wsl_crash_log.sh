#!/bin/bash

STAMP_FILE="$HOME/.wsl_last_exit_clean"
CRASH_LOG_DIR="/mnt/d/documents/the-thinking-cluster/logs/dmesg"
mkdir -p "$CRASH_LOG_DIR"

if [ ! -f "$STAMP_FILE" ]; then
  LOG_FILE="$CRASH_LOG_DIR/dmesg_$(date +%F_%H-%M-%S).log"
  dmesg > "$LOG_FILE"
  echo "🧠 Crash log dumped to $LOG_FILE"
else
  echo "✅ Clean last exit detected. No crash log needed."
fi

# Always clear the stamp after boot is handled (whether clean or crash)
rm -f "$STAMP_FILE"
