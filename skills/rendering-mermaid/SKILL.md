---
name: rendering-mermaid
description: Render a flow spec as a mermaid diagram in a markdown file. The visible output — what gumi imports into Excalidraw and shares.
user-invocable: true
allowed-tools: Read, Write, Edit
---

# Rendering Mermaid

The output emitter. Takes a structured flow spec from `composing-paths` and renders the human-facing markdown file with a mermaid diagram, worksheet annotations, and gap callouts colored loudly.

## Trigger

```
/weave render <flow-id>
"render the flow as mermaid"
"make me an excalidraw-ready diagram"
```

## When to use

- composing-paths emitted a flow spec (`*.yaml`) and the markdown render is missing
- The spec changed (new moves, new gaps) and the rendered diagram is stale
- Operator wants to share a flow with someone outside the construct system (gumi, designer, stakeholder) — the markdown is the share unit

## When NOT to use

- The flow spec doesn't exist yet — run composing-paths first
- The output target is something other than mermaid (PDF, Figma, etc.) — out of scope; render mermaid, let the operator convert downstream (mermaid live → Excalidraw works)

## Workflow

1. Read `grimoires/{product}/flows/{flow-id}.yaml` (the spec)
2. Build the mermaid graph: nodes per move, edges per handoff, subgraphs per construct
3. Apply class definitions for visual semantics:
   - `exists` (green) — construct + skill ready
   - `partial` (yellow) — construct exists, skill missing
   - `gap` (red dashed) — construct doesn't exist; surfaces from `gaps_surfaced[]`
   - `terminal` (blue) — flow exits the system / loops back
4. Write to `grimoires/{product}/flows/{flow-id}.md` with frontmatter + intent + mermaid + worksheet annotations (Q: questions, → handoffs)
5. Cross-link the markdown ↔ yaml so they stay paired

## Output shape

See `grimoires/loa/flows/first-author.md` and `grimoires/loa/flows/whats-next-after-export.md` (this repo's bootstrap drafts) for the canonical template.

Required sections:
- Frontmatter (flow_id, status, listening_session, composes, gaps_surfaced)
- Intent paragraph (user vocabulary)
- Mermaid diagram (centerpiece)
- Per-node Q: annotations (questions for KEEPER to walk through with user)
- → handoff list (which constructs consume which parts)
- Gaps section (loud, with proposal_target)

## Anti-patterns

- **Beautifying past truth.** Don't smooth out the gaps in the diagram. Red dashed nodes are the point. A pretty diagram with no callouts is a lie.
- **Inventing intent prose.** The `intent` paragraph quotes the user's vocabulary from `intents.yaml`. Don't paraphrase, don't elevate.
- **Silent updates.** When re-rendering, log the diff in NOTES.md so KEEPER's next session knows what changed since the last walk-through.

## Composes with

- **Upstream**: composing-paths (the spec to render) · naming-intents (the user-vocabulary phrasing)
- **Downstream**: operator (manual share) · Excalidraw via mermaid live (manual conversion path) · future `rendering-excalidraw` skill (deferred)
