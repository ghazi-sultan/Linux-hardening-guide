#!/bin/bash

# run_rkhunter.sh
# Runs a rootkit check with rkhunter and optionally emails the results.

# ------------------------------
# Configuration
# ------------------------------
EMAIL="" # Set to your email address if you want results emailed
LOG_FILE="/var/log/rkhunter.log"

# ------------------------------
# Check if rkhunter is installed
# ------------------------------
if ! command -v rkhunter &> /dev/null; then
    echo "[!] rkhunter not found. Installing..."
    sudo apt-get update && sudo apt-get install -y rkhunter
fi

# ------------------------------
# Update rkhunter data files
# ------------------------------
echo "[*] Updating rkhunter data..."
sudo rkhunter --update

# ------------------------------
# Run the rootkit scan
# ------------------------------
echo "[*] Running rootkit scan..."
sudo rkhunter --check --sk

# ------------------------------
# Send results via email (optional)
# ------------------------------
if [[ -n "$EMAIL" ]]; then
    echo "[*] Emailing results to $EMAIL..."
    mail -s "rkhunter Scan Report - $(hostname)" "$EMAIL" < "$LOG_FILE"
fi

echo "[+] Scan completed. Log available at: $LOG_FILE"
