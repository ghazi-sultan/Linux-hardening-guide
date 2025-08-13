# Linux Hardening Guide with Bash Scripts

## 1. Introduction
- Why hardening is important for Linux systems (servers, desktops, IoT).
- Scope: beginner-friendly but covers essential security practices.
- Includes Bash scripts to automate common tasks.

---

## 2. Keep Your System Updated
- Update package lists & install available updates.
- Enable automatic security updates.

    sudo apt update && sudo apt upgrade -y   # Debian/Ubuntu
    sudo dnf update -y                       # Fedora/RHEL

- **Script:** `update_system.sh` – automates system update and cleanup.

---

## 3. Manage Users and Permissions
- Enforce strong password policies (`/etc/login.defs`).
- Remove unnecessary users & groups.
- Add users to `sudo` group instead of using root login.

    sudo usermod -aG sudo <username>

- **Script:** `check_users.sh` – lists all accounts, highlights those with UID 0 or no password.

---

## 4. Secure SSH Access
- Change default SSH port.
- Disable root login (`PermitRootLogin no`).
- Use key-based authentication (`ssh-keygen`).
- Install and configure `fail2ban`.
- **Script:** `secure_ssh.sh` – applies recommended SSH settings.

---

## 5. Configure Firewall
- Install and enable UFW or firewalld.
- Default deny incoming, allow outgoing.

    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 22/tcp
    sudo ufw enable

- **Script:** `firewall_setup.sh` – applies recommended firewall rules.

---

## 6. Disable Unnecessary Services
- Check enabled services:

    systemctl list-unit-files --type=service --state=enabled

- Disable unused services.
- **Script:** `disable_services.sh` – interactively disable services.

---

## 7. File System Security
- Set restrictive `/tmp` mount options (e.g., `noexec`, `nodev`, `nosuid`).
- Enable full-disk encryption with LUKS (new installs).
- Install and configure `AIDE` for integrity checks.

    sudo apt install -y aide
    sudo aideinit

- **Script:** `audit_filesystem.sh` – checks for insecure file permissions.

---

## 8. Log Monitoring
- Use `journalctl` and `/var/log/*` for system/app logs.
- Configure log rotation (e.g., `logrotate`).
- Consider remote/centralized logging.
- **Script:** `log_report.sh` – generates a daily security log summary.

---

## 9. Intrusion Detection
- Install `rkhunter` and/or `chkrootkit`.
- Schedule regular scans and review results.
- **Script:** `run_rkhunter.sh` – runs a rootkit check and (optionally) emails results.

---

## 10. AppArmor or SELinux
- Verify status of SELinux or AppArmor.

    sestatus        # SELinux (RHEL/Fedora)
    sudo aa-status  # AppArmor (Ubuntu/Debian)

- Enforce targeted policy; avoid disabling unless necessary.

---

## 11. Backup & Recovery
- Use `rsync` for local/remote backups.
- Schedule backups with `cron` or `systemd` timers.
- Test restoration regularly.
- **Script:** `backup_home.sh` – backs up the home directory to a chosen location.

---

## 12. Quick Security Audit Script
- One script to run multiple checks:
  - Firewall status
  - SSH configuration sanity checks
  - Package update status
  - Weak/default accounts & sudoers sanity
- **Script:** `linux_audit.sh`

---

## Bash Scripts in This Guide
1. `update_system.sh` – Automates system update and cleanup.
2. `check_users.sh` – Lists accounts and highlights insecure ones.
3. `secure_ssh.sh` – Applies secure SSH configuration.
4. `firewall_setup.sh` – Configures recommended firewall rules.
5. `disable_services.sh` – Interactively disables unnecessary services.
6. `audit_filesystem.sh` – Checks for insecure file permissions.
7. `log_report.sh` – Generates a daily log summary.
8. `run_rkhunter.sh` – Runs a rootkit scan and emails results.
9. `backup_home.sh` – Creates a backup of the home directory.
10. `linux_audit.sh` – Performs a quick system security audit.
