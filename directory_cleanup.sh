#!/bin/bash
#################################################################
# Script Name: directory_cleanup.sh
# Description: Script for deleting directories based on retention period
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
# Creation Date: December 2024
# Version: 1.0
#
# Usage: ./directory_cleanup.sh
# This script scans a specified directory and removes subdirectories 
# that are older than the defined retention period.
#################################################################

path="/path/to/log/directory"  # Can be replaced with path you want
retention_period=45            # retention period in days

spacecheck() {
    space=$(du -sh "$1")
    echo "Disk space in the $1 path $2 cleanup: $space"
}

spacecheck "$path" "before"

directories=$(find "$path" -type d -mtime +"$retention_period")

if [ ! -z "$directories" ]; then
    dir_count=$(echo "$directories" | wc --words)
    echo "We found $dir_count directories have crossed retention period in $path. Hence this will be deleted....."
else
    echo "No directories have crossed retention period in $path. Hence no directories will be deleted ...."
    spacecheck "$path" "after"
    echo "Exiting the script ....."
    exit 1
fi

for dir in $directories; do
    echo "Initiating the directory deletion: $dir"
    rm -rf "$dir"
    if [ $? -eq 0 ]; then
        echo "Successfully deleted $dir directory"
    else
        echo "Failed to delete $dir directory"
    fi
done

spacecheck "$path" "after"