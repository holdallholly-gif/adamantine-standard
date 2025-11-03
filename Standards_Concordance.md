# Standards Concordance Matrix

| Requirement | Adamantine Control | External Standard | Coverage | Gap/Action |
|---|---|---|---|---|
| Authenticity | SHA-256 + AVE entry | eIDAS trust services | Strong | Optional qualified e-seal track |
| Persistence | DOI registration | Datacite/DOI | Strong | Ensure metadata mirrors ledger fields |
| Provenance | Ledger fields + links | W3C PROV-O | Strong | Add `prov:wasGeneratedBy` mapping |
| Format | PDF/A-2u | ISO 19005 | Full | Periodic tool validation |
| Timestamp | UTC in ledger | RFC 3339 | Full | Consider TSA integration |
| Reproducibility | Deterministic build log | Open Science norms | Strong | Provide container images |
