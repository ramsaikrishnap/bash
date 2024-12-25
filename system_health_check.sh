#!/bin/bash

#################################################################
# Script Name: system_health_check.sh
# Description: Monitor and report key system metrics and service status
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# Created: December 2024
# Version: 1.0
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
#
# Script Functions:
# 1. Checks CPU usage, Memory Usage , Disk Usage , System Load and Service status
#
# Dependencies:
# - top: for CPU usage monitoring
# - free: for memory usage monitoring
# - df: for disk usage monitoring
# - systemctl: for service status checking
# - awk: for data processing
#################################################################

# Function to print formatted section headers
# Usage: print_header "Section Name"
# Creates a visually distinct separation between different sections of the report
print_header() {
    echo "============================================"
    echo "$1"
    echo "============================================"
}

# Initialize report with basic system information
# Captures current timestamp and hostname for report identification
print_header "SYSTEM HEALTH CHECK REPORT"
echo "Generated on: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Hostname: $(hostname)"
echo

# CPU Usage monitoring
# Uses 'top' command in batch mode (-b) for a single iteration (-n 1)
# Displays:
# - CPU utilization percentage (user, system, idle, wait)
# - Total number of tasks and their states
# - Current CPU state
print_header "CPU USAGE"
top -b -n 1 | head -n 5 | tail -n 4

# Memory Usage monitoring
# Uses 'free' command with human-readable (-h) format
# Calculates and displays:
# - Total system memory
# - Used memory
# - Free memory
# - Memory usage as a percentage
print_header "MEMORY USAGE"
free -h | awk '
    /^Mem:/ {
        printf "Total Memory: %s\n", $2
        printf "Used Memory: %s\n", $3
        printf "Free Memory: %s\n", $4
        printf "Memory Usage: %.2f%%\n", $3/$2*100
    }'

# Disk Usage monitoring
# Uses 'df' command with human-readable (-h) format
# Filters and displays:
# - Only filesystems with usage > 70%
# - Helps identify potential disk space issues
print_header "DISK USAGE"
echo "File Systems with usage > 70%:"
df -h | awk '
    NR==1 {print $0; next}
    int($5) > 70 {print $0}'

# System Load monitoring
# Uses 'uptime' command to display:
# - System uptime duration
# - Load averages for 1, 5, and 15 minute intervals
# Helps identify system stress levels over time
print_header "SYSTEM LOAD"
uptime | awk '{
    print "System Uptime:", $3, $4
    print "Load Averages (1/5/15 min):", $(NF-2), $(NF-1), $NF
}'

# Service Status monitoring
# Uses systemctl to check status of critical services
# Monitors:
# - Status of essential services (httpd, mysql)
# - Lists any failed services in the system
print_header "SERVICE STATUS"
# Check critical services
for service in httpd mysql; do
    status=$(systemctl is-active $service 2>/dev/null)
    echo "$service: $status"
done

# Failed services check
# Lists all failed services in the system
# Provides empty message if no failed services found
echo -e "\nFailed Services:"
failed_services=$(systemctl --failed --no-pager)
if [ -z "$failed_services" ]; then
    echo "No failed services found"
else
    echo "$failed_services"
fi


# Finalizes the report with a closing header
print_header "END OF REPORT"

# Sample output comment showing expected format of the report
: '
Sample Output:
This sample output is assumed/acquired from different sources may not match actual report or output
============================================
SYSTEM HEALTH CHECK REPORT
============================================
Generated on: 2024-12-25 10:30:15
Hostname: webserver-prod-01

============================================
CPU USAGE
============================================
%Cpu(s): 25.1 us,  8.3 sy,  0.0 ni, 65.6 id,  1.0 wa
Tasks: 128 total,   1 running, 127 sleeping
%Cpu(s):  5.9 us,  2.1 sy,  0.0 ni, 91.2 id,  0.8 wa

============================================
MEMORY USAGE
============================================
Total Memory: 16.0G
Used Memory: 8.2G
Free Memory: 4.8G
Memory Usage: 51.25%

============================================
DISK USAGE
============================================
File Systems with usage > 70%:
Filesystem      Size  Used  Avail  Use%  Mounted on
/dev/sda1       100G   80G    20G   80%  /
/dev/sdb1       500G  400G   100G   80%  /data

============================================
SYSTEM LOAD
============================================
System Uptime: 45 days
Load Averages (1/5/15 min): 0.85, 0.90, 0.87

============================================
SERVICE STATUS
============================================
httpd: active
mysql: active

Failed Services:
No failed services found
'