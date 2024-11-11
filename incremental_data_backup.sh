#!/bin/bash
# Incremental backup script

BACKUP_DIR="/backup"
SOURCE_DIR="/data"
DATE=$(date +%Y%m%d)

# Create full backup on Sundays, incremental on other days
if [ $(date +%u) -eq 7 ]; then
    tar -czf $BACKUP_DIR/full-$DATE.tar.gz $SOURCE_DIR
else
    # Find latest full backup
    LATEST_FULL=$(ls -t $BACKUP_DIR/full-*.tar.gz | head -n1)
    tar -czf $BACKUP_DIR/incr-$DATE.tar.gz \
        --newer=$LATEST_FULL $SOURCE_DIR
fi

# Cleanup old backups (keep last 30 days)
find $BACKUP_DIR -type f -mtime +30 -delete