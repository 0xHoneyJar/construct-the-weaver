#!/usr/bin/env bash
# render-flows.sh — extract mermaid diagrams from flow .md files and produce shareable artifacts
# Authored: 2026-04-27 by the-weaver/BEAUVOIR for micodex-studio dogfood
# Updated: 2026-04-27 — added full PNG pipeline (mmd → svg → html → png) via beautiful-mermaid + agent-browser
#
# Usage:
#   render-flows.sh <flows-dir>
#   render-flows.sh grimoires/loa/flows/
#
# Outputs (per flow file):
#   <flows-dir>/exports/mermaid/<flow-id>.mmd  — copy-paste source for mermaid.live
#   <flows-dir>/exports/svg/<flow-id>.svg      — vector render (uses CSS var() — won't convert via librsvg)
#   <flows-dir>/exports/png/<flow-id>.png      — Chrome-headless screenshot, auto-trimmed (default share artifact)
#   <flows-dir>/exports/README.md              — operator-facing instructions
#
# Pipeline rationale: see grimoires/{product}/flows/exports/constraints.md
# Modern mermaid uses CSS var() + color-mix() — rsvg-convert / magick can't evaluate these.
# Chrome headless via agent-browser is the only path that handles them correctly.
#
# Dependencies (auto-detected, gracefully skipped if missing):
#   - beautiful-mermaid skill (~/.agents/skills/beautiful-mermaid/)
#   - agent-browser CLI (npm install -g @hritik14/agent-browser or similar)
#   - magick (ImageMagick, for auto-trim)

set -euo pipefail

FLOWS_DIR="${1:-}"
if [[ -z "$FLOWS_DIR" ]]; then
    echo "Usage: $0 <flows-dir>" >&2
    echo "Example: $0 grimoires/loa/flows/" >&2
    exit 1
fi

if [[ ! -d "$FLOWS_DIR" ]]; then
    echo "ERROR: flows directory not found: $FLOWS_DIR" >&2
    exit 1
fi

# Resolve to absolute path so agent-browser file:// URIs work
FLOWS_DIR="$(cd "$FLOWS_DIR" && pwd)"

EXPORTS_DIR="$FLOWS_DIR/exports"
MERMAID_DIR="$EXPORTS_DIR/mermaid"
SVG_DIR="$EXPORTS_DIR/svg"
PNG_DIR="$EXPORTS_DIR/png"

mkdir -p "$MERMAID_DIR" "$SVG_DIR" "$PNG_DIR"

# Detect tools
BEAUTIFUL_MERMAID_DIR="${BEAUTIFUL_MERMAID_DIR:-$HOME/.agents/skills/beautiful-mermaid}"
HAS_BEAUTIFUL_MERMAID=0
if [[ -f "$BEAUTIFUL_MERMAID_DIR/scripts/render.ts" ]]; then
    HAS_BEAUTIFUL_MERMAID=1
fi

HAS_AGENT_BROWSER=0
if command -v agent-browser >/dev/null 2>&1; then
    HAS_AGENT_BROWSER=1
fi

HAS_MAGICK=0
if command -v magick >/dev/null 2>&1; then
    HAS_MAGICK=1
fi

echo "Pipeline detection:"
echo "  beautiful-mermaid: $([[ $HAS_BEAUTIFUL_MERMAID -eq 1 ]] && echo "✓ at $BEAUTIFUL_MERMAID_DIR" || echo "✗ skipping SVG render")"
echo "  agent-browser:     $([[ $HAS_AGENT_BROWSER -eq 1 ]] && echo "✓" || echo "✗ skipping PNG render")"
echo "  magick:            $([[ $HAS_MAGICK -eq 1 ]] && echo "✓" || echo "✗ skipping auto-trim")"
echo ""

