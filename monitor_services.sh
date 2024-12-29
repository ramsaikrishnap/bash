#!/bin/bash
#################################################################
# Script Name: monitor_services.sh
# Description: Monitor the status of list of services and restart them if not running
# Author: RAMSAI KRISHNA PRATTIPATI
# Email: ramsaikcp@gmail.com
# Created: December 2024
# Version: 1.1
# GitHub: www.linkedin.com/in/ramsai-krishna-prattipati-50322218b
# LinkedIn: https://github.com/ramsaikrishnap
#
# Script Functions:
# 1. Validates the process mentioned
# 2. Checks whether the process/service is running or not. 
# 3. Logs the service restart with timestamp
# 4. Maintains backup retention period of 45 days
# 5. Sends email notifications for failed services
# 6. Monitors extended list of critical services
#################################################################

# List of processes to monitor
processlist=(
    "httpd"           # Apache web server
    "php-fpm"         # PHP FastCGI Process Manager
    "mysql"           # MySQL Database
    "nginx"           # Nginx web server
    "postgresql"      # PostgreSQL Database
    "mongodb"         # MongoDB Database
    "redis"           # Redis Cache
    "memcached"       # Memcached Cache
    "elasticsearch"   # Elasticsearch Search Engine
    "rabbitmq-server" # RabbitMQ Message Broker
    "docker"          # Docker Container Runtime
    "kubelet"         # Kubernetes Node Agent
    "jenkins"         # Jenkins CI/CD Server
    "prometheus"      # Prometheus Monitoring
    "grafana-server"  # Grafana Dashboard
)

# Configuration
MAIL_RECIPIENT="user@example.com"
RETENTION_DAYS=45
LOG_DIR="/var/log/service-monitor"
SMTP_SERVER="smtp.yourdomain.com"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to check process status
process_status_check() {
    status=$(systemctl is-active "$1" 2>&1 | tr '[:upper:]' '[:lower:]')
    echo "$status"
}

# Process log file creation
log_file="process_status_$(date '+%Y-%m-%d-%H-%M-%S').log"
LOG_PATH="$LOG_DIR/$log_file"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_PATH"
}

# Function to clean old logs
cleanup_old_logs() {
    find "$LOG_DIR" -name "process_status_*.log" -mtime +$RETENTION_DAYS -delete
    log_message "INFO: Cleaned up logs older than $RETENTION_DAYS days"
}

# Function to send email notification
send_notification() {
    local subject="$1"
    local message="$2"
    if command -v mailx >/dev/null 2>&1; then
        echo "$message" | mailx -r "mointor_alerts@example.com" -s "$subject" -S smtp="$SMTP_SERVER" "$MAIL_RECIPIENT"
        log_message "INFO: Email notification sent to $MAIL_RECIPIENT"
    else
        log_message "WARNING: mailx not installed. Email notification skipped"
    fi
}

# Initialize status summary for email
failed_services=""
restarted_services=""

# Main loop for checking processes
for process in "${processlist[@]}"
do
    # Check if the service exists
    if ! systemctl list-unit-files "${process}.service" &>/dev/null; then
        log_message "ERROR: Service ${process}.service does not exist"
        failed_services="${failed_services}- ${process} (service not found)\n"
        continue
    fi

    # Check process status
    status=$(process_status_check "$process")

    if [ "$status" != "active" ]; then
        log_message "WARNING: $process is $status"
        log_message "Attempting to restart $process"
        
        if systemctl restart "$process"; then
            new_status=$(process_status_check "$process")
            if [ "$new_status" = "active" ]; then
                log_message "SUCCESS: $process has been restarted and is now running"
                restarted_services="${restarted_services}- ${process} (successfully restarted)\n"
            else
                log_message "ERROR: Failed to restart $process - final status: $new_status"
                failed_services="${failed_services}- ${process} (failed to restart)\n"
            fi
        else
            log_message "ERROR: Failed to restart $process"
            failed_services="${failed_services}- ${process} (restart command failed)\n"
        fi
    else
        log_message "INFO: $process is running as expected"
    fi
done

# Send email notification if there were any issues
if [ -n "$failed_services" ] || [ -n "$restarted_services" ]; then
    server=$(hostname)
    email_subject="Service Monitor Alert for $server - $(date '+%Y-%m-%d %H:%M:%S')"
    email_body="Service Monitoring Report\n\n"
    
    if [ -n "$failed_services" ]; then
        email_body="${email_body}Failed Services:\n${failed_services}\n"
    fi
    
    if [ -n "$restarted_services" ]; then
        email_body="${email_body}Restarted Services:\n${restarted_services}\n"
    fi
    
    send_notification "$email_subject" "$email_body"
fi

# Cleanup old logs
cleanup_old_logs

# Set appropriate permissions for log file
chmod 644 "$LOG_PATH"

log_message "INFO: Monitoring cycle completed"