# Minimal CLI Verifier Scripts

## Python
```
python3 tools/verify_sha256.py path/to/file.pdf --expected HEX --ledger ledger_entry.json --output json
```
Exit code is 0 when expectations (if any) match; 1 on mismatch; 2–3 on IO errors. Appends a JSON line to `repro_log.jsonl` by default.

## Bash
```
bash tools/verify_sha256.sh path/to/file.pdf [EXPECTED_HEX]
```
Prints the hash and appends a JSON line to `repro_log.jsonl`. Exit code 0 if match/no expected; 1 on mismatch. ---

### 🌐 Live Verification Dashboard
[🔗 View Dashboard](https://holdallholly-gif.github.io/adamantine-standard/)  
*(Automatically updates when verification workflows complete.)*
