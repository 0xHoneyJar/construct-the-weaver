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
3. Apply the **canonical classDef vocabulary** (consistent across all flows for shared reading):
   - `exists` (green fill, green stroke) — construct + skill ready
   - `partial` (yellow fill, yellow stroke) — construct exists, skill missing
   - `gap` (red fill, red dashed stroke) — construct doesn't exist; surfaces from `gaps_surfaced[]`
   - `studio` (blue fill, blue stroke) — stays inside the product's chrome / loops back
   - `question` (orange fill, orange dashed) — open question for KEEPER, or runtime decision point
   - `win` (bright green, thicker stroke) — first-win moment for the user
4. Write to `grimoires/{product}/flows/{flow-id}.md` with frontmatter + intent + mermaid + worksheet annotations (Q: questions, → handoffs)
5. Cross-link the markdown ↔ yaml so they stay paired
6. After writing, run the renderer pipeline (see `scripts/render-flows.sh`) to produce shareable PNG + share-link artifacts under `flows/exports/`

## Renderer-portability rules (load-bearing)

Mermaid syntax has cross-renderer pitfalls. Author for the **most-restrictive** renderer (`@excalidraw/mermaid-to-excalidraw`) and everything downstream survives. See `grimoires/{product}/flows/exports/constraints.md` (the constraints brief, written 2026-04-27) for the full matrix. The hard rules:

| Constraint | Rule | Why |
|---|---|---|
| Multi-line node labels | NEVER `<br/>`. Use ` · ` (middle-dot) inline separator. | `mermaid-to-excalidraw` renders `<br/>` as literal text; `beautiful-mermaid` strict mode escapes it; only mermaid.live's loose mode accepts it. |
| Special chars in labels | Wrap in quotes: `A["text · path/to/file.tsx"]` | Slashes, parens, dashes break the parser unquoted. |
| Edge labels | Use pipe form `A -->|label| B` | Per `beautiful-mermaid` skill — `A -- label --> B` causes incomplete renders. |
| Subgraph titles | `subgraph X["title"]` (bracket+quote) | Survives all renderers; bare titles can lose punctuation. |
| classDef colors | Use them, but treat as readable-by-humans signal **not load-bearing visual contract**. | Colors stripped by Excalidraw conversion (uses its own palette). Survives PNG render. |
| stroke-dasharray | Same: signal-only, not contract. | Stripped by Excalidraw. Survives Chrome-headless PNG render. |
| Emojis | Use freely. | Survive everywhere. Cheapest visual signal. |

## The shareable-artifact pipeline

After `rendering-mermaid` writes the `.md`, the operator (or a future automation) runs:

```bash
scripts/render-flows.sh grimoires/{product}/flows/
```

Which produces:
- `exports/mermaid/{flow}.mmd` — extracted standalone source
- `exports/svg/{flow}.svg` — beautiful-mermaid render
- `exports/png/{flow}.png` — Chrome-headless screenshot, auto-trimmed (the **default share artifact** — drag into GitHub comments, paste into chat)
- `exports/share-links.md` — pre-baked `mermaid.live` URLs that load each diagram in-browser (for the operator's manual `Copy as Excalidraw → excalidraw.com` scribble path during listening sessions)

**Never** convert SVG → PNG via `rsvg-convert` or `magick` directly — modern mermaid uses CSS `var()` and `color-mix()` that those tools don't evaluate. Use Chrome headless via `agent-browser screenshot --full`.

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
- **Using `<br/>` in node labels.** Breaks mermaid-to-excalidraw conversion. Use ` · ` separator. (See `flows/exports/constraints.md`.)
- **Skipping the PNG render.** The `.md` alone is not a shareable artifact for collaborator-facing comms — gumi and others will see "too much to read." Always run the export pipeline so a PNG drops into GitHub / chat surfaces visual-first per the `feedback_collaborator_comm_doctrine` operator memory.

## Composes with

- **Upstream**: composing-paths (the spec to render) · naming-intents (the user-vocabulary phrasing)
- **Downstream**: operator (manual share) · Excalidraw via mermaid live (manual conversion path) · future `rendering-excalidraw` skill (deferred)
