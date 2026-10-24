
#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$HOME/migration/logs/downtime"
REPORT="$DIR/downtime_result.txt"

for MARK in T0 T1 T2 T3 T4; do
  if [[ ! -s "$DIR/$MARK.txt" ]]; then
    echo "ERROR: Missing $MARK"
    exit 1
  fi
done

T0=$(date -u -d "$(cat "$DIR/T0.txt")" +%s)
T1=$(date -u -d "$(cat "$DIR/T1.txt")" +%s)
T2=$(date -u -d "$(cat "$DIR/T2.txt")" +%s)
T3=$(date -u -d "$(cat "$DIR/T3.txt")" +%s)
T4=$(date -u -d "$(cat "$DIR/T4.txt")" +%s)

if ! (( T0 <= T1 && T1 <= T2 && T2 <= T3 && T3 <= T4 )); then
  echo "ERROR: Invalid timestamp order"
  exit 1
fi

{
  echo "BACKUP_PHASE_SECONDS=$((T1-T0))"
  echo "RESTORE_PHASE_SECONDS=$((T2-T1))"
  echo "VALIDATION_SECONDS=$((T3-T2))"
  echo "CUTOVER_CHECK_SECONDS=$((T4-T3))"
  echo "TOTAL_DOWNTIME_SECONDS=$((T4-T0))"
  echo "TOTAL_DOWNTIME_MINUTES=$(( (T4-T0)/60 ))"
  echo "STATUS=PASS"
} | tee "$REPORT"
