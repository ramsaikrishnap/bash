#!/bin/bash

# The below command in this script will help you move any type of file into a destination path.

path="/source_directory"
external_dir_path="/external_directory"
retention_period=45 # in days
file_type="*.log" # type of file

# Command to get list of files which have crossed retention period
find $path -type f -mtime +$retention_period

# Command to delete all file  in the directory which have cross retention period
find $path -type f -mtime +$retention_period -delete 

# Command to get the detailed information of the files which have crossed retention period
find $path -type f -mtime +$retention_period -exec ls -l {} \;

# Command to move all the files from source directory to destination directory which have crossed retention period
find $path -type f -mtime +$retention_period -exec mv {} $external_dir_path \;

# Command to move all the directories in source directory to destination directory which have crossed retention period
find $path -type d -mtime +$retention_period -exec mv {} $external_dir_path \;

# Below are same examples as above but with a specific file type. 
find $path -type f -name "$file_type" -mtime +$retention_period 
find $path -type f -name "$file_type" -mtime +$retention_period -delete 
find $path -type f -name "$file_type" -mtime +$retention_period -exec ls -l {} \;
find $path -type f -name "$file_type" -mtime +$retention_period -exec mv {} $external_dir_path \;

