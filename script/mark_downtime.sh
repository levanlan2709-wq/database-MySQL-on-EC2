
#!/usr/bin/env bash
set -Eeuo pipefail

MARK="${1:-}"
DIR="$HOME/migration/logs/downtime"

case "$MARK" in
  T0|T1|T2|T3|T4) ;;
  *)
    echo "Usage: $0 T0|T1|T2|T3|T4" >&2
    exit 1
    ;;
esac

mkdir -p "$DIR"

FILE="$DIR/$MARK.txt"

if [[ -e "$FILE" ]]; then
  echo "ERROR: $MARK already recorded"
  exit 1
fi

date -u +"%Y-%m-%dT%H:%M:%SZ" > "$FILE"

echo "$MARK=$(cat "$FILE")"
