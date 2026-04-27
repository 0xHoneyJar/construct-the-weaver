---
aliases: [collab-register, collaborator-register, comm-register, the-register-i-keep-using, herald-voice-applied, u-see-wot-u-see-register]
tags: [doctrine, register, ux, communications, operator-os, load-bearing]
sources:
  - operator 2026-04-27 ("Have we distilled this writing style into a construct or composition... this is strong")
  - operator 2026-04-27 push-back on micodex-studio issue #4 first comment ("way too much to read") — the moment that crystallized the gap
  - team-deliberation 2026-04-27 (alexander + lexicographer + keeper + beauvoir verdicts in `~/.claude/teams/comms-craft-deliberation/`)
  - ~/hivemind/wiki/concepts/learn-mode.md ("operator's LEARN register" — common-noun precedent that this page promotes to proper-noun)
  - ~/hivemind/wiki/concepts/compressed-decision-prompts.md (the agent-to-operator dialogue protocol; this register's sibling)
  - ~/hivemind/wiki/concepts/surface-craft.md (the craft of authoring surfaces; this register is the signature surfaces wear for collaborators)
  - ~/hivemind/wiki/concepts/feel-register.md (per-world aesthetic precedent — the naming pattern this page mirrors)
  - ~/hivemind/wiki/concepts/freeside-deceptively-simple-register.md (per-product register precedent)
  - ~/hivemind/strategy/audiences.md ("four audiences, four registers, four doors" — the broader register taxonomy this slots into)
  - .claude/constructs/packs/herald/identity/persona.yaml (the voice this register inherits and applies)
  - .claude/projects/-Users-zksoju-Documents-GitHub-micodex-studio/memory/feedback_collaborator_comm_doctrine.md (the operational rules being absorbed here)
created: 2026-04-27
updated: 2026-04-27
decay_class: doctrine
confidence: 0.85
status: active
load_bearing: true
coined_by: lexicographer construct (vocab-bank persona) in team-deliberation 2026-04-27
edges:
  - {type: composes-with, target: "[[learn-mode]]", context: this is the OUTPUT register; learn-mode is the INPUT register. mirror images. same operator cognition, two directions.}
  - {type: composes-with, target: "[[compressed-decision-prompts]]", context: that page is the agent→operator dialogue protocol; this page is the operator/agent→collaborator output register. compressed-decision-prompts is THIS REGISTER applied to the dialogue surface specifically.}
  - {type: composes-with, target: "[[surface-craft]]", context: surface-craft authors the surface; this register is the signature the surface wears when the audience is a collaborator. surface-craft is the verb; this is the adverb.}
  - {type: extends, target: "[[feel-register]]", context: feel-register is per-WORLD aesthetic; herald-register is per-AUDIENCE-CLASS register (collaborators specifically). same naming pattern, different unit.}
  - {type: applied-by, target: "[[crafting-collaborator-comms]]", context: the global skill that operationalizes this register at write-time}
  - {type: voiced-by, target: "[[herald-construct]]", context: herald is the persona; this register is herald's voice rendered for the 1:1 collaborator surface (vs. broadcast surface)}
  - {type: anti-pattern-of, target: "[[internal-docs-voice]]", context: title-case headers, multi-paragraph preambles, ceremonial CC lines, swelling bullet lists. the failure mode KEEPER named in the deliberation audit.}
---

# Herald Register

> *"Have we distilled this writing style into a construct or composition... this is strong."* — operator 2026-04-27, naming the load-bearing thing

> *"Way too much to read."* — operator 2026-04-27, the corrective push-back that minted this doctrine

The **herald register** is the perceptual fingerprint a surface must carry when its audience is a *collaborator* (a non-builder human or another agent receiving authored output, not deliberating with the operator). It is the operator's native writing register applied at the moment of authoring collaborator-facing communications — GitHub issue/PR comments, messages to teammates, share-prompts, kickoffs, anything the reader will *scan, react to, and bounce off if it fails*.

This page exists because the operator validated this register as load-bearing UX (2026-04-27) and a four-construct deliberation (`alexander + lexicographer + keeper + beauvoir`) converged on three things: (1) it IS a register, not a craft or construct, (2) it should be named `herald-register` (anchoring on the existing herald persona), (3) it needs a *mechanical* invocation — memory recall is too probabilistic.

---

## TL;DR — the rules

| Rule | One-liner |
|---|---|
| 1. Image / diagram first | the visual lands; prose does not. lead with the artifact, not the explanation. if there's no artifact yet, leave a placeholder for the operator to drop one in. |
| 2. ≤10 lines prose total | walls are anti-pattern. anything more is wrong-shaped. |
| 3. Lowercase casual | herald voice. no caps for emphasis. no corporate hedging. no "I just wanted to" / "happy to" / cc-ceremony. |
| 4. Emoji as object handles | every section / option / status gets a glyph that COMPRESSES meaning. not decoration. 🌱 first-time, 🚪 returning, 🧬 codex, 🚀 post-export — handles, not sparkles. |
| 5. One legend line, never a legend block | `🔴 missing · 🟡 partial · 🟢 ready · 🟠 question` — middle-dot separator. |
| 6. ≤3 bullets in any "how to engage" | 5+ bullets = wrong-shaped — the message is doing the work the artifact should do. |
| 7. Decisions go through `AskUserQuestion` shape | emoji-led, ≤12-char headers, 1 sentence per option, ≤4 options including 🤷 "different question." See [[compressed-decision-prompts]]. |
| 8. Link to detail; don't inline detail | `→ [walkthrough.md](url)` beats explaining the walkthrough in the comment. |
| 9. Drop ceremonial scaffolding | no CC lines, no role explanations, no "let me know if you have questions" disclaimers. trust the reader. |

If you can't deliver in this shape, the message is wrong-sized. Cut, link, defer — don't unfurl.

---

## Why this is load-bearing UX

Three compounding effects:

1. **Cognitive throughput.** The operator (and visual-first collaborators like gumi, Eileen, Lily) processes faster than reading. A wall of prose forces sequential reading; the herald register presents the decision/question/payload as a *spatial layout* — scannable in milliseconds. This is the same doctrine as [[learn-mode]] (input side) and [[compressed-decision-prompts]] (dialogue side), now applied to the *output* surface.

2. **Land-rate.** Walls of text don't land. Collaborators bounce. The agent doesn't know they bounced. The operator finds out later when the work didn't propagate. This register is the gating factor between "agent ships work" and "agent ships work that the human can actually USE." The micodex-studio issue #4 push-back was the canonical incident: dense first comment → operator ask "way too much to read" → re-author into image-first compressed form → land-rate restored.

3. **Compounds across constructs.** Without this register, every construct that produces collaborator-facing output (`herald`, `the-weaver`, `keeper`, `gtm-collective`'s `social-oracle`/`showcase`) re-invents the comm shape per artifact. With it, they all wear the same signature — recognizable as "this came from this operator's network." Brand-by-default.

The KEEPER audit (2026-04-27) found the doctrine had been applied unevenly — wins where it was infrastructure (creating-constructs gh description convention, flows/ classDef palette) and misses where it was ad-hoc (kickoff-style walkthroughs, first-pass GH comments). The audit's verdict: **doctrine in partial practice**. This page closes that gap by giving the doctrine a name, a home, and a mechanical invocation.

---

## What the register is NOT

- **NOT internal-documentation voice.** Specs, RFCs, architecture docs, sprint plans — those have their own (denser, more structured) register. The herald register is for *human-facing surface-deliveries*, not for canonical internal artifacts.
- **NOT [[compressed-decision-prompts]].** That page is the *dialogue protocol* (agent→operator, AskUserQuestion-shaped). Herald register is the *output register* (operator/agent→collaborator). They share principles (compression, emoji, ≤4 options), but they apply to different surfaces. The dialogue protocol is one *application* of the register, not the whole register.
- **NOT [[surface-craft]].** Surface-craft authors the visual surface (illustration, shaders, gradients). Herald register is the *signature* a surface (visual or textual) wears when the audience is a collaborator. Different layer.
- **NOT a construct.** Per Alexander's craft-lens verdict: it's a register, not a thing. Constructs *use* the register; the register doesn't own them. Forcing it into a construct would fragment the voice across packs.
- **NOT operator-private.** This is the register the operator USES, but the agent should also produce in it whenever the audience is a non-builder. Same shape, both sources.

---

## The failure-mode signature (KEEPER's audit)

When the register is *not* applied, the agent reverts to **internal-documentation voice**:

- Title-case section headers ("How to Run Through It" instead of "how to react")
- Three-paragraph "what these are / what we're trying to do / context" preamble before the visual lands
- Ceremonial CC lines, role explanations ("As BEAUVOIR (the-weaver), I..."), disclaimer-style closings
- Bulleted "how to engage" sections that swell past 3 entries
- Inline legend blocks (multi-line) where one line + emoji would do
- "Don't be polite to the worksheets" pep-talk paragraphs that explain the *expected user behavior* instead of just inviting it

The reader skims headers, sees no image in the first viewport, and bounces. The dance isn't read because the dance was buried under prose explaining what dance to expect.

If you spot any of these in your draft, **the register is failing** — return to TL;DR and re-author.

---

## How to invoke

Three invocation paths, ranked by reliability:

1. **Mechanical (recommended)** — Claude Code hook on `PreToolUse:Bash` matching `gh issue comment` / `gh pr comment` / `gh pr create` / `gh issue create`, plus `PreToolUse:Write` for paths under `**/comments/**` or other collab surfaces. The hook injects a reminder that loads `[[crafting-collaborator-comms]]` skill. Mechanical invocation = doctrine applied even when the agent forgets to recall this page. *(Status: skill exists at `~/.claude/skills/crafting-collaborator-comms/`; hook deferred pending operator approval — see proposal note in skill.)*
2. **Skill description match** — `crafting-collaborator-comms` skill description names the trigger surfaces explicitly ("authoring GitHub issue/PR comments, messages to collaborators, share-prompts"). When the agent says "I'm about to author a GH comment" the skill auto-loads. Catches the cases the hook misses (chat copy, slack, email).
3. **Manual recall** — operator says "wear herald register" or "apply herald-register to this draft." Lowest reliability; only as fallback.

The doctrine evolves by editing one place: `[[crafting-collaborator-comms]] SKILL.md` — which sources from this page. The hook is content-agnostic.

---

## Composition map

```
[[learn-mode]]                              [[compressed-decision-prompts]]
        ↓ (input register, sibling)                    ↓ (dialogue surface application)
                              herald-register
        ↑ (output signature)                           ↑ (operationalized by)
[[surface-craft]]                          [[crafting-collaborator-comms]] skill
                                                       ↑ (mechanically invoked by)
                                                  Claude Code hook (proposed)
```

Per-audience instances of the broader register doctrine:
- [[freeside-deceptively-simple-register]] — register for Freeside's chrome surface (per-product)
- audience-registers in [[audiences]] — Base culture / CN mobile / X social / agent-native (per-channel)
- [[feel-register]] — per-world aesthetic register (parallel pattern, different unit)

Herald register is the **default fallback register** when no more-specific register applies and the audience is a collaborator. If you're shipping to a Freeside-chrome surface, use [[freeside-deceptively-simple-register]]; if you're shipping to a CN mobile audience, use the CN register from [[audiences]]; otherwise, herald register.

---

## Provenance

Coined 2026-04-27 by the `lexicographer` construct in team deliberation `comms-craft-deliberation` (config at `~/.claude/teams/comms-craft-deliberation/config.json`). Four expert constructs (`alexander`, `lexicographer`, `keeper`, `beauvoir`) deliberated on naming, location, application, and invocation. Convergence was clean across all four lenses.

The proximate trigger was the operator's push-back on a dense first-pass GitHub comment in `0xHoneyJar/micodex-studio` issue #4 (2026-04-27): *"way too much to read."* The corrective re-authoring became the validating example.

The doctrine was *already in operation* via fragments in [[learn-mode]], [[compressed-decision-prompts]], a session feedback memory, and skill-level rules in `the-weaver/rendering-mermaid` and `creating-constructs`. This page consolidates those fragments under one name so the rules can be cited, evolved, and mechanically enforced.

Per [[naming-is-diagnostic]]: until 2026-04-27, this register couldn't be cited in reviews because it had no name. Now it can — *"violates herald register"* is a sayable thing.
