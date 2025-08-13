#!/bin/bash
# disable_services.sh
# This script lists all enabled systemd services and allows the user to disable unnecessary ones.
# Intended for system hardening — disabling unused services reduces attack surface.

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)." >&2
    exit 1
fi

echo "=== Listing all enabled services ==="
systemctl list-unit-files --type=service --state=enabled | awk 'NR>1 && $1 != "" {print NR-1 ": " $1}' 

echo ""
read -p "Enter the numbers of the services you want to disable (comma-separated): " selection

# Convert comma-separated list to an array
IFS=',' read -ra service_numbers <<< "$selection"

# Get the list of enabled services
mapfile -t enabled_services < <(systemctl list-unit-files --type=service --state=enabled | awk 'NR>1 && $1 != "" {print $1}')

# Loop through selected numbers and disable the corresponding service
for num in "${service_numbers[@]}"; do
    # Trim spaces
    num=$(echo "$num" | xargs)
    if [[ "$num" =~ ^[0-9]+$ ]] && (( num > 0 && num <= ${#enabled_services[@]} )); then
        service_name="${enabled_services[$((num-1))]}"
        read -p "Disable service '$service_name'? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            systemctl disable "$service_name" && echo "Disabled: $service_name"
        else
            echo "Skipped: $service_name"
        fi
    else
        echo "Invalid selection: $num"
    fi
done

echo "=== Done. You may run 'systemctl stop <service>' to stop them immediately if needed. ==="
