#!/bin/bash

BACKUP_DIR="/home/ubuntu/Booking-infrastructure/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_USER="booking_admin"
DB_PASSWORD="Spartak999!!!!"
CONTAINER="booking_postgres"
KEEP_DAYS=7

DATABASES=(
    "booking_db"
    "booking_translations"
    "booking_locations"
    "booking_attractions"
    "booking_rentobjects"
    "booking_reviews"
    "booking_statistics"
)

echo "[$DATE] Starting backup..."

for DB in "${DATABASES[@]}"; do
    FILE="$BACKUP_DIR/${DB}_${DATE}.sql.gz"
    docker exec $CONTAINER pg_dump -U $DB_USER $DB | gzip > $FILE
    if [ $? -eq 0 ]; then
        echo "[$DATE] ✅ $DB backed up: $FILE"
    else
        echo "[$DATE] ❌ Failed: $DB"
    fi
done

# Удаляем старые бэкапы
find $BACKUP_DIR -name "*.sql.gz" -mtime +$KEEP_DAYS -delete
echo "[$DATE] Old backups cleaned"
echo "[$DATE] Backup completed!"
