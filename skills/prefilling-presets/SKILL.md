---
name: prefilling-presets
description: Turn named flows into intent-based-button templates and prefilled presets — the things that get users to a quick win without making them configure.
user-invocable: true
allowed-tools: Read, Write, Edit
---

# Prefilling Presets

The template generator. Takes named intents + composed paths and emits **presets** — concrete configurations that prefill a product's surface so the user starts close to a win instead of staring at an empty form.

This is the skill that operationalizes gumi's "intent-based buttons" framing from issue #8: *"turns idea into agency."*

## Trigger

```
/weave prefill <intent-id>
"give me a preset for this intent"
"what would the welcome screen show for first-time author"
```

## When to use

- An intent is named + path is composed, and the product needs a starting-point template
- Operator is shipping a welcome screen / onboarding surface and wants intent-driven options instead of free-form
- A flow has a "first-win" success signal that requires specific defaults to reach
- Product is too generic — every screen feels like a blank form. Presets bind the surface to lived intent.

## When NOT to use

- The intent isn't named yet — run naming-intents
- The path isn't composed — run composing-paths
- The user wants A/B variants — that's a-different-skill territory (kansei or the-arcade)
- The presets need actual UI authoring (component code) — that's downstream artisan

## Workflow

1. Read the intent (`grimoires/{product}/intents.yaml`) + the flow spec (`grimoires/{product}/flows/{intent-id}.yaml`)
2. Identify the *configuration surface* the intent passes through — for `author-collection` in micodex-studio, that's the New Collection form (`welcome-screen.tsx:115`) which currently asks only for name
3. Determine which configuration values are *intent-implied* vs *user-distinct*:
   - intent-implied = always the same for this intent (e.g. `output.collectionSize: 5000` is what every author-collection user defaults to)
   - user-distinct = always varies (e.g. project name)
4. Emit a preset bundle: a JSON/YAML object that prefills the intent-implied fields and leaves the user-distinct fields editable
5. Write to `grimoires/{product}/presets/{intent-id}.yaml` and reference it from the flow spec's `presets[]` field

## Output shape

```yaml
# grimoires/{product}/presets/author-collection.yaml
preset_id: micodex-studio.author-collection
intent_id: author-collection
authored_by: the-weaver/prefilling-presets
authored_at: <ISO date>
applies_to: welcome-screen.tsx new-collection form

prefill:
  output.width: 1024
  output.height: 1024
  output.collectionSize: 5000
  output.imagePrefix: "ipfs://placeholder/"
  output.namePattern: "{name} #{n}"

user_distinct:
  - name             # required user input
  - description      # optional user input

button_label: "I want to make a generative collection"
button_subtitle: "5000 PFP-style; configurable later"
```

## Anti-patterns

- **Defaulting away from user agency.** If a field is genuinely intent-distinct (every user wants different N), don't prefill it. Presets are starting points, not lock-ins.
- **One-size-fits-all defaults.** A preset for "author-collection" probably needs sub-presets ("PFP-style" vs "generative-art-1of1" vs "open-edition"). Author the variants.
- **Skipping the listening.** Presets baked from operator imagination, not user truth, are the same trap as templates. Run KEEPER first.
- **Fossilizing presets.** Presets evolve as the user-vocabulary evolves. Mark them `status: draft` until validated; review on intent-vocabulary updates.

## Composes with

- **Upstream**: naming-intents (intent vocabulary) · composing-paths (flow spec)
- **Downstream**: artisan (button copy / visual style of the preset chooser) · the-arcade (win-state design — what does success feel like?)
