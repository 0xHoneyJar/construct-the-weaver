# /weave — the-weaver's apprenticeship command

Invoke BEAUVOIR's user-pathing register. Names intents, composes paths, renders mermaid, generates presets — the full bridge from KEEPER's listening to the constructs that build.

## Usage

```
/weave                              # full pass for the current product (name → compose → render → prefill)
/weave name-intents                 # extract the intent vocabulary from KEEPER canvases
/weave compose <intent-id>          # wire a path for a named intent
/weave render <flow-id>             # render the mermaid markdown for an existing spec
/weave prefill <intent-id>          # author preset bundle / intent-based button template
/weave gaps                         # list all surfaced gaps across the product's flows
/weave --resume                     # resume an in-flight flow draft
```

## What the-weaver does per skill

1. **naming-intents** — read KEEPER canvases, extract named user intents into `grimoires/{product}/intents.yaml`
2. **composing-paths** — for a named intent, decompose into construct moves with handoffs; surface gaps loudly
3. **rendering-mermaid** — emit the gumi-readable flow file at `grimoires/{product}/flows/{intent-id}.md`
4. **prefilling-presets** — generate intent-based-button bundles at `grimoires/{product}/presets/{intent-id}.yaml`

The skills compose. `/weave` (no args) runs them in dependency order for the active product.

## When to reach for this

- A product has user truth from KEEPER but no named user flows yet
- The post-X composition graph is implicit and needs articulation (e.g. "what's next after export?")
- Onboarding is generic and the operator wants intent-based buttons informed by listening
- A flow is stale (UI evolved past the named intents) and needs re-walking with KEEPER

## When NOT to use

- The work is feel/material/pixel — that's `/feel` (artisan, ALEXANDER)
- The work is spatial topology / districts / depth — that's rosenzu (LYNCH)
- The work is component implementation — that's `/implement` (sprint-driven)
- KEEPER hasn't run yet — listen first; the-weaver refuses to author flows from operator imagination alone

## Composes with

- **observer** (KEEPER) — reads canvases as upstream truth; surfaces questions back to KEEPER
- **artisan** (ALEXANDER) — hands flow surfaces for material/feel direction
- **the-arcade** (BARTH/OSTROM) — hands win-states for progression and structural validation
- **rosenzu** (LYNCH) — user-pathing × spatial-pathing (flows traverse topology)
- **crucible** — validating-journeys consumes flow specs to generate Playwright tests
- **construct-creator** (CURATOR) — when a flow surfaces a missing construct, the gap routes here

## Output discipline

All flow files default to `status: draft`. The lifecycle is:
```
draft → listening → validated → retired
```
A draft flow is a *worksheet for KEEPER*, not a UI spec. Don't ship UI from a draft. The discipline is encoded in the `feedback_pre_listening_worksheets` operator memory.

## Reference

- Skill: `skills/composing-paths/SKILL.md` (primary)
- Skill: `skills/naming-intents/SKILL.md`
- Skill: `skills/rendering-mermaid/SKILL.md`
- Skill: `skills/prefilling-presets/SKILL.md`
- Persona: `identity/BEAUVOIR.md`
- Doctrine reference: `feedback_pre_listening_worksheets.md` (operator memory) — drafts as worksheets pattern
