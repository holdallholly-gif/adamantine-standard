# SOP — Adamantine Standard v1.1
**Issued:** 2025-11-03
**Purpose:** Operational steps to produce, certify, and publicly verify a *Certified Record* under the Adamantine Standard.

---

## 0. Preconditions
- Final narrative artifact compiled to **PDF/A-2u** with accessibility checks (WCAG Annex).
- Deterministic build chain recorded (tool versions, commands).
- License chosen (recommended: **CC BY-NC-ND 4.0** for narrative; **MIT/Apache-2.0** for scripts/schemas).

## 1. Compile & Freeze
1. Freeze source (commit/tag).
2. Build the PDF (**PDF/A-2u**).
3. Export *deterministic build log* (`build_log.txt`) incl. OS/tool versions.

## 2. Deposit (DOI minting)
1. Prepare `metadata.json` (creator, keywords, license, notes).
2. Upload to Zenodo (web or API) as **draft**.
3. Confirm metadata + files, then **Publish** to mint DOI.

## 3. Verify the DOI Artifact (byte-for-byte)
1. Download the **published** PDF from DOI landing page.
2. Compute SHA-256 on the downloaded file:

   **macOS/Linux**
   ```bash
   shasum -a 256 Certified_Record_v1.0.pdf | awk '{print $1}'
   ```

   **Windows PowerShell**
   ```powershell
   (Get-FileHash -Algorithm SHA256 Certified_Record_v1.0.pdf).Hash
   ```

3. Record hash + UTC in `repro_log.jsonl` (see template).

## 4. AVE Ledger Registration
Create `ledger_entry.json` (schema v1.1) with fields:
- `doi`, `sha256`, `timestamp_utc`, `registrant`, `standard`
- Optional: `provenance.source`, `build_chain`, `signatures[]`, `links`

Submit via API or registry UI. Retain the **AVE Ledger ID**.

## 5. Close the Loop (Back-Embed)
- Write `ave:ledger_id` and `ave:sha256` and `doi` into PDF XMP metadata.
- In LaTeX: add to `\hypersetup{pdfkeywords=...}`.
- Append a one-paragraph **Verification Note** to the document.

## 6. Publish Verification Note
Include: DOI URL, SHA-256, AVE ID, and verification commands for Mac/Win.

## 7. Compliance Evidence
Artifacts to retain:
- `metadata.json` • `ledger_entry.json` • `repro_log.jsonl` • `build_log.txt` • PDF with XMP fields

## 8. Service Levels & KPIs
- Reproducibility ≥ 99.5% (hash match across environments)
- Time-to-verify ≤ 2 minutes (from download to match)
- Accessibility conformance ≥ 95%

## 9. Exceptions & Incident Response
- If hash mismatch → re-download from DOI, re-verify build, troubleshoot diff, re-publish if necessary.
- If AVE outage → queue signed ledger entries locally and backfill on recovery.

---

**Contact/Owner:** Standard Maintainer (Independent Entrepreneur)
