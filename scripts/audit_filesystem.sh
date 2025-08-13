#!/bin/bash
# audit_filesystem.sh
# Checks for insecure file permissions on a Linux system
# Author: Ghazi Sultan
# Part of the Linux Hardening Scripts Collection

# Function to check permissions for world-writable files (excluding /proc)
check_world_writable_files() {
    echo "=== Checking for world-writable files ==="
    find / -xdev -type f -perm -0002 2>/dev/null
    echo
}

# Function to check for world-writable directories without sticky bit
check_world_writable_dirs_no_sticky() {
    echo "=== Checking for world-writable directories without sticky bit ==="
    find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null
    echo
}

# Function to check for unowned files
check_unowned_files() {
    echo "=== Checking for unowned files ==="
    find / -xdev -nouser -o -nogroup 2>/dev/null
    echo
}

# Function to check for SUID/SGID files (potential privilege escalation)
check_suid_sgid_files() {
    echo "=== Checking for SUID/SGID files ==="
    find / -xdev -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null
    echo
}

echo "Filesystem Security Audit - $(date)"
echo "-------------------------------------"
check_world_writable_files
check_world_writable_dirs_no_sticky
check_unowned_files
check_suid_sgid_files
echo "Audit complete."
