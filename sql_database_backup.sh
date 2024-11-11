#!/bin/bash


### Source file for DB credentials with name .dbcreds
### We will use this file for fetching the credentials for Database Authentication
### Objective of this script is to take backup of Mysql/MariaDB Database in linux using mysqldump

:'
db_host="localhost"
db_user="backupuser"
db_pass="my_bkp_user_pwd"
db_name="my_db"
'

# Sourcing credentails file 
source .dbcreds

# Path for storing backups
backup_dir="/path/to/backup_directory_path"

# Create the backup directory if not existed
if [ ! -d "$backup_dir" ]; 
then
    mkdir -p $backup_dir
    if [ $? -ne 0 ];
    then
        echo "Failed to create the backup directory : $backup_dir"
    fi
fi

# Directory based on date of trigger inside the backup_dir directory
backup_date=$backup_dir/$(date +%Y-%m-%d)

# Create the backup directory based on date if not existed
if [ ! -d "$backup_date" ]; 
then
    mkdir -p $backup_date
    if [ $? -ne 0 ];
    then
        echo "Failed to create the backup directory : $backup_date"
    fi
fi

backup_filename=$backup_date".sql"

# => For taking a specific database backup , Please add only below line for creating backup
mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" "$db_name" > "$backup_filename"

# => For taking all databases as a backup in a single file: Method 1 , Please add only the below line for creating backup
mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" --all-databases > "$backup_filename"

# => For taking all databases as a backup in a single file : Method 2, Please add only the below line for creating backup
mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" --all-databases  --single-transaction --quick --lock-tables=false > "$backup_filename"

# => For taking a seperate backup for each database in a specific directory  , Please add below steps for creating backup

# Step 1: List all databases other than default databases
databaseslist=$(mysql -h "$db_host" -u "$db_user" -p "$db_pass" -e "SHOW DATABASES;" | grep -Ev "Database|information_schema|performance_schema|mysql|sys")

# Step 2: Taking backup of each database
for db in $databaseslist;
do
    backup_filename="$backup_date/backup-${db}.sql"
    mysqldump -h "$db_host" -u "$db_user" -p "$db_pass" "$db" > "$backup_filename"
    if [ $? -ne 0 ]
    then
        echo "Failed to take backup of database"
    else
        echo "Backup is success : $backup_filename"
    fi
done

# Step 3: Retention of the directory for 45 days with backup sql files.
find $backup_date -type d -mtime +45 -delete
