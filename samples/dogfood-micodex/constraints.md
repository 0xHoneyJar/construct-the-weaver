# Mermaid → Excalidraw / PNG conversion constraints

> Distilled while dogfooding `the-weaver` on micodex-studio session #4 prep.
> Constraints belong upstream in `the-weaver/rendering-mermaid` skill so future
> flows are renderer-portable by default.

## TL;DR — write mermaid that travels

| Constraint | Rule |
|---|---|
| **Multi-line node labels** | NEVER use `<br/>` or `<br>`. Use ` · ` (middle dot) as inline separator instead. |
| **Special characters in labels** | Wrap in quotes: `A["Welcome screen · welcome-screen.tsx"]`. Slash, dash, parens all need quotes. |
| **classDef colors** | Use them. They survive PNG render but get *stripped* by `mermaid-to-excalidraw` (Excalidraw uses its own palette). Treat them as readable-by-humans signals, not load-bearing visual contract. |
| **stroke-dasharray** | Survives PNG render via Chrome headless. Stripped in Excalidraw. Re-add manually if needed. |
| **Subgraph quoted titles** | `subgraph X["title — with em dash"]` works in both. Use the bracket+quote form. |
| **Edge labels** | Use pipe form `A -->|label| B`, never `A -- label --> B` (per beautiful-mermaid skill — incomplete renders). |
| **Stadium / parallelogram / diamond shapes** | All survive PNG. Diamond `{...}` and stadium `([...])` survive Excalidraw. Trapezoid `[/.../]` may render as rectangle in Excalidraw. |
| **Emojis in labels** | Survive everywhere. Use them — they're the cheapest visual signal. |

## The renderer matrix

| Renderer | `<br/>` | classDef colors | stroke-dasharray | CSS `var()` / `color-mix()` | Markers |
|---|:---:|:---:|:---:|:---:|:---:|
| GitHub markdown (mermaid) | ✓ | ✓ | ✓ | ✓ | ✓ |
| https://mermaid.live | ✓ | ✓ | ✓ | ✓ | ✓ |
| `beautiful-mermaid` CLI (strict) | ✗ literal `&lt;br/&gt;` | ✓ | ✓ | n/a | ✓ |
| `mermaid-to-excalidraw` | ✗ literal | ✗ stripped | ✗ stripped | n/a | ✓ |
| `rsvg-convert` (librsvg) | n/a | ✓ | ✓ | ✗ broken | ✗ broken |
| `magick` (ImageMagick) | n/a | ✓ | ✓ | ✗ broken | ✗ broken |
| Chrome headless (`agent-browser screenshot`) | ✓ | ✓ | ✓ | ✓ | ✓ |

**Take-away**: if you want a single mermaid source that renders correctly **everywhere**, write it for the `mermaid-to-excalidraw` constraint (no `<br/>`, classDef as documentation rather than load-bearing color). Render PNG via Chrome headless (agent-browser), not via librsvg/ImageMagick — modern mermaid uses CSS custom properties that native SVG converters don't evaluate.

## The PNG pipeline that works

```
.md (flow worksheet)
    ↓ extract mermaid block
.mmd  (standalone source, copy-paste into mermaid.live)
    ↓ beautiful-mermaid render.ts
.svg  (uses CSS custom props — won't convert via librsvg)
    ↓ beautiful-mermaid create-html.ts
.html (wrapper that browser CSS engine can resolve)
    ↓ agent-browser screenshot --full
.png  (4K viewport screenshot, includes everything)
    ↓ magick -trim -bordercolor "#f5f5f5" -border 40
.png  (auto-cropped, padded — ready to drop in GitHub comment)
```

Encoded in `construct-the-weaver/scripts/render-flows.sh` (idempotent — safe to re-run).

## The Excalidraw round-trip (when you want it)

Excalidraw round-trip is **gumi-scribbling-ready** but loses color and dash patterns:

1. Open `mermaid.live` (paste from `.mmd` or use the pre-baked URLs in `share-links.md`)
2. Actions → Copy as Excalidraw
3. excalidraw.com → paste
4. classDef colors will be **lost** — re-color manually if it matters
5. stroke-dasharray will be **lost** — re-style manually if it matters
6. Multi-line labels render fine **only if** the source uses ` · ` separators (not `<br/>`)
7. Export → PNG / SVG / `.excalidraw` JSON for sharing

## Programmatic Excalidraw generation (investigated, not viable)

`@excalidraw/mermaid-to-excalidraw` is the official SDK. Tried via:
- **JSDOM** — fails on `text2.getBBox is not a function` (jsdom doesn't implement SVG measurement)
- **Playwright/Puppeteer** — would work, but heavy install for marginal benefit when PNG is already good

For now: **PNG is the default deliverable; Excalidraw round-trip is the optional scribble path.**

## Anti-patterns observed (all corrected in micodex-studio's flows on 2026-04-27)

1. ❌ `Welcome[Welcome screen<br/>welcome-screen.tsx]`
   ✅ `Welcome[Welcome screen · welcome-screen.tsx]`

2. ❌ `Pass[✓ all 6 required files<br/>+ 3 required skills<br/>+ 5 required dirs]`
   ✅ `Pass[✓ all 6 required files · + 3 required skills · + 5 required dirs]`

3. ❌ `TmpHome[/tmp/micodex-demo<br/>· ephemeral · sovereignty break/]`
   ✅ `TmpHome[/tmp/micodex-demo · ephemeral · sovereignty break/]`

The substitution `s|<br/?>|·|g` (with surrounding spaces) handles ~99% of cases cleanly.
