---
description: Check SuperApp_PQ readiness before coding or handoff.
---

# Preflight

## Step 1 — Read Rules

Read `AGENTS.md`, `GEMINI.md`, and `.agents/rules/00-superapp-project.md` before any broad task.

## Step 2 — Inspect Worktree

```bash
rtk git status --short
rtk git diff --stat HEAD
```

Note dirty files. Do NOT revert or overwrite unless explicitly asked.

## Step 3 — Verify Key Files

```bash
# Confirm SwiftGen binary exists
rtk ls Pods/SwiftGen/bin/swiftgen

# Confirm generated files exist
rtk rg --files SuperApp_PQ/Resources/Generated

# Confirm base layer exists
rtk rg --files SuperApp_PQ/Core/Base | head -10
```

If generated files are missing, run SwiftGen first:
```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

## Step 4 — Validate Config

```bash
rtk xcodebuild -list -workspace SuperApp_PQ.xcworkspace
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

## Step 5 — Build Staging

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

## Step 6 — Build Production (if applicable)

Build Production when task affects: shared config, resources, pods, or project-level setup.

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Production" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

## Step 7 — Report

Summarize:
- **Dirty files** relevant to the task
- **Validation**: SwiftGen lint ✓/✗, plutil ✓/✗
- **Build**: Staging ✓/✗, Production ✓/✗ (if run)
- **Blockers**: file + line for any errors
- **Risks**: anything that may regress after the task

## Exit Condition ✓

Preflight is complete when:
- [ ] Worktree state documented
- [ ] Generated files confirmed present
- [ ] SwiftGen + strings validated
- [ ] Staging build passes (or blockers documented)
