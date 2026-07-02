---
name: superapp-preflight
description: "Check SuperApp_PQ readiness before coding, after code changes, or before handoff by inspecting project rules, dirty worktree context, CocoaPods, SwiftGen, localization, schemes, and focused Xcode builds. Use when the user asks to check, prepare to code, verify, build, or sanity check this project."
---

# SuperApp Preflight Skill

## Step 1 — Read Context

```bash
# Read AGENTS.md and relevant rules before any broad task
rtk rg "BaseViewModel|BaseViewController|AppColor" SuperApp_PQ/Core/Base --files-with-matches
```

Read:
- `AGENTS.md` — project rules and Luma design profile
- `GEMINI.md` — Antigravity entry point
- `.agents/rules/00-superapp-project.md` — always-on rules

## Step 2 — Check Worktree

```bash
rtk git status --short
rtk git diff --stat HEAD
```

Note which files are dirty. Do not revert or overwrite unless explicitly asked.

## Step 3 — Verify Key Files Exist

```bash
rtk rg --files SuperApp_PQ/Core/Base | rtk rg "BaseViewController|BaseViewModel|BaseCoordinator"
rtk rg --files SuperApp_PQ/DesignSystem | rtk rg "AppColor|AppFont|AppButton"
rtk rg --files SuperApp_PQ/Resources/Generated | rtk rg "Strings\+Generated|Assets\+Generated"
```

If generated files are missing, run SwiftGen first:
```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

## Step 4 — Validate Config

```bash
# List workspace schemes
rtk xcodebuild -list -workspace SuperApp_PQ.xcworkspace

# Validate SwiftGen config
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml

# Validate strings files
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

## Step 5 — Build

```bash
# Always build Staging first
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build

# Build Production when task affects shared config, resources, pods, or project setup
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Production" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

## Step 6 — Report

Summarize:
- **Changed files** — list dirty worktree items relevant to the task
- **Validation** — SwiftGen lint pass/fail, plutil pass/fail
- **Build** — Staging pass/fail, Production pass/fail (if run)
- **Blockers** — concrete errors with file + line references
- **Risks** — anything that may break after this task

## Exit Condition

Preflight is complete when:
- [x] Worktree state is known
- [x] Key files confirmed present
- [x] SwiftGen and strings validated
- [x] Staging build passes (or blockers are documented)
