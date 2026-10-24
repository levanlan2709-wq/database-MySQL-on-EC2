python3 - <<'PY'
from pathlib import Path

source = Path.home() / "migration/backups/sakila_w3_test.sql"
target = Path.home() / "migration/backups/sakila_w3_aurora.sql"

data = source.read_bytes()

old = b"DEFINER=`root`@`localhost`"
new = b"DEFINER=CURRENT_USER"

count = data.count(old)

if count == 0:
    raise SystemExit("ERROR: No matching DEFINER found")

updated = data.replace(old, new)
target.write_bytes(updated)

print(f"DEFINER_REPLACED={count}")
print(f"OUTPUT={target}")
print(f"OUTPUT_BYTES={target.stat().st_size}")
PY