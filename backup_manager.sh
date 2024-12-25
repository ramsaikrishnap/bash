#!/bin/bash
#################################################################
# Script Name: backup_manager.sh
# Description: Automated incremental backup script with cleanup
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# Created: December 2024
# Version: 1.0
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
#
# This script performs:
# 1. Full backup on Sundays
# 2. Incremental backups on other days
# 3. Automatic cleanup of backups older than 30 days
#################################################################

# Configuration
BACKUP_DIR="/backup"
SOURCE_DIR="/data"
RETENTION_DAYS=30
DATE=$(date +%Y%m%d)
LOGFILE="/var/log/backup_$(date +%Y%m%d).log"

# Function for logging
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

# Function to check directory existence
check_directory() {
    if [ ! -d "$1" ]; then
        log_message "Error: Directory $1 does not exist!"
        exit 1
    fi
}

# Function to check available disk space
check_disk_space() {
    local required_space=1000000  # Required space in KB (adjust as needed)
    local available_space=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
    
    if [ "$available_space" -lt "$required_space" ]; then
        log_message "Error: Insufficient disk space in $BACKUP_DIR"
        exit 1
    fi
}

# Function to perform backup
perform_backup() {
    local backup_type=$1
    local backup_file=""
    
    if [ "$backup_type" = "full" ]; then
        backup_file="$BACKUP_DIR/full-$DATE.tar.gz"
        log_message "Starting full backup..."
        tar -czf "$backup_file" "$SOURCE_DIR" 2>> "$LOGFILE"
    else
        # Find latest full backup
        local latest_full=$(ls -t "$BACKUP_DIR"/full-*.tar.gz 2>/dev/null | head -n1)
        
        if [ -z "$latest_full" ]; then
            log_message "No full backup found. Creating full backup instead..."
            backup_file="$BACKUP_DIR/full-$DATE.tar.gz"
            tar -czf "$backup_file" "$SOURCE_DIR" 2>> "$LOGFILE"
        else
            backup_file="$BACKUP_DIR/incr-$DATE.tar.gz"
            log_message "Starting incremental backup..."
            tar -czf "$backup_file" --newer="$latest_full" "$SOURCE_DIR" 2>> "$LOGFILE"
        fi
    fi
    
    if [ $? -eq 0 ]; then
        log_message "Backup completed successfully: $backup_file"
    else
        log_message "Error: Backup failed!"
        exit 1
    fi
}

# Function to cleanup old backups
cleanup_old_backups() {
    log_message "Starting cleanup of backups older than $RETENTION_DAYS days..."
    
    local old_backups=$(find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +"$RETENTION_DAYS")
    
    if [ ! -z "$old_backups" ]; then
        echo "$old_backups" | while read -r backup; do
            rm "$backup"
            if [ $? -eq 0 ]; then
                log_message "Deleted old backup: $backup"
            else
                log_message "Error deleting backup: $backup"
            fi
        done
    else
        log_message "No old backups to clean up"
    fi
}

# Main execution
main() {
    log_message "Starting backup process..."
    
    # Check directories exist
    check_directory "$BACKUP_DIR"
    check_directory "$SOURCE_DIR"
    
    # Check available disk space
    check_disk_space
    
    # Determine backup type and perform backup
    if [ "$(date +%u)" -eq 7 ]; then
        perform_backup "full"
    else
        perform_backup "incremental"
    fi
    
    # Cleanup old backups
    cleanup_old_backups
    
    log_message "Backup process completed"
}

# Execute main function with error handling
main || {
    log_message "Script failed with error code $?"
    exit 1
}