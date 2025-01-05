#!/bin/bash
# Define backup destination
BACKUP_DIR="/backups"
TIMESTAMP=$(date +%F)
BACKUP_FILE="${BACKUP_DIR}/apache_backup_${TIMESTAMP}.tar.gz"

# Create backup
tar -czf $BACKUP_FILE /etc/httpd/ /var/www/html/

# Verify backup
if [ -f "$BACKUP_FILE" ]; then
    echo "Backup created successfully: $BACKUP_FILE"
    tar -tzf $BACKUP_FILE > /dev/null
    if [ $? -eq 0 ]; then
        echo "Backup verified successfully"
    else
        echo "Backup verification failed"
    fi
else
    echo "Backup creation failed"
fi
