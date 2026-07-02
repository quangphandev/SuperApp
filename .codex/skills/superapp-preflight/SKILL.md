---
name: superapp-preflight
description: "Check SuperApp_PQ readiness before coding, after code changes, or before handoff by inspecting project rules, dirty worktree context, CocoaPods, SwiftGen, localization, schemes, and focused Xcode builds. Use when the user asks to check, prepare to code, verify, build, or sanity check this project."
---

# SuperApp Preflight

## Step 1 — Read Context

Read `AGENTS.md`, `GEMINI.md`, and `.agents/rules/00-superapp-project.md` before any broad task.

## Step 2 — Check Worktree

```bash
rtk git status --short
rtk git diff --stat HEAD
```

Note dirty files. Do NOT revert or overwrite unless explicitly asked.

## Step 3 — Verify Key Files

```bash
# Generated files exist?
rtk rg --files SuperApp_PQ/Resources/Generated

# Base layer exists?
rtk rg --files SuperApp_PQ/Core/Base

# SwiftGen binary available?
rtk ls Pods/SwiftGen/bin/swiftgen
```

If generated files are missing, run SwiftGen first:
```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

## Step 4 — Validate Config

```bash
rtk xcodebuild -list -workspace SuperApp_PQ.xcworkspace
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings \
           SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

## Step 5 — Build Staging

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

## Step 6 — Build Production (when needed)

Build Production when task affects shared config, resources, pods, or project-level setup.

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Production" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

## Step 7 — Report

Summarize:
- **Dirty files** — relevant to the task
- **Validation** — SwiftGen ✓/✗, plutil ✓/✗
- **Build** — Staging ✓/✗, Production ✓/✗ (if run)
- **Blockers** — file + line for errors
- **Risks** — anything that may regress after task

## Exit Condition

Preflight is complete when:
- [ ] Worktree state known
- [ ] Generated files confirmed present
- [ ] SwiftGen + strings validated
- [ ] Staging build passes (or blockers documented)
