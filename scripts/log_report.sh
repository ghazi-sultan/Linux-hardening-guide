#!/bin/bash
# log_report.sh - Generate a daily security log summary
# For Linux systems with systemd & standard log file structure
# Author: Ghazi Sultan
# Date: $(date +%F)

# Output directory for reports
REPORT_DIR="/var/log/security_reports"
mkdir -p "$REPORT_DIR"

# Timestamp for filenames
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/security_log_summary_$TIMESTAMP.txt"

# Header
echo "===== Daily Security Log Summary - $(date) =====" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. Failed SSH login attempts (from journalctl or auth.log)
echo "[FAILED SSH LOGINS]" >> "$REPORT_FILE"
if command -v journalctl &>/dev/null; then
    journalctl --since "24 hours ago" | grep -i "Failed password" >> "$REPORT_FILE"
else
    grep "Failed password" /var/log/auth.log 2>/dev/null >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# 2. Successful SSH logins
echo "[SUCCESSFUL SSH LOGINS]" >> "$REPORT_FILE"
if command -v journalctl &>/dev/null; then
    journalctl --since "24 hours ago" | grep -i "Accepted password" >> "$REPORT_FILE"
else
    grep "Accepted password" /var/log/auth.log 2>/dev/null >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# 3. Sudo command usage
echo "[SUDO COMMANDS USED]" >> "$REPORT_FILE"
if command -v journalctl &>/dev/null; then
    journalctl --since "24 hours ago" | grep -i "sudo" >> "$REPORT_FILE"
else
    grep "sudo" /var/log/auth.log 2>/dev/null >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# 4. Critical system errors (priority 0,1,2)
echo "[CRITICAL SYSTEM ERRORS]" >> "$REPORT_FILE"
if command -v journalctl &>/dev/null; then
    journalctl -p 0..2 --since "24 hours ago" >> "$REPORT_FILE"
else
    grep -i "error" /var/log/syslog 2>/dev/null >> "$REPORT_FILE"
fi
echo "" >> "$REPORT_FILE"

# 5. Disk space warnings
echo "[DISK SPACE WARNINGS]" >> "$REPORT_FILE"
grep -i "disk space" /var/log/syslog 2>/dev/null >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Footer
echo "===== End of Report =====" >> "$REPORT_FILE"

# Optional: Display report path
echo "Security log summary saved to: $REPORT_FILE"
