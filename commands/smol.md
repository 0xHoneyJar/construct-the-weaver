# /smol — apply the smol comms register

Operator handle for the **smol comms register** (formal: `herald-register`). Visual-first, lowercase casual, emoji-as-handles, ≤10 lines prose, image-or-diagram before explanation. The register the operator keeps using and just wants on by default for collaborator-facing surfaces.

## Trigger

```
/smol                    # hold the register active for the next message
/smol audit <text>       # audit the text against the 9 rules + failure-mode
/smol rewrite <text>     # re-author in the register
/smol on this comment    # apply to whatever's currently being drafted
```

## What it does

1. Loads the `crafting-collaborator-comms` skill (the operationalization of the doctrine)
2. Holds the register active for the next collaborator-facing artifact you're authoring
3. If text is provided, audits it against the 9 rules + the failure-mode signature, rewrites if needed

## The 9 rules (TL;DR — full doctrine in the skill)

| # | rule |
|---|---|
| 1 | image / diagram first — the visual lands; prose does not |
| 2 | ≤10 lines prose total — walls are anti-pattern |
| 3 | lowercase casual — herald voice, no caps for emphasis |
| 4 | emoji as object handles — every section/option/status gets a glyph that compresses meaning |
| 5 | one legend line, never a block |
| 6 | ≤3 bullets in any "how to engage" |
| 7 | decisions go through `AskUserQuestion` shape — emoji + ≤12-char headers |
| 8 | link to detail; don't inline detail |
| 9 | drop ceremonial scaffolding — no CC lines, no role explanations |

## Failure-mode signature (refuse to ship if you spot any)

- ❌ title-case section headers ("How to Run Through It" not "how to react")
- ❌ multi-paragraph preamble before the visual lands
- ❌ ceremonial CC, role explanations, disclaimer closings
- ❌ swelling bullet lists past 3
- ❌ inline legend BLOCKS where one line + emoji would do
- ❌ pep-talk paragraphs explaining expected user behavior

## When NOT to use

- internal docs (specs/RFCs/sprint plans) — denser register OK
- agent-to-agent SendMessage in team deliberations
- operator-to-agent dialogue (use `AskUserQuestion` shape instead)
- code commits / READMEs (own conventions)

## Reference

- 📚 doctrine: https://github.com/0xHoneyJar/construct-the-weaver/blob/main/docs/herald-register.md
- 🛠 skill: `crafting-collaborator-comms` (auto-loads via description-match, also fires via PreToolUse:Bash hook on `gh issue/pr comment`)
- 🪶 formal name: `herald-register` (composes with `feel-register`, `freeside-register`, audience-registers)

## Provenance

operator coined "smol comms" 2026-04-27 as the natural tongue-handle for the doctrine the lexicographer construct had named `herald-register`. both names ship — `/smol` is the invocation, `herald-register` is the citable formal name.
