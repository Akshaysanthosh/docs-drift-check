# What Counts as Docs Drift

Docs Drift Check is intentionally opinionated about what should count as likely documentation drift.

## High-signal cases

- new required environment variables
- renamed or removed developer commands
- added or changed public API routes
- changed config keys or deployment routes
- renamed files or modules that docs reference directly
- setup or onboarding steps that no longer match the code

## Lower-signal cases

- formatting-only changes
- internal refactors with unchanged public behavior
- test-only changes
- copy tweaks or styling changes with no effect on setup or usage

## False positives to expect

- config changes that are internal and never mentioned in docs
- route-like strings that are not actually public endpoints
- package script changes that do not affect the documented workflow

## Best practice

Treat the tool as a drift detector, not a final judge.

The right workflow is:

1. run the helper
2. inspect the highlighted signals
3. review the likely impacted docs files
4. decide whether the change is possible drift or confirmed drift
