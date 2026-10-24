
#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

BASE="$HOME/migration"
SOURCE="$BASE/logs/source_validation.csv"
AURORA="$BASE/logs/aurora_validation.csv"
REPORT="$BASE/logs/data_comparison.csv"
LOG="$BASE/logs/data_comparison.log"

mkdir -p "$BASE/logs"

python3 - "$SOURCE" "$AURORA" "$REPORT" "$LOG" <<'PY'
import csv
import sys
from pathlib import Path
from datetime import datetime, timezone

source, aurora, report, log = map(Path, sys.argv[1:])

def load_csv(path):
    if not path.is_file():
        raise ValueError(f"Missing file: {path}")

    result = {}
    with path.open(newline="", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        if reader.fieldnames != ["table_name", "row_count"]:
            raise ValueError(f"Invalid CSV header: {path}")

        for row in reader:
            name = row["table_name"].strip()
            count = int(row["row_count"].strip())

            if not name or name in result or count < 0:
                raise ValueError(f"Invalid or duplicate table: {name}")
            result[name] = count
    return result

try:
    src = load_csv(source)
    dst = load_csv(aurora)

    rows = []
    matched = 0

    for name in sorted(set(src) | set(dst)):
        a = src.get(name)
        b = dst.get(name)

        status = "PASS" if a is not None and a == b else "FAIL"
        if status == "PASS":
            matched += 1

        rows.append([name, a if a is not None else "",
                     b if b is not None else "", status])

    with report.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["table_name", "source_count",
                         "aurora_count", "status"])
        writer.writerows(rows)

    passed = (len(src) == 16 and len(dst) == 16
              and len(rows) == 16 and matched == 16)

    summary = [
        f"TIME={datetime.now(timezone.utc).isoformat()}",
        f"SOURCE_TABLES={len(src)}",
        f"AURORA_TABLES={len(dst)}",
        f"MATCHED_TABLES={matched}",
        f"TOTAL_TABLES={len(rows)}",
        f"ROW_COUNT_VALIDATION={'PASS' if passed else 'FAIL'}",
        f"REPORT={report}",
    ]

    log.write_text("\n".join(summary) + "\n", encoding="utf-8")
    print("\n".join(summary))
    sys.exit(0 if passed else 1)

except (ValueError, OSError) as exc:
    message = f"ROW_COUNT_VALIDATION=ERROR\nDETAIL={exc}\n"
    log.write_text(message, encoding="utf-8")
    print(message, file=sys.stderr)
    sys.exit(2)
PY