# Validate source files for renderer-portability hazards
hazards=0
for flow_file in "$FLOWS_DIR"/*.md; do
    [[ -f "$flow_file" ]] || continue
    flow_basename="$(basename "$flow_file" .md)"
    case "$flow_basename" in README|keeper-walkthrough) continue ;; esac
    if grep -q "<br" "$flow_file" 2>/dev/null; then
        echo "  ⚠ $flow_basename uses <br/> — won't survive mermaid-to-excalidraw. Replace with ' · ' separator."
        hazards=$((hazards + 1))
    fi
done
[[ $hazards -gt 0 ]] && echo "  → see grimoires/{product}/flows/exports/constraints.md for the full rules" && echo ""

# Pass 1: extract mermaid blocks
extracted=0
for flow_file in "$FLOWS_DIR"/*.md; do
    [[ -f "$flow_file" ]] || continue

    flow_basename="$(basename "$flow_file" .md)"
    case "$flow_basename" in README|keeper-walkthrough) continue ;; esac

    mermaid_out="$MERMAID_DIR/$flow_basename.mmd"

    awk '
        /^```mermaid$/ { in_block=1; next }
        /^```$/ && in_block { in_block=0; exit }
        in_block { print }
    ' "$flow_file" > "$mermaid_out"

    if [[ ! -s "$mermaid_out" ]]; then
        rm -f "$mermaid_out"
        echo "  ⚠ no mermaid block in: $flow_basename"
        continue
    fi

    extracted=$((extracted + 1))
    echo "  ✓ extracted: $flow_basename ($(wc -l < "$mermaid_out" | tr -d ' ') lines)"
done
echo ""
echo "Extracted $extracted mermaid block(s) → $MERMAID_DIR"

# Pass 2: render SVG via beautiful-mermaid
if [[ "$HAS_BEAUTIFUL_MERMAID" -eq 1 && "$extracted" -gt 0 ]]; then
    echo ""
    echo "Rendering SVGs..."
    cd "$BEAUTIFUL_MERMAID_DIR"
    for mmd_file in "$MERMAID_DIR"/*.mmd; do
        [[ -f "$mmd_file" ]] || continue
        slug="$(basename "$mmd_file" .mmd)"
        svg_out="$SVG_DIR/$slug.svg"
        if npx tsx scripts/render.ts --input "$mmd_file" --output "$SVG_DIR/$slug" --theme default 2>&1 | grep -q "written"; then
            echo "  ✓ svg: $slug.svg"
        else
            echo "  ⚠ svg render failed for $slug"
        fi
    done
    cd - >/dev/null
fi

# Pass 3: SVG → HTML → PNG via Chrome headless (agent-browser)
if [[ "$HAS_BEAUTIFUL_MERMAID" -eq 1 && "$HAS_AGENT_BROWSER" -eq 1 && -d "$SVG_DIR" ]]; then
    echo ""
    echo "Rendering PNGs (Chrome headless)..."
    cd "$BEAUTIFUL_MERMAID_DIR"
    agent-browser set viewport 3840 2160 >/dev/null 2>&1 || true
    for svg_file in "$SVG_DIR"/*.svg; do
        [[ -f "$svg_file" ]] || continue
        slug="$(basename "$svg_file" .svg)"
        html_tmp="/tmp/render-flows-$slug.html"
        png_out="$PNG_DIR/$slug.png"

        if npx tsx scripts/create-html.ts --svg "$svg_file" --output "$html_tmp" >/dev/null 2>&1; then
            agent-browser open "file://$html_tmp" >/dev/null 2>&1 || true
            agent-browser wait 500 >/dev/null 2>&1 || true
            if agent-browser screenshot --full "$png_out" >/dev/null 2>&1; then
                # Auto-trim whitespace if magick available
                if [[ "$HAS_MAGICK" -eq 1 ]]; then
                    magick "$png_out" -trim -bordercolor "#f5f5f5" -border 40 "$png_out" 2>/dev/null || true
                fi
                echo "  ✓ png: $slug.png"
            else
                echo "  ⚠ png screenshot failed for $slug"
            fi
            rm -f "$html_tmp"
        fi
    done
    agent-browser close >/dev/null 2>&1 || true
    cd - >/dev/null
fi

# Pass 4: pre-bake mermaid.live share URLs (Python required)
if command -v python3 >/dev/null 2>&1 && [[ "$extracted" -gt 0 ]]; then
    echo ""
    echo "Generating mermaid.live share URLs..."
    python3 - <<PYEOF > "$EXPORTS_DIR/share-links.md" 2>/dev/null
import zlib, json, base64, os, glob
mermaid_dir = "$MERMAID_DIR"
print("# Share links")
print()
print("Self-contained mermaid.live URLs. Click → diagram renders pre-loaded. No install.")
print("**View** = read-only · **Edit** = open in mermaid.live editor (lets you copy-as-Excalidraw).")
print()
print("---")
print()
for mmd_path in sorted(glob.glob(os.path.join(mermaid_dir, "*.mmd"))):
    slug = os.path.splitext(os.path.basename(mmd_path))[0]
    with open(mmd_path) as f:
        code = f.read()
    payload = {
        "code": code, "mermaid": '{"theme":"default"}',
        "autoSync": True, "rough": False, "updateDiagram": True,
        "panZoom": True, "pan": {"x": 0, "y": 0}, "zoom": 1,
        "editorMode": "code"
    }
    j = json.dumps(payload, separators=(',', ':'))
    compressed = zlib.compress(j.encode('utf-8'), 9)
    encoded = base64.urlsafe_b64encode(compressed).decode().rstrip('=')
    print(f"### \`{slug}\`")
    print(f"- **VIEW**: https://mermaid.live/view#pako:{encoded}")
    print(f"- **EDIT** (with Copy-as-Excalidraw): https://mermaid.live/edit#pako:{encoded}")
    print()
PYEOF
    echo "  ✓ share-links.md"
fi

# Update exports README
cat > "$EXPORTS_DIR/README.md" <<'EOF'
# flow exports

Shareable artifacts derived from `../*.md` flow worksheets. Generated by
`construct-the-weaver/scripts/render-flows.sh`. Do not edit by hand —
re-run the script when source flows change.

## Layout

| Path | Purpose |
|---|---|
| `mermaid/<flow-id>.mmd` | Standalone mermaid source. Copy-paste into https://mermaid.live |
| `svg/<flow-id>.svg`     | Vector render (uses CSS `var()` — open in browser, do not convert via `rsvg-convert`/`magick`) |
| `png/<flow-id>.png`     | **The default share artifact.** Chrome-headless screenshot, auto-trimmed. Drag into GitHub comments / chat. |
| `share-links.md`        | Pre-baked `mermaid.live` URLs that load each diagram in-browser |
| `constraints.md`        | What survives which renderer — mermaid → excalidraw conversion rules |

## How to share

1. **Default**: drag a `png/*.png` into a GitHub comment, Discord, etc. Visual lands immediately.
2. **For collaborator scribble**: open the EDIT link from `share-links.md` → mermaid.live → Actions → Copy as Excalidraw → paste into excalidraw.com. Note: classDef colors and stroke-dasharray are **not** preserved through this conversion (see `constraints.md`).

## Re-running

```bash
construct-the-weaver/scripts/render-flows.sh grimoires/{product}/flows/
```

Idempotent. Safe to re-run after editing source `.md` files.
EOF

echo ""
echo "Done. See $EXPORTS_DIR/README.md"
