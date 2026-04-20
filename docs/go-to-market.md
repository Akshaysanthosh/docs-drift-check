# Go-To-Market Plan

## Positioning

Docs Drift Check is a lightweight guardrail for engineering teams that ship code faster than they update docs. It acts like a focused documentation lint pass for PRs and branches, highlighting likely stale README, setup, API, and configuration guidance before changes land.

## Ideal customers

- Developer tools teams with public docs or examples
- SaaS teams with frequent setup, env var, or API changes
- Small engineering orgs without dedicated docs review in every PR
- Agencies or consultancies handing repos to clients

## Early wedge

Start with teams that already feel docs pain:

- recurring onboarding issues
- support tickets caused by stale setup steps
- SDK or API changes that miss docs updates
- release managers doing manual README checks before ship

## Pricing idea

Use a simple ladder early:

- Free: open-source repo-local skill for individual use
- Pilot: $1,500 for a two-week rollout on one repo, including heuristic tuning and feedback review
- Team license: $250 per repo per month or $2,400 annually
- Services upsell: custom rule tuning, CI integration, and repo-specific patterns

The point of the pilot is learning, not maximizing revenue in week one.

## Pilot offer

Offer a narrow first engagement:

1. Install Docs Drift Check in one active engineering repo.
2. Review 10 to 20 real PRs over two weeks.
3. Track true positives, false positives, and missed cases.
4. Tune the heuristics once per week.
5. End with a short summary of caught drift and recommended next rules.

## Sales motion

Lead with a simple promise:

`Catch stale docs before the PR merges.`

Good outreach angles:

- teams with active changelogs or public docs repos
- founders doing technical support themselves
- engineering managers who care about onboarding friction
- open-source maintainers with frequent contributor setup issues

## Validation milestones

You should look for these signals before investing in a bigger product:

- At least 3 teams run the tool on real PRs
- At least 1 team pays for a pilot
- The tool catches drift that would otherwise have shipped
- False positives are low enough that reviewers still trust it

## Near-term roadmap

- Add repo-specific ignore rules
- Add language-aware config and routing heuristics
- Add CI output formatting for PR comments or summary files
- Add a premium package with custom rules and team onboarding
