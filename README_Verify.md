# Verification Note (Public-Facing)

**How to Verify:** Download the document from its DOI, compute the SHA‑256, and confirm it matches the value published in the AVE ledger entry.

**macOS/Linux**
```bash
shasum -a 256 file.pdf | awk '{print $1}'
```

**Windows**
```powershell
(Get-FileHash -Algorithm SHA256 file.pdf).Hash
```

**Match?** If the displayed hash equals the ledger’s `sha256` value, the document is authentic and unaltered.

---

## CI Status Badge (add to your main README)

```
![Adamantine Verify](https://github.com/<YOUR_ORG>/<YOUR_REPO>/actions/workflows/verify.yml/badge.svg)
```
Replace `<YOUR_ORG>/<YOUR_REPO>` with your repository path.
