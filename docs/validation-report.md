# Validation Report

This report captures a reproducible validation pass for Docs Drift Check against real public repositories.

To keep the results honest and repeatable, each example uses:

- a shallow clone of a real public repo
- a temporary validation branch
- one intentional docs-sensitive code change
- the bundled helper script from this repository

Re-run the full pass with:

```bash
bash scripts/run_public_validation.sh
```

## Summary

| Repository | Validation scenario | Primary signal | Likely docs to review | Raw output |
| --- | --- | --- | --- | --- |
| `Akshaysanthosh/my-portfolio` | Renamed the main dev script from `npm run dev` to `npm run site:dev` | CLI/config drift | `README.md` getting started commands | [output](validation/my-portfolio.txt) |
| `Akshaysanthosh/Relam-homepage` | Added a new public endpoint at `/api/contact` | Route drift | `README.md`, `spec.md`, API notes | [output](validation/Relam-homepage.txt) |
| `Akshaysanthosh/dara-lab` | Moved Google Analytics to `NEXT_PUBLIC_GA_MEASUREMENT_ID` | Env var drift | `README.md`, setup or deploy docs | [output](validation/dara-lab.txt) |

## Notes

- `my-portfolio` surfaced both `Likely CLI flag changes` and `Likely config changes`, which is the right outcome for a package script rename that makes README commands stale.
- `Relam-homepage` surfaced the new `/api/contact` route directly, which is useful when public behavior changes without matching docs updates.
- `dara-lab` surfaced the new `NEXT_PUBLIC_GA_MEASUREMENT_ID` env var, which is exactly the kind of setup drift teams often miss.

## Takeaway

The current heuristic set is already useful for three common sources of docs drift:

1. changed developer commands
2. added API endpoints
3. new required environment variables

The next step is less about new surface area and more about tuning false positives on larger repos and live pull requests.
