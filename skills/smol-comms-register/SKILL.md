---
name: smol-comms-register
description: Apply the smol-comms-register (operator handle `/smol`, formal alias `herald-register`) when authoring collaborator-facing communications — GitHub issue/PR comments, PR descriptions, messages to non-builder teammates (gumi, Eileen, Lily, community members), share-prompts, kickoffs, anything where the audience will scan-and-react. Visual-first, lowercase casual, emoji-as-handles, ≤10 lines prose, image-or-diagram before explanation. NOT for internal docs (specs/RFCs/sprint plans), NOT for agent-to-agent dialogue, NOT when audience is the operator's own deliberation surface (use compressed-decision-prompts AskUserQuestion instead).
user-invocable: true
allowed-tools: Read, Write, Edit, Bash
---

# `/smol` — smol-comms-register, operationalized

> **Canonical** at https://github.com/0xHoneyJar/construct-the-weaver/blob/main/skills/smol-comms-register/SKILL.md — this file is a mirror so the skill loads in operator-private sessions before teammates install the pack. **When editing, edit both** until the pack is installed across the team.

When authoring anything a collaborator will read, the doctrine is the **smol-comms-register** (operator handle `/smol`, formal alias `herald-register`) — load-bearing UX named in [`docs/smol-comms-register.md`](https://github.com/0xHoneyJar/construct-the-weaver/blob/main/docs/smol-comms-register.md) (mirrored from `~/hivemind/wiki/concepts/smol-comms-register.md`). This skill is the write-time enforcement.

## Trigger

Auto-load on these surfaces:
- `gh issue comment` / `gh pr comment` / `gh issue create` / `gh pr create`
- Drafting a Slack/Discord/email message FOR somebody (not internal notes)
- Writing the body of a PR description
- Authoring `kickoffs/`, `share-links.md`, walk-through prompts
- Composing a gist intended for collaborator paste-and-run
- Any message addressed to a named non-agent human

DO NOT load for:
- Internal documentation (PRD/SDD/sprint plans/architecture docs)
- Agent-to-agent SendMessage in team deliberations
- Operator-to-agent dialogue (use `AskUserQuestion` shape instead — that's [[compressed-decision-prompts]])
- Code commits (those have their own conventions)
- README files (denser register OK there)

If unsure: **default ON for any GitHub comment**. The blast radius of applying it where unneeded is low; the cost of skipping where needed is reader-bounce.

## The 9 rules (must hold every time)

| # | Rule | Quick check |
|---|---|---|
| 1 | **Image or diagram first** — visual lands before prose | If first viewport has no artifact, restructure |
| 2 | **≤10 lines prose total** | Count. Walls are anti-pattern. |
| 3 | **Lowercase casual** — no caps for emphasis, no corporate hedging | "way too much" not "Way Too Much" |
| 4 | **Emoji as object handles** — every section/option/status gets a glyph that COMPRESSES meaning | 🌱 first-time, 🚪 returning, 🧬 codex, 🚀 post-export — handles, not sparkles |
| 5 | **One legend line, never a block** | `🔴 missing · 🟡 partial · 🟢 ready · 🟠 question` |
| 6 | **≤3 bullets in any "how to engage"** | 5+ bullets = wrong-shaped |
| 7 | **Decisions go through `AskUserQuestion` shape** | Emoji-led, ≤12-char headers, 1 sentence per option, ≤4 options including 🤷 "different question" |
| 8 | **Link to detail; don't inline detail** | `→ [walkthrough.md](url)` beats explaining in the comment |
| 9 | **Drop ceremonial scaffolding** | No CC lines, no role explanations, no "let me know if you have questions" |

## Workflow when authoring

1. **Identify the audience** — who reads this? If non-builder collaborator, register applies.
2. **Draft the artifact first** (image, diagram, code-snippet, gist). The artifact does the load-bearing work.
3. **Write the framing in ≤10 lines prose** — hook, sections, legend, ≤3 engagement bullets.
4. **Apply the failure-mode check** (below) before submitting.
5. **If you can't deliver in this shape, the message is wrong-sized** — cut, link, defer.

## Failure-mode signature (refuse to ship if you spot any)

If your draft contains any of these, the register is failing — restart from rule 1:

- ❌ Title-case section headers ("How to Run Through It" instead of "how to react")
- ❌ Three-paragraph "what these are / what we're trying to do / context" preamble before the visual
- ❌ Ceremonial CC lines, role explanations ("As BEAUVOIR, I..."), disclaimer closings
- ❌ Bulleted "how to engage" sections that swell past 3 entries
- ❌ Inline legend BLOCKS (multi-line) where one line + emoji would do
- ❌ Pep-talk paragraphs explaining the *expected user behavior* instead of inviting it
- ❌ Multiple "ref:" links at the bottom in paragraph form
- ❌ Reading-level: "I" / "we" / "our team" framing when an artifact + caption would carry the same load

## Surface-specific notes

### GitHub issue / PR comments

Use native ```mermaid blocks inside `<details open>` for diagrams (GH attaches a pan/zoom widget for big graphs since 2022, community discussion #137171). Embedding large PNGs at column-width crushes text — use them only as link-wrapped thumbnails (`[![alt](thumb.png)](scribble-url)`) when the click-through is the point. See `the-weaver/rendering-mermaid/SKILL.md` for the full pipeline.

### Chat (Discord / Slack)

PNGs preserve native size and have lightbox built in — different surface, different rules. Image-first still holds. Compression even tighter (≤6 lines prose).

### Email

Subject line is the headline (rule 1 applied to email). Body ≤10 lines. Inline images OK; attachments only if asked.

### Paste-and-run gists

Title block names what the prompt does in one line. Body is structured for *the agent that will run it*, not the human pasting. The human only reads the title + the call-to-action.

## Why this register exists

Three load-bearing effects (full prose in `~/hivemind/wiki/concepts/herald-register.md`):

1. **Cognitive throughput** — the operator and visual-first collaborators process scannable surfaces faster than reading prose. Walls force sequential reading; this register presents as spatial layout.
2. **Land-rate** — collaborators bounce off walls. The agent doesn't know they bounced. The cost surfaces later as work that didn't propagate. This register is the gating factor between "agent ships work" and "agent ships work that lands."
3. **Compounds** — every construct that produces collaborator-facing output ([[herald]], [[the-weaver]], [[observer]], [[gtm-collective]]'s `social-oracle`/`showcase`) wears the same signature. Brand-by-default.

## Composes with

- **[[herald-register]]** (canonical doctrine) — this skill is the write-time application
- **[[compressed-decision-prompts]]** — the dialogue-surface application (use AskUserQuestion when the surface IS a decision)
- **[[learn-mode]]** — sibling input register; same operator cognition, mirror direction
- **[[surface-craft]]** — surface-craft authors the visual; this register is the signature it wears for collaborators
- **`the-weaver/rendering-mermaid` SKILL** — surface-specific rules for diagram-bearing comments
- **[[naming-is-diagnostic]]** — gives this register the name that lets reviews cite *"violates herald register"*

## Anti-pattern: ignoring the register because the surface "feels internal"

`grimoires/loa/flows/keeper-walkthrough.md` was authored as a 60–90-min facilitator script — heavy artifact, internal-docs voice. KEEPER's audit (2026-04-27) flagged this: it sits in a public branch as a collaborator-adjacent surface. The register would have asked: "is this the visual hand-off, or my facilitator notes?" — and split them. Ad-hoc artifacts are exactly where the register drifts. The hook (when it ships) catches this; until then, the operator-side discipline is to ask the splitting question before authoring.

## Hook proposal (deferred — operator approval needed)

Per BEAUVOIR's invocation design (team deliberation 2026-04-27):

```json
// proposed addition to ~/.claude/settings.json hooks
{
  "hooks": {
    "PreToolUse:Bash": [
      {
        "matcher": "gh (issue|pr) (comment|create)",
        "command": "echo 'reminder: this is collaborator-facing. apply herald-register. read ~/.claude/skills/crafting-collaborator-comms/SKILL.md' >&2"
      }
    ]
  }
}
```

This makes invocation mechanical (cannot forget what the harness enforces). Until applied, this skill loads via description-match — reliable but cognitive.

## Provenance

Distilled from team deliberation `comms-craft-deliberation` (2026-04-27) — alexander + lexicographer + keeper + beauvoir converged on (a) it's a register not a craft, (b) name = `herald-register`, (c) operationalize as a single skill + hook, (d) doctrine in *partial* practice today drifts to internal-docs voice on ad-hoc artifacts.

The proximate trigger: operator push-back on `0xHoneyJar/micodex-studio` issue #4 first comment (*"way too much to read"*) → corrective re-authoring became the validating example.
