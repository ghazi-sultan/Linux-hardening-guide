#!/bin/bash
# backup_home.sh
# Description: Backs up the user's home directory to a chosen local or remote location using rsync.

# Exit immediately if a command fails
set -e

# === CONFIGURATION ===
SRC_DIR="$HOME/"
# Destination can be local (e.g., /mnt/backup) or remote (e.g., user@remote:/backup)
DEST_DIR="$1"  

# Optional: log file
LOG_FILE="$HOME/backup_home.log"

# === USAGE CHECK ===
if [ -z "$DEST_DIR" ]; then
    echo "Usage: $0 <destination_path>"
    echo "Example: $0 /mnt/backup"
    echo "         $0 user@remote:/backup"
    exit 1
fi

# === RUN BACKUP ===
echo "[$(date)] Starting backup from $SRC_DIR to $DEST_DIR" | tee -a "$LOG_FILE"

rsync -avh --delete \
    --exclude='.cache/' \
    --exclude='Downloads/' \
    "$SRC_DIR" "$DEST_DIR" \
    | tee -a "$LOG_FILE"

echo "[$(date)] Backup completed successfully." | tee -a "$LOG_FILE"

# === OPTIONAL RESTORE TEST ===
# To test restoring, you can run:
# rsync -avh <destination_path>/ <restore_test_directory>/
