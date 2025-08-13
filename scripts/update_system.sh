#!/bin/bash
#
# update_system.sh
# Updates the system packages and performs basic cleanup.
# Supports Debian/Ubuntu (apt) and Fedora/RHEL/CentOS (dnf).
#
# Usage: sudo bash update_system.sh
#

# Exit immediately if a command fails
set -e

echo "=============================="
echo " Linux System Update & Cleanup"
echo "=============================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Detect package manager and run appropriate commands
if command -v apt >/dev/null 2>&1; then
    echo "[*] Detected apt-based system (Debian/Ubuntu)"
    apt update && apt upgrade -y
    apt autoremove -y
    apt autoclean -y

elif command -v dnf >/dev/null 2>&1; then
    echo "[*] Detected dnf-based system (Fedora/RHEL/CentOS)"
    dnf check-update || true
    dnf upgrade -y
    dnf autoremove -y
    dnf clean all

else
    echo "[!] Unsupported package manager. Please update manually."
    exit 1
fi

echo "=============================="
echo " Update and cleanup complete!"
echo "=============================="
