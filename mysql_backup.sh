#!/bin/bash
#################################################################
# Script Name: mysql_backup.sh
# Description: Database backup script for MySQL/MariaDB databases
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# Created: December 2024
# Version: 1.0
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
#
# Script Functions:
# 1. Takes backup of MySQL/MariaDB databases
# 2. Supports single database or all databases backup
# 3. Can create separate backups for each database
# 4. Maintains backup retention period of 45 days
#################################################################

### Database Credentials File (.dbcreds) ###
# Store database connection details in separate file
# Format of .dbcreds file:
: '
db_host="localhost"
db_user="backupuser"
db_pass="my_bkp_user_pwd"
db_name="my_db"
'

# Source the credentials file
source .dbcreds     # NOTE: Potential syntax issue - should check if file exists before sourcing

# Define backup directory path
backup_dir="/path/to/backup_directory_path"

# Create main backup directory if it doesn't exist
if [ ! -d "$backup_dir" ];  then     
    mkdir -p $backup_dir             
    if [ $? -ne 0 ];     then        
        echo "Failed to create the backup directory : $backup_dir"
    fi
fi

# Create date-specific backup directory
backup_date=$backup_dir/$(date +%Y-%m-%d)

# Create date-specific directory if it doesn't exist
if [ ! -d "$backup_date" ];  then    
    mkdir -p $backup_date            
    if [ $? -ne 0 ];     then
        echo "Failed to create the backup directory : $backup_date"
    fi
fi

# Define backup filename
backup_filename=$backup_date".sql"    

### Backup Methods ###
# Method 1: Single Database Backup
# Use this for backing up a specific database
mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" "$db_name" > "$backup_filename"

# Method 2: All Databases Backup (Simple)
# Use this for backing up all databases in a single file
mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" --all-databases > "$backup_filename"

# Method 3: All Databases Backup (Advanced)
# Use this for backing up all databases with additional safety options
mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" --all-databases  --single-transaction --quick --lock-tables=false > "$backup_filename"

### Method 4: Separate Backup for Each Database ###
# Step 1: Get list of databases (excluding system databases)
databaseslist=$(mysql -h "$db_host" -u "$db_user" -p "$db_pass" -e "SHOW DATABASES;" | grep -Ev "Database|information_schema|performance_schema|mysql|sys")

# Step 2: Create individual backups for each database
for db in $databaseslist; do         
    backup_filename="$backup_date/backup-${db}.sql"
    mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" "$db" > "$backup_filename"
    if [ $? -ne 0 ]     then
        echo "Failed to take backup of database"
    else
        echo "Backup is success : $backup_filename"
    fi
done

# Step 3: Clean up old backups (45 days retention)
find $backup_date -type d -mtime +45 -delete    

### Note: Only uncomment/use one backup method at a time ###