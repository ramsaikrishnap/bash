#!/bin/bash
# System health check script

echo "=== System Health Check ==="
date

# CPU Usage
echo -e "\nCPU Usage:"
top -b -n 1 | head -n 5

# Memory Usage
echo -e "\nMemory Usage:"
free -h

# Disk Usage
echo -e "\nDisk Usage:"
df -h

# Load Average
echo -e "\nLoad Average:"
uptime

# Check System Services
echo -e "\nCritical Services Status:"
systemctl status nginx mysql ssh --no-pager

# Check for Failed System Services
echo -e "\nFailed Services:"
systemctl --failed

# Recent Security Events
echo -e "\nRecent Auth Logs:"
tail -n 10 /var/log/auth.log
