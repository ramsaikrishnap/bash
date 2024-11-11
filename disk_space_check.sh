#!/bin/bash

# Below is the script that will check the disk space usage . If the disk space is greater than threshold value it will trigger mail(assuming SMTP enabled).

threshold=90
df -h | awk '{print $5 " " $6}' | while read output;
do
  usage=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usage -ge $threshold ]; then
    echo "Warning: $partition is at $usage%" 
    echo "Warning: $partition is at $usage%" | mail - s "Disk Space Usage" person@example.com # This requires SMTP access to the server for alerts via mail
  fi
done


# Below is the script that will show report of space occupied in each directory
path="/my_working_directory"

# Code to get space occupied in the directory
directory_list=$(ls -l | grep '^d' | awk '{print $NF}')

for dir in $directory_list
do
    switching_path=$path/$dir
    cd $switching_path
    space=$(du -sh | awk -F " " '{print $1}')
   
    echo "Space in $switching_path is $space"
done
