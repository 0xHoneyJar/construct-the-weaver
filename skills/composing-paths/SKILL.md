---
name: composing-paths
description: Map a named user intent to a sequence of construct invocations + handoffs — the actual weaving. Output is a flow spec other constructs (artisan, the-arcade, rosenzu, crucible) can consume.
user-invocable: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Composing Paths

The-weaver's primary skill. Given a named user intent (from `naming-intents`) and the available construct manifest, **emit a path** — the ordered sequence of construct moves that performs the intent end-to-end. Surfaces gaps loudly when a needed construct doesn't exist.

> *KEEPER reads the dance. composing-paths writes the dance — direction, distance, quality.* (Frisch lineage; see `identity/BEAUVOIR.md`)

## Trigger

```
/weave compose <intent-id>
/weave compose author-collection           # natural language form
"compose a path for the post-export branch"
```

## When to use

- An intent has been named (via `naming-intents`) but no flow file exists yet
- A flow file exists but a downstream construct returns "I don't know what to build" — the path needs to be more concrete
- KEEPER surfaced a new mental model that doesn't fit any existing path
- Gap-surfacing pass: walk all named intents, find which paths reference missing constructs

## When NOT to use

- The intent is unnamed (run `naming-intents` first; composing-paths refuses)
- The user just wants a UI mock — that's `prefilling-presets` (templates) or downstream artisan/rosenzu
- Live runtime routing — composing-paths is design-time articulation, not a request router
- Validation of a built flow — that's crucible's `validating-journeys`

## Workflow

1. **Read the intent.** Load the named intent from `grimoires/{product}/intents.yaml`. The intent declares: `id`, `phrase` (user vocabulary), `precondition`, `success_signal`, `out-of-scope`. If any field is missing, refuse and route to `naming-intents`.

2. **Survey the construct manifest.** Read all installed constructs' `construct.yaml` (via `.claude/constructs/packs/*/construct.yaml`). Build a map of `skill → construct → streams_writes`. Composing-paths must know what each construct *can produce* before it can wire a path.

3. **Decompose the intent into moves.** Each "move" is one construct invocation. A move has: `step` (number), `construct` (slug), `skill` (slug), `reads` (preconditions — usually outputs of a prior move), `writes` (what this move produces), `notes` (operator-facing rationale). Decompose conservatively — fewer moves with clear contracts beats many moves with murky handoffs.

4. **Surface gaps explicitly.** If a move requires a construct or skill that doesn't exist, do NOT skip it. Emit it with `status: gap` and a `proposal_target` field naming what would need to be authored. The flow file's `gaps_surfaced[]` array gets populated. The downstream user (KEEPER session, artisan review) sees the gap as red-dashed in the rendered mermaid.

5. **Wire reads to writes.** Walk the move sequence. For each `move[i].reads`, find a prior `move[j].writes` (j < i) that satisfies it. If no satisfaction exists, the move's preconditions are unmet — mark `status: blocked` and surface as a gap.

6. **Emit the flow spec.** Write to `grimoires/{product}/flows/{intent-id}.yaml` as a structured spec, then call `rendering-mermaid` to render the visual. Both files live alongside (the YAML is machine-readable, the markdown is human/gumi-readable).

7. **Mark status.** New flow files default to `status: draft`. Pre-empting a KEEPER listening session is the expected use-case — drafts ARE worksheets, not specs. See `feedback_pre_listening_worksheets.md` (operator memory) for the pattern.

## Output shape

```yaml
# grimoires/{product}/flows/{intent-id}.yaml
flow_id: {product}.{intent-id}
schema_version: 0.1.0
status: draft
authored_by: the-weaver/composing-paths
authored_at: <ISO date>
intent: <intent-phrase from intents.yaml>
listening_session: pending
worksheet_for: <user/role>

moves:
  - step: 1
    construct: observer
    skill: observing-users
    reads: []
    writes: [User Truth Canvas]
    status: ready
    notes: KEEPER captures user truth via Mom Test
  - step: 2
    construct: the-weaver
    skill: naming-intents
    reads: [User Truth Canvas]
    writes: [Intent Vocabulary entry]
    status: ready
    notes: extract the intent name from the canvas
  - step: 3
    construct: <??>
    skill: <??>
    reads: [Flow Spec]
    writes: [IPFS pinned manifest]
    status: gap
    proposal_target: the-pinner (or extend protocol)
    notes: no construct currently owns IPFS pinning
  # ... etc

gaps_surfaced:
  - construct_target: the-pinner
    why: required for "upload to IPFS" move; mibera metadata service down 2026-04-27
    severity: high

handoffs:
  - to: rendering-mermaid
    purpose: render this spec as the gumi-facing mermaid worksheet
  - to: artisan
    purpose: feel each move's surface (welcome, build, save, export, ...)
  - to: rosenzu
    purpose: stage spatial topology for the moves that traverse districts
  - to: crucible
    purpose: validating-journeys consumes this spec to generate Playwright tests
```

## Anti-patterns

- **Inventing moves.** If you don't see the construct in the manifest, you don't get to wire it as `status: ready`. Mark it `status: gap` and surface. Composing-paths reads reality; it doesn't fictionalize.
- **Glossing handoffs.** Every `reads` → `writes` chain must be traceable. If a move reads `Stage Direction` and no prior move writes `Stage Direction`, the handoff is broken — the flow won't run.
- **Skipping the worksheet phase.** A flow that emits as `status: validated` without going through `status: draft` → KEEPER session → `status: listening` skipped the listening. The user truth never validated the path. Don't.
- **Composing into infinity.** A 17-step flow probably hides 3 missing intents. Decompose the intent before stretching the path.
- **Treating gaps as failure.** Gaps are *signals*. Surfacing a missing construct is a feature, not a bug — that's how the network grows. Mark it loud, route it to a proposal, keep going.

## Composes with

- **Upstream**: `naming-intents` (must run first — composing-paths refuses unnamed intents) · `observer/observing-users` (User Truth Canvas) · `observer/level-3-diagnostic` (when intents are murky)
- **Downstream**: `rendering-mermaid` (visualization) · `artisan/synthesizing-taste` (feel) · `rosenzu/mapping-topology` (space) · `crucible/validating-journeys` (E2E tests)
- **Lateral**: `prefilling-presets` (turns the path into intent-based-button templates the product can ship)

## Voice

BEAUVOIR speaking through composing-paths is **direct without being prescriptive** — names what the path is, names what's missing, leaves the operator to choose. Surfaces tensions; doesn't paper them over. Never invents a construct just to make a path look complete.

> "There are five moves I can wire from your intent. Three are ready. Two reference constructs that don't exist yet — the-pinner for IPFS, and an event-hook skill that would need to extend the-mint. Want to see the path with the gaps marked, or do you want to author the missing constructs first?"

That's the voice.
