# SuperApp_PQ — Antigravity Entry Point

**Working Directory**: `/Users/admin/Desktop/DemoPQ/SuperApp_PQ`

---

## Behavioral Core (Always Active)

Four principles apply to every task:

1. **Think Before Coding** — State assumptions explicitly. Surface ambiguity before implementing. If a request has multiple meanings, present options — don't pick silently. Ask when context is missing.

2. **Simplicity First** — Write the minimum code that solves the problem. No speculative features, no abstractions for one-off code, no extra configurability. If it could be 50 lines, don't write 200.

3. **Surgical Changes** — Touch only what the request requires. Don't improve adjacent code. Match existing style. Remove only the dead code your own changes created — mention unrelated dead code separately.

4. **Goal-Driven Execution** — Convert tasks into verifiable outcomes before editing. State a brief plan for multi-step work. Run the smallest meaningful verification. Loop until verified or a concrete blocker is documented.

---

## Shell Rule

Always prefix every shell command with `rtk`.

```bash
rtk rg "HomeVM"
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" -quiet build
```

---

## Rule Files (Always-On)

Load these before any broad task:

| File | Scope |
|---|---|
| `.agents/rules/00-superapp-project.md` | Always-on: workspace, shell, stack, base classes, DesignSystem, networking |
| `.agents/rules/10-ios-architecture.md` | Swift `*.swift` files: MVVM-C layers, patterns, code templates |
| `.agents/rules/15-clean-architecture.md` | Feature Swift files: Domain/Data/Presentation dependency boundaries |
| `.agents/rules/20-ui-design-lists.md` | DesignSystem + Feature View files: UI tokens, list choice, animation |
| `.agents/rules/30-localization-swiftgen.md` | `.strings` + localization files: SwiftGen, L10n, runtime switching |
| `.agents/rules/40-naming.md` | Swift `*.swift` files: file/type naming, UI component prefixes (lbl/tf/tv/img/st/tb/cl...) |

---

## Skills (On-Demand)

Invoke a skill when the user names it or when the task matches the skill's purpose.
Read the relevant `SKILL.md` before applying. Announce the skill in one sentence.

| Skill | Purpose |
|---|---|
| `superapp-design-system` | UIKit UI, DesignSystem tokens, components, animation |
| `superapp-clean-architecture` | Domain/Data/Presentation, UseCase, Repository boundaries |
| `superapp-ios-feature` | New feature, MVVM-C, Clean Architecture, DI |
| `superapp-list-ui` | TableView, CollectionView, cells, compositional layout |
| `superapp-localization` | L10n keys, SwiftGen, runtime language switching |
| `superapp-network` | APIEndpoint, Repository, UseCase network wiring |
| `superapp-figma` | Figma design, Luma tokens, screenshot validation |
| `superapp-preflight` | Build readiness, validation before/after changes |

Each skill lives in `.agents/skills/<name>/SKILL.md` and may have a `references/` folder with concrete code examples.

---

## Workflows (Slash Commands)

| Command | File |
|---|---|
| `/clean-feature` | `.agents/workflows/clean-feature.md` |
| `/new-feature` | `.agents/workflows/new-feature.md` |
| `/add-localization-key` | `.agents/workflows/add-localization-key.md` |
| `/add-feature-service` | `.agents/workflows/add-feature-service.md` |
| `/build-staging-production` | `.agents/workflows/build-staging-production.md` |
| `/preflight` | `.agents/workflows/preflight.md` |

---

## Core Constraints

- Analyze design and architecture before editing any source file.
- Use `rtk` for every shell command — no exceptions.
- Preserve user changes. Do not revert, delete, or overwrite unless explicitly asked.
- Verify with the smallest meaningful build (`SuperApp_PQ Staging` scheme).
- For Figma work: screenshot validate every change. Never report done without visual confirmation.
- Full project rules: `AGENTS.md` (this repo root).
