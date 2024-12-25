#!/bin/bash

#################################################################
# Script Name: data_management.sh
# Description: Logs migration to external path based on retention period
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# Created: December 2024
# Version: 1.0
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
#
# Script Functions:
# 1. Finds files based on retention period and moves them to destination path
# 2. Supports multiple operations (list, move, delete)
# 3. Handles both files and directories
#################################################################

# Check if source and destination directories exist
if [ ! -d "/source_directory" ] || [ ! -d "/external_directory" ]; then
    echo "Error: Source or destination directory does not exist!"
    exit 1
fi

# Configuration variables
path="/source_directory"
external_dir_path="/external_directory"
retention_period=45 # in days
file_type="*.log"  # type of file

echo "Starting file management operations..."
echo "Source path: $path"
echo "Destination path: $external_dir_path"
echo "Retention period: $retention_period days"
echo "File type: $file_type"
echo "----------------------------------------"

# Method 1:
# To fetch list of files which have crossed retention period
find $path -type f -mtime +$retention_period

# Method 2:
# To delete all files in the directory which have cross retention period
find $path -type f -mtime +$retention_period -delete

# Method 3:
# To get the detailed information of the files which have crossed retention period
find $path -type f -mtime +$retention_period -exec ls -l {} \;

# Method 4:
# To move all the files from source directory to destination directory which have crossed retention period
find $path -type f -mtime +$retention_period -exec mv {} $external_dir_path \;

# Method 5:
# To move all the directories in source directory to destination directory which have crossed retention period
find $path -type d -mtime +$retention_period -exec mv {} $external_dir_path \;

# Below are same examples as above but with a specific file type
echo "Listing specific files:"
find $path -type f -name "$file_type" -mtime +$retention_period

echo -e "\nDeleting specific files:"
find $path -type f -name "$file_type" -mtime +$retention_period -delete

echo -e "\nListing specific files details:"
find $path -type f -name "$file_type" -mtime +$retention_period -exec ls -l {} \;

echo -e "\nMoving specific files:"
find $path -type f -name "$file_type" -mtime +$retention_period -exec mv {} $external_dir_path \;


### Note: Only uncomment/use one method at a time ###
echo -e "\nScript execution completed"