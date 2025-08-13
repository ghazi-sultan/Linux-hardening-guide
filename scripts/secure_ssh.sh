#!/bin/bash
# Secure Shell (SSH) Configuration Script
# This script checks for SSH installation, installs if missing, and applies security hardening.

# Check if SSH server is installed
if ! command -v sshd &> /dev/null; then
    echo "OpenSSH server not found. Installing..."
    sudo apt update && sudo apt install -y openssh-server
else
    echo "OpenSSH server is already installed."
fi

# Backup existing SSH config
CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"
if [ ! -f "$BACKUP_FILE" ]; then
    sudo cp "$CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of SSH configuration created at $BACKUP_FILE"
else
    echo "Backup already exists: $BACKUP_FILE"
fi

# Apply security settings
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$CONFIG_FILE"
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$CONFIG_FILE"
sudo sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$CONFIG_FILE"
sudo sed -i 's/^#\?Protocol.*/Protocol 2/' "$CONFIG_FILE"

# Restart SSH to apply changes
sudo systemctl restart ssh
echo "SSH configuration hardened. Root login disabled, password auth disabled, Protocol set to 2."
