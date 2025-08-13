#!/bin/bash
# linux_audit.sh
# Quick Security Audit Script
# Checks:
# 1. Firewall status
# 2. SSH configuration sanity
# 3. Package update status
# 4. Weak/default accounts & sudoers sanity

# Color codes
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
NC="\e[0m" # No Color

echo -e "${YELLOW}=== Linux Quick Security Audit ===${NC}"
echo "Running checks... (requires sudo for some commands)"
echo

# 1. Firewall status
echo -e "${YELLOW}[1] Firewall Status:${NC}"
if command -v ufw >/dev/null 2>&1; then
    sudo ufw status verbose
elif command -v firewall-cmd >/dev/null 2>&1; then
    sudo firewall-cmd --state
else
    echo -e "${RED}No supported firewall command found (ufw/firewalld).${NC}"
fi
echo

# 2. SSH configuration sanity
echo -e "${YELLOW}[2] SSH Configuration:${NC}"
if [ -f /etc/ssh/sshd_config ]; then
    echo "PermitRootLogin: $(grep -Ei '^PermitRootLogin' /etc/ssh/sshd_config | awk '{print $2}')"
    echo "PasswordAuthentication: $(grep -Ei '^PasswordAuthentication' /etc/ssh/sshd_config | awk '{print $2}')"
    grep -Ei '^PermitRootLogin|^PasswordAuthentication' /etc/ssh/sshd_config >/dev/null || \
        echo -e "${RED}Key SSH directives not explicitly set!${NC}"
else
    echo -e "${RED}SSH configuration file not found!${NC}"
fi
echo

# 3. Package update status
echo -e "${YELLOW}[3] Package Update Status:${NC}"
if command -v apt >/dev/null 2>&1; then
    sudo apt update -qq
    UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
    echo "$((UPDATES - 1)) packages can be upgraded."
elif command -v dnf >/dev/null 2>&1; then
    UPDATES=$(dnf check-update --quiet | wc -l)
    echo "$UPDATES packages can be upgraded."
elif command -v yum >/dev/null 2>&1; then
    UPDATES=$(yum check-update --quiet | wc -l)
    echo "$UPDATES packages can be upgraded."
else
    echo -e "${RED}Package manager not recognized (apt/dnf/yum).${NC}"
fi
echo

# 4. Weak/default accounts & sudoers sanity
echo -e "${YELLOW}[4] Weak/Default Accounts & Sudoers Check:${NC}"
echo "Accounts with empty passwords:"
sudo awk -F: '($2 == "" ) { print $1 }' /etc/shadow

echo
echo "Accounts with UID 0 (root privileges):"
sudo awk -F: '($3 == 0) { print $1 }' /etc/passwd

echo
echo "Users in sudoers or sudo group:"
if [ -f /etc/sudoers ]; then
    sudo grep -E '^[^#].*ALL=\(ALL' /etc/sudoers
fi
getent group sudo 2>/dev/null || getent group wheel 2>/dev/null
echo

echo -e "${GREEN}=== Audit Complete ===${NC}"
