# TASK 1 System Monitoring Documentation

## Tools Installed

### **htop**
- **Command to Install:**
  ```bash
  sudo apt update && sudo apt install htop -y
  ```
- **Status:** SUCCESS
- **Purpose:** Monitor CPU, memory, and processes interactively in real-time.
- **Command to Launch:**
  ```bash
  htop
  ```
- **Customization:** Added CPU, memory, and process columns for detailed insights.
- **Logging:**
  ```bash
  htop -d 10
  ```

### **nmon**
- **Command to Install:**
  ```bash
  sudo apt update && sudo apt install nmon -y
  ```
- **Status:** SUCCESS
- **Purpose:** Advanced monitoring of CPU, memory, and system performance metrics.

---

## Monitoring Disk Usage

### **Check Disk Space**
- Use the `df` command to log disk usage:
  ```bash
  df -h > /var/log/system_metrics.log
  ```

### **Identify Large Files or Directories**
- Display disk space used by each directory in the current directory:
  ```bash
  du -sh *
  ```
- Display disk space used by the top-level directories in the current directory:
  ```bash
  du -h --max-depth=1
  ```

---

## Monitoring CPU and Memory Usage

### **Identify CPU-Intensive Processes**
- Use the following command to log processes consuming the most CPU:
  ```bash
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head  /var/log/cpu_intensive.log
  ```

### **Identify Memory-Intensive Processes**
- Use the following command to log processes consuming the most memory:
  ```bash
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head  /var/log/memory_intensive.log
  ```

---

## Dynamic Process Monitoring

### **Using `top`**
- Display a dynamic view of system processes sorted by CPU usage:
  ```bash
  top
  ```
- Press `P` to sort by CPU percentage.

---

## Automating Monitoring Tasks

### **Cron Jobs**

#### **Log Disk Space Usage Every Hour**
- **Cron Job Command:**
  ```bash
  0 * * * * df -h > /var/log/system_metrics.log
  ```

#### **Log CPU-Intensive Processes Every 15 Minutes**
- **Cron Job Command:**
  ```bash
  */15 * * * * ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head > /var/log/cpu_intensive.log
  ```

#### **Log Memory-Intensive Processes Every 15 Minutes**
- **Cron Job Command:**
  ```bash
  */15 * * * * ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head > /var/log/memory_intensive.log
  ```

#### **Log Large Files and Directories Every Day**
- **Cron Job Command:**
  ```bash
  0 0 * * * du -h --max-depth=1 > /var/log/large_files.log

# TASK 2 User Account Setup and Configuration

# User Account Setup and Configuration

This guide outlines the steps to create and configure secure user accounts for **Sarah** and **Mike**, including isolated directories, password policies, and verification of settings.

## 1. Create User Accounts

### Add user accounts for Sarah and Mike:
```bash
sudo useradd -m -d /home/Sarah -s /bin/bash Sarah
sudo passwd Sarah

sudo useradd -m -d /home/mike -s /bin/bash mike
sudo passwd mike
```
## 2. Set Up Dedicated Directories

### Create isolated working directories for each user:
```bash
sudo mkdir -p /home/Sarah/workspace
sudo mkdir -p /home/mike/workspace
```
### Change ownership and permissions to ensure isolation:
```bash
sudo chown Sarah:Sarah /home/Sarah/workspace
sudo chmod 700 /home/Sarah/workspace

sudo chown mike:mike /home/mike/workspace
sudo chmod 700 /home/mike/workspace
```

---
## 3. Enforce a Password Policy

### Install the required package:
```bash
sudo apt install libpam-pwquality -y
```
### Configure password complexity in `/etc/security/pwquality.conf`:
```
minlen = 12
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
```
**Explanation**:
- Passwords must:
  - Be at least **12 characters long**.
  - Contain at least **one uppercase letter**.
  - Contain at least **one lowercase letter**.
  - Contain at least **one number**.
  - Contain at least **one special character**.

### Enforce password expiration:
```bash
sudo chage -M 30 Sarah
sudo chage -M 30 mike
```
**Explanation**:
- Passwords expire every **30 days**.

---

## 4. Verify Configuration

### Test login for both users:
```bash
su - Sarah
```

### Check permissions for their directories:
```bash
ls -ld /home/Sarah/workspace /home/mike/workspace
```

### Verify password policy enforcement:
```bash
sudo passwd --status Sarah
sudo passwd --status mike
```

---
## Summary

This guide ensures:
- Secure user account creation.
- Isolated workspaces for Sarah and Mike.
- Strong password policies and regular expiration.
- Proper verification of configurations.

# TASK 3 Automated Backup and Verification for Apache and Nginx

A simple solution to automate and verify backups for Apache and Nginx servers. This setup ensures secure and reliable backups of server configurations and document roots, scheduled weekly using cron jobs.

## Features
- **Automated Backups**: Regular weekly backups using cron jobs.
- **Secure Storage**: Backup files stored in `/backups/` with clear naming conventions.
- **Integrity Verification**: Ensures the backups are complete and error-free.
- **Lightweight Scripts**: Minimal and efficient bash scripts for automation.

---

## Requirements
- Linux-based operating system
- Apache and/or Nginx installed
- Write permissions for `/backups/` directory
- Basic understanding of bash scripting and cron jobs

---

## Getting Started

### 1. Create Backup Scripts

Write two lightweight bash scripts for automating backups:
- `backup_apache.sh`: Compresses Apache server configuration and document root directories, saves the backup in `/backups/`, and verifies its integrity.
- `backup_nginx.sh`: Compresses Nginx server configuration and document root directories, saves the backup in `/backups/`, and verifies its integrity.

---

### 2. Set Permissions
Make the scripts executable:
```bash
chmod +x backup_apache.sh backup_nginx.sh
```

### 3. Create Backup Directory
Ensure the /backups/ directory exists and has proper permissions:

```bash
sudo mkdir -p /backups
sudo chmod 777 /backups
```
### 4. Schedule Cron Jobs
Ensure the /backups/ directory exists and has proper permissions:
Add the scripts to cron for automated execution:
Open the cron editor:
```bash
crontab -e
```
Add these lines to schedule backups every Tuesday at 12:00 AM:
```bash
Copy code
0 0 * * 2 /path/to/backup_apache.sh
0 0 * * 2 /path/to/backup_nginx.sh
```
Save and exit the editor.
How It Works
The scripts compress the server configuration and document root directories into .tar.gz files:

Apache backup files: apache_backup_YYYY-MM-DD.tar.gz
Nginx backup files: nginx_backup_YYYY-MM-DD.tar.gz
Backup files are stored in the /backups/ directory.
Each script verifies the integrity of the backup immediately after its creation.
Verify Backups
Manually verify the backups using these commands:

List the backup files:
```bash
ls /backups/
```
Verify the integrity of specific backups:
```bash
tar -tzf /backups/apache_backup_2024-12-31.tar.gz
tar -tzf /backups/nginx_backup_2024-12-31.tar.gz
```