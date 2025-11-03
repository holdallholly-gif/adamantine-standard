#!/usr/bin/env python3

import argparse, hashlib, json, os, sys, datetime, platform

def sha256_file(path, chunk_size=1024*1024):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()

def main():
    p = argparse.ArgumentParser(description="Compute SHA-256 of a file and optionally compare to an expected value or an AVE ledger_entry.json.")
    p.add_argument("file", help="Path to the file to hash")
    p.add_argument("--expected", help="Expected SHA-256 hex to compare against")
    p.add_argument("--ledger", help="Path to ledger_entry.json containing a 'sha256' field to compare against")
    p.add_argument("--log", default="repro_log.jsonl", help="Path to append JSON line log (default: repro_log.jsonl). Use '-' to disable logging.")
    p.add_argument("--output", choices=["json","text"], default="json", help="Output format (default: json)")
    args = p.parse_args()

    try:
        digest = sha256_file(args.file)
    except FileNotFoundError:
        print("ERROR: file not found: {}".format(args.file), file=sys.stderr)
        sys.exit(2)

    ledger_sha = None
    match_ledger = None
    if args.ledger:
        try:
            with open(args.ledger, "r", encoding="utf-8") as f:
                data = json.load(f)
            ledger_sha = (data.get("sha256") or "").lower()
            match_ledger = (ledger_sha == digest)
        except Exception as e:
            print("ERROR: failed to read ledger file: {}".format(e), file=sys.stderr)
            sys.exit(3)

    expected = (args.expected or "").lower() if args.expected else None
    match_expected = None if expected is None else (expected == digest)

    record = {
        "doc": os.path.basename(args.file),
        "path": os.path.abspath(args.file),
        "sha256": digest,
        "expected": expected,
        "match_expected": match_expected,
        "ledger_sha256": ledger_sha,
        "match_ledger": match_ledger,
        "utc": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "tool": "verify_sha256.py",
        "python": platform.python_version(),
        "os": platform.platform()
    }

    # Output
    if args.output == "json":
        print(json.dumps(record))
    else:
        line = f"{record['doc']}: {record['sha256']}"
        if match_expected is not None:
            line += f"  [expected {'OK' if match_expected else 'MISMATCH'}]"
        if match_ledger is not None:
            line += f"  [ledger {'OK' if match_ledger else 'MISMATCH'}]"
        print(line)

    # Log
    if args.log != "-":
        try:
            with open(args.log, "a", encoding="utf-8") as f:
                f.write(json.dumps(record) + "\n")
        except Exception as e:
            print(f"WARNING: failed to write log: {e}", file=sys.stderr)

    # Exit code policy:
    # 0 if no expectations provided OR all provided comparisons match
    # 1 if any provided comparison mismatches
    # 2..3 for file/ledger read errors above
    code = 0
    for flag in (match_expected, match_ledger):
        if flag is False:
            code = 1
    sys.exit(code)

if __name__ == "__main__":
    main()
