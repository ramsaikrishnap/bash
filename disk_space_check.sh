#!/bin/bash
#################################################################
# Script Name: disk_space_check.sh
# Description: Monitor disk space usage and directory sizes
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# Created: December 2024
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
# Version: 1.0
#
# This script performs:
# 1. Full backup on Sundays
# 2. Incremental backups on other days
# 3. Automatic cleanup of backups older than 30 days
#################################################################

# Configuration variables
threshold=90                           # Disk usage threshold percentage
alert_email="person@example.com"       # Email address for alerts
path="/my_working_directory"           # Base path for directory space check

# Function to check if a directory exists
check_directory() {
    if [ ! -d "$1" ]; then
        echo "Error: Directory $1 does not exist!"
        exit 1
    fi
}

# Function to send email alert
send_alert() {
    local partition="$1"
    local usage="$2"
    echo "Warning: $partition is at $usage%" | mail -s "Disk Space Alert" "$alert_email"
}

# Function to check disk space usage
check_disk_space() {
    echo "=== Checking Disk Space Usage ==="
    df -h | grep -v "Filesystem" | awk '{print $5 " " $6}' | while read -r output; do
        usage=$(echo "$output" | awk '{print $1}' | cut -d'%' -f1)
        partition=$(echo "$output" | awk '{print $2}')
        
        if [ "$usage" -ge "$threshold" ]; then
            echo "Warning: $partition is at $usage%"
            # Uncomment below line if SMTP is configured
            # send_alert "$partition" "$usage"
        fi
    done
}

# Function to report directory sizes
report_directory_sizes() {
    echo "=== Directory Space Report ==="
    # Check if base path exists
    check_directory "$path"
    
    # Save current directory
    original_path=$(pwd)
    
    # Get list of directories (excluding hidden directories)
    directory_list=$(find "$path" -maxdepth 1 -type d ! -path "*/\.*" ! -path "$path")
    
    # Check if any directories were found
    if [ -z "$directory_list" ]; then
        echo "No directories found in $path"
        return
    }
    
    # Loop through each directory
    for dir in $directory_list; do
        if [ -d "$dir" ]; then
            space=$(du -sh "$dir" 2>/dev/null | awk '{print $1}')
            if [ $? -eq 0 ]; then
                echo "Space in $dir: $space"
            else
                echo "Error getting size for $dir"
            fi
        fi
    done
    
    # Return to original directory
    cd "$original_path" || exit 1
}

# Main execution
echo "Starting disk space monitoring script..."
echo "----------------------------------------"

# Run disk space check
check_disk_space

echo "----------------------------------------"

# Run directory space report
report_directory_sizes

echo "----------------------------------------"
echo "Script execution completed"