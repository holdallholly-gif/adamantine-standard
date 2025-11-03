#!/usr/bin/env bash
# Minimal SHA-256 verifier (bash). Usage:
#   ./verify_sha256.sh <file> [expected_hex]
# Writes a JSON line to repro_log.jsonl in CWD and echoes the hash.
set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 <file> [expected_hex]" >&2
  exit 2
fi
file="$1"
expected="${2-}"
if [ ! -f "$file" ]; then
  echo "ERROR: file not found: $file" >&2
  exit 2
fi

# Compute hash (macOS/Linux)
hash=$(shasum -a 256 "$file" | awk '{print $1}')

# Emit result
echo "$hash"

# Prepare JSON log line
utc=$(date -u +%FT%TZ)
doc=$(basename "$file")
json_line=$(printf '{"doc":"%s","path":"%s","sha256":"%s","expected":"%s","match_expected":%s,"utc":"%s","tool":"verify_sha256.sh","os":"%s"}\n' \
  "$doc" "$(cd "$(dirname "$file")"; pwd)/$doc" "$hash" "${expected,,}" \
  "$( [ -n "${expected:-}" ] && [ "${expected,,}" = "$hash" ] && echo true || ( [ -n "${expected:-}" ] && echo false || echo null ) )" \
  "$utc" "$(uname -a | tr -d '"')")

# Append to log
echo "$json_line" >> repro_log.jsonl

# Exit code: 0 if no expected OR matches; 1 if mismatch
if [ -n "${expected:-}" ] && [ "${expected,,}" != "$hash" ]; then
  exit 1
fi
