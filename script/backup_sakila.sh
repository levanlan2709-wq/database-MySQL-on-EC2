
#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

BASE="$HOME/migration"
BACKUP_DIR="$BASE/backups"
LOG_DIR="$BASE/logs"
DB="sakila"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)
BACKUP_FILE="$BACKUP_DIR/${DB}_${TIMESTAMP}.sql"
LOG_FILE="$LOG_DIR/backup_${TIMESTAMP}.log"

START=$(date +%s)

echo "START=$(date -u -Is)" | tee "$LOG_FILE"
echo "DATABASE=$DB" | tee -a "$LOG_FILE"

# Kiểm tra kết nối MySQL nguồn
mysql --login-path=migration_source \
    -e "SELECT 1;" >/dev/null

# Sao lưu database Sakila
if mysqldump \
    --login-path=migration_source \
    --single-transaction \
    --quick \
    --routines \
    --triggers \
    --events \
    --no-tablespaces \
    --set-gtid-purged=OFF \
    --column-statistics=0 \
    --databases "$DB" > "$BACKUP_FILE" 2>>"$LOG_FILE"; then

    if [[ ! -s "$BACKUP_FILE" ]]; then
        echo "STATUS=FAILED: Empty backup" | tee -a "$LOG_FILE"
        exit 1
    fi

    END=$(date +%s)

    echo "BACKUP_FILE=$BACKUP_FILE" | tee -a "$LOG_FILE"
    echo "BACKUP_SECONDS=$((END-START))" | tee -a "$LOG_FILE"
    echo "BACKUP_BYTES=$(stat -c%s "$BACKUP_FILE")" | tee -a "$LOG_FILE"

    sha256sum "$BACKUP_FILE" \
        > "${BACKUP_FILE}.sha256"

    echo "STATUS=SUCCESS" | tee -a "$LOG_FILE"
else
    echo "STATUS=FAILED" | tee -a "$LOG_FILE"
    exit 1
fi
