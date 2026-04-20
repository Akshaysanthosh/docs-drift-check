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
- Plugin icon, logo, and screenshot assets now exist
- Privacy policy and terms pages now exist
- Support, security, compatibility, and install docs now exist
- Changelog exists
- Issue templates exist
- A PR review workflow example exists
- The plugin tagline and marketplace copy are now tightened

## What is blocked by platform status

- There is no documented self-serve “publish to the official Codex Plugin Directory” flow in the current Codex docs.
- The docs describe the official directory as powered by a curated marketplace.
- Because of that, public marketplace publication is not something you can fully complete unilaterally today from the docs alone.

## What is still pending on your side

These are the items worth finishing so the plugin is “curation-ready” once a formal submission path exists or if OpenAI reviews curated additions manually.

### Product polish

- Add additional screenshots if the plugin grows beyond a single-terminal workflow

### Manifest completeness

- Keep `repository` pointed at the public GitHub repo
- Revisit `capabilities` once the plugin grows beyond read-only drift detection

### Documentation quality

- Keep adding release notes or a changelog entry for each tagged version

### Operational readiness

- Decide whether future versions will include connectors, MCP, or stay skill-only

### Legal and trust

- Keep the MIT license, or switch if you want commercial restrictions later

### Distribution strategy

- Decide whether the plugin remains local-only or grows into a fuller connector-backed plugin
- Decide whether the public repo is the product, or whether it becomes the open-source lead magnet for a paid version
- Collect a few pilot testimonials or concrete “caught drift before merge” examples

## Recommended next publish sequence

1. Keep tagging releases and collecting real validation examples.
2. Collect pilot testimonials or concrete “caught before merge” examples.
3. Decide the product path: local-only plugin or richer connector-backed version.
4. Watch the Codex plugin docs for an official submission or public publishing flow.
5. When that exists, submit this plugin with the current repo, manifest, assets, and validation evidence ready.

## Practical bottom line

You can distribute and use this plugin now through local or curated marketplaces you control.

The only major thing you cannot finish end-to-end today is official self-serve publication into the Codex Plugin Directory, because the public Codex docs do not currently document that workflow.
