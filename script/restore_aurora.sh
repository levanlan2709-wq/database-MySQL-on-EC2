
#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

DB="sakila_w3_test"
FILE="${1:-}"
LOG="$HOME/migration/logs/restore_aurora.log"

mkdir -p "$(dirname "$LOG")"

if [[ -z "$FILE" || ! -s "$FILE" ]]; then
  echo "ERROR: Backup file missing"
  exit 1
fi

# Chặn dump có lệnh chuyển database.
if grep -Eiq '^[[:space:]]*(CREATE DATABASE|USE[[:space:]])' "$FILE"; then
  echo "ERROR: Dump contains database selection statements"
  exit 1
fi

# Kiểm tra database thử tồn tại và chưa có đối tượng.
OBJECTS=$(mysql --login-path=migration_aurora \
  --protocol=TCP --ssl-mode=REQUIRED \
  --batch --skip-column-names \
  -e "
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema='$DB';")

if [[ "$OBJECTS" != "0" ]]; then
  echo "ABORT: Test database is not empty"
  exit 1
fi

START=$(date +%s)
echo "START=$(date -u -Is)" | tee "$LOG"

if mysql --login-path=migration_aurora \
  --protocol=TCP --ssl-mode=REQUIRED \
  --database="$DB" < "$FILE" 2>>"$LOG"; then
  END=$(date +%s)
  echo "RESTORE_SECONDS=$((END-START))" | tee -a "$LOG"
  echo "STATUS=SUCCESS" | tee -a "$LOG"
else
  echo "STATUS=FAILED" | tee -a "$LOG"
  exit 1
fi
