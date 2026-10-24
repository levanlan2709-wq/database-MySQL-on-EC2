
#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

DB="sakila_w3_test"
BASE="$HOME/migration"
OUT="$BASE/logs/aurora_validation.csv"
LOG="$BASE/logs/check_aurora.log"
TMP="${OUT}.tmp"

mkdir -p "$BASE/logs"

trap 'rm -f "$TMP"' EXIT

echo "START=$(date -u -Is)" > "$LOG"
echo "DATABASE=$DB" >> "$LOG"
echo "table_name,row_count" > "$TMP"

# Lấy danh sách bảng thật, không tính VIEW.
TABLE_LIST=$(mysql --login-path=migration_aurora \
  --protocol=TCP \
  --ssl-mode=REQUIRED \
  --batch --skip-column-names \
  -e "
SELECT TABLE_NAME
FROM information_schema.tables
WHERE TABLE_SCHEMA='$DB'
AND TABLE_TYPE='BASE TABLE'
ORDER BY TABLE_NAME;
")

if [[ -z "$TABLE_LIST" ]]; then
  echo "STATUS=FAILED: No tables found" | tee -a "$LOG"
  exit 1
fi

TABLE_COUNT=0

while IFS= read -r TABLE; do
  [[ -z "$TABLE" ]] && continue

  ROW_COUNT=$(mysql --login-path=migration_aurora \
    --protocol=TCP \
    --ssl-mode=REQUIRED \
    --batch --skip-column-names \
    -e "SELECT COUNT(*) FROM \`$DB\`.\`$TABLE\`;")

  echo "$TABLE,$ROW_COUNT" >> "$TMP"
  TABLE_COUNT=$((TABLE_COUNT + 1))
done <<< "$TABLE_LIST"

echo "TABLE_COUNT=$TABLE_COUNT" | tee -a "$LOG"

if [[ "$TABLE_COUNT" -ne 16 ]]; then
  echo "STATUS=FAILED: Expected 16 tables" | tee -a "$LOG"
  exit 1
fi

mv "$TMP" "$OUT"

echo "CSV=$OUT" | tee -a "$LOG"
echo "END=$(date -u -Is)" | tee -a "$LOG"
echo "STATUS=SUCCESS" | tee -a "$LOG"

cat "$OUT"
