# Codex Marketplace Publish Checklist

As of April 20, 2026, there are two separate realities:

1. You can distribute a Codex plugin today through a repo marketplace or personal marketplace.
2. The official Codex Plugin Directory is documented as a curated marketplace surface, and the Codex docs do not currently document a self-serve public submission flow.

Official references:

- Codex plugin overview: https://developers.openai.com/codex/plugins
- Build plugins: https://developers.openai.com/codex/plugins/build

## What is already done

- Public GitHub repo exists
- Plugin manifest exists at `plugins/docs-drift-check/.codex-plugin/plugin.json`
- Repo marketplace exists at `.agents/plugins/marketplace.json`
- Local plugin install path works
- Versioned plugin is already at `0.1.0`
- Public validation examples and smoke tests exist

## What is blocked by platform status

- There is no documented self-serve “publish to the official Codex Plugin Directory” flow in the current Codex docs.
- The docs describe the official directory as powered by a curated marketplace.
- Because of that, public marketplace publication is not something you can fully complete unilaterally today from the docs alone.

## What is still pending on your side

These are the items worth finishing so the plugin is “curation-ready” once a formal submission path exists or if OpenAI reviews curated additions manually.

### Product polish

- Add a small plugin icon and logo under `plugins/docs-drift-check/assets/`
- Add at least 1 screenshot of the plugin in use
- Tighten the short and long descriptions for marketplace browsing
- Decide the canonical plugin tagline and positioning

### Manifest completeness

- Add `author.email` in `plugin.json`
- Add explicit `homepage` and keep it stable
- Keep `repository` pointed at the public GitHub repo
- Add `privacyPolicyURL`
- Add `termsOfServiceURL`
- Add `composerIcon`, `logo`, and `screenshots` paths after assets exist
- Revisit `capabilities` once the plugin grows beyond read-only drift detection

### Documentation quality

- Add a dedicated install section specifically for Codex users
- Add a “what counts as docs drift” section with false-positive caveats
- Add one example showing how to use the plugin in a real PR review workflow
- Add release notes or a changelog entry for each tagged version

### Operational readiness

- Decide how you want to handle support or bug reports
- Decide whether you want an issue template and a security contact path
- Add a simple compatibility statement for the Codex app, CLI, and IDE flows you support
- Decide whether future versions will include connectors, MCP, or stay skill-only

### Legal and trust

- Keep the MIT license, or switch if you want commercial restrictions later
- Write a short privacy policy if you want marketplace-grade legal completeness
- Write basic terms if you plan to sell support, hosted features, or paid add-ons

### Distribution strategy

- Decide whether the plugin remains local-only or grows into a fuller connector-backed plugin
- Decide whether the public repo is the product, or whether it becomes the open-source lead magnet for a paid version
- Collect a few pilot testimonials or concrete “caught drift before merge” examples

## Recommended next publish sequence

1. Finish icon, logo, and 1 screenshot.
2. Fill the remaining manifest fields.
3. Add a privacy policy and terms page.
4. Keep tagging releases and collecting real validation examples.
5. Watch the Codex plugin docs for an official submission or public publishing flow.
6. When that exists, submit this plugin with the current repo, manifest, assets, and validation evidence ready.

## Practical bottom line

You can distribute and use this plugin now through local or curated marketplaces you control.

The only major thing you cannot finish end-to-end today is official self-serve publication into the Codex Plugin Directory, because the public Codex docs do not currently document that workflow.
