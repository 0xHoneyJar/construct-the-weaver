---
name: naming-intents
description: Build the named intent vocabulary for a product — the finite set of "things users try to do" extracted from KEEPER's listening canvases. Prerequisite to composing-paths.
user-invocable: true
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Naming Intents

The language layer. `composing-paths` cannot map an intent to a path until the intent is **named** — given a stable id, a user-vocabulary phrase, a precondition, and a success signal. Naming-intents extracts these from KEEPER's user truth canvases and writes them to `grimoires/{product}/intents.yaml`.

> *naming-is-diagnostic.* (CURATOR doctrine — same lineage applies here. If an intent can't be named in user vocabulary, it isn't a real intent yet.)

## Trigger

```
/weave name-intents
"what intents does this product have?"
"name the intent in this canvas"
```

## When to use

- A new product is being scoped and no intents.yaml exists yet
- KEEPER just produced a listening session output and intents need extraction
- An existing flow references an intent that's not in the vocabulary
- Product has drifted (UI evolved beyond the intent vocabulary) — re-extract from updated canvases

## When NOT to use

- The user wants a UI prototype — that's `prefilling-presets`
- The user wants a mermaid diagram — that's `rendering-mermaid` (after composing-paths)
- The intent vocabulary already exists and you just need to USE it — call `composing-paths` directly

## Workflow

1. Read all KEEPER canvases at `grimoires/{product}/feedback/keeper/*.json`
2. Extract phrases users actually said (Mom Test discipline — what they did, not what they predicted)
3. Cluster by goal-shape (different phrasings of the same underlying intent collapse to one entry)
4. For each cluster, propose: `id` (kebab-case slug), `phrase` (user vocabulary, verbatim where possible), `precondition` (what must be true to start), `success_signal` (the felt-completion moment), `out-of-scope` (related-but-different intents)
5. Write to `grimoires/{product}/intents.yaml`. Mark each entry `status: draft` until KEEPER validates.

## Output shape

```yaml
# grimoires/{product}/intents.yaml
schema_version: 0.1.0
authored_by: the-weaver/naming-intents
intents:
  - id: author-collection
    phrase: "I want to make a generative collection"
    precondition: "I have rough aesthetic intuition; no patience for setup"
    success_signal: "I see something I'd actually share with someone"
    out-of-scope: [author-construct, iterate-variant]
    status: draft
    sources:
      - grimoires/.../feedback/keeper/2026-04-XX-gumi.json
  # ... etc
```

## Anti-patterns

- **System-vocabulary intents.** "Configure layer compositions" is system speak. The user said "make a thing." Use what they said.
- **Single-source intents.** One canvas isn't a pattern. Wait until 2-3 canvases echo the same shape before naming it.
- **Hierarchical decomposition.** Don't break "author a collection" into "upload images / set weights / configure rules." Those are *steps in the flow*, not intents. Intents are user-felt goals.
- **Bundling unrelated phrases.** If the cluster requires hand-waving to feel coherent, it's two intents pretending to be one. Split.

## Composes with

- **Upstream**: observer/level-3-diagnostic (extracts the truth canvases this skill reads)
- **Downstream**: composing-paths (consumes the named intent)
- **Lateral**: prefilling-presets (uses intents as the "intent-based button" set)
