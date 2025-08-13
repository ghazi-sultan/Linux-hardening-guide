#!/bin/bash
# firewall_setup.sh
# Configures UFW firewall with secure defaults

# Exit immediately if a command fails
set -e

echo "Installing UFW..."
sudo apt update && sudo apt install -y ufw

echo "Setting default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Allowing SSH (port 22)..."
sudo ufw allow 22/tcp

echo "Enabling UFW..."
sudo ufw --force enable

echo "Firewall status:"
sudo ufw status verbose
