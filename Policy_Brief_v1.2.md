# Policy Brief — Public, Self-Verifying Records with the Adamantine Standard (v1.2)

**Updated:** 2025-11-03

**Problem.** Opaque publication practices and unverifiable official records undermine public trust and slow oversight.

**Solution.** Treat official outputs as **self-authenticating proof objects**. Each certified record is DOI-anchored, cryptographically hashed, recorded in an AVE ledger, and continuously re-verified in public via GitHub Pages.

**Live Audit Trail.** Visit the live dashboard (replace placeholder): **<YOUR_PAGES_URL>**. Each commit appends a signed JSON line to the log and redeploys the dashboard, creating a tamper-evident public trail.

## How It Works
1. **Publish:** Produce PDF/A-2u artifact; mint DOI.
2. **Hash:** Compute SHA-256 on the DOI-downloaded artifact.
3. **Register:** Write `ledger_entry.json` and register in AVE.
4. **Back-Embed:** Insert `ave:ledger_id`, `sha256`, and `doi` into XMP metadata.
5. **Verify (CI):** On each push/PR, the repository verifies the artifact, signs the `repro_log.jsonl` (Sigstore keyless), commits the update, and re-deploys the dashboard.

## Why It Matters (Public Value)
- **Integrity:** Anyone can independently re-verify integrity in minutes.
- **Speed:** Automated, continuous verification—no backlogs.
- **Accountability:** Creates constructive notice and an immutable audit trail.
- **Interoperable:** Aligns with PDF/A-2u, W3C PROV-O, and eIDAS 2.0 concepts.

## Adoption Pathway
- Start with a 10–20 document pilot.
- Use the provided SOP v1.1, Makefile, and CI workflows.
- Display the dashboard link prominently on the agency site and in each Certified Record’s Verification Note.

**Contact:** (Name / Email)
