---
description: SwiftGen localization and runtime language switching rules.
globs:
  - "swiftgen.yml"
  - "SuperApp_PQ/Resources/**/*.strings"
  - "SuperApp_PQ/Core/Localization/**/*.swift"
  - "SuperApp_PQ/Resources/Generated/**/*.swift"
  - "SuperApp_PQ/**/*.swift"
alwaysApply: false
---

# Localization And SwiftGen

Use generated localization for all user-facing copy. Never hardcode display strings in VCs, Views, or Components.

## File Map

| Purpose | Path |
|---|---|
| SwiftGen config | `swiftgen.yml` |
| English strings | `SuperApp_PQ/Resources/en.lproj/Localizable.strings` |
| Vietnamese strings | `SuperApp_PQ/Resources/vi.lproj/Localizable.strings` |
| Generated strings accessor | `SuperApp_PQ/Resources/Generated/Strings+Generated.swift` |
| Generated asset accessor | `SuperApp_PQ/Resources/Generated/Assets+Generated.swift` |
| Language enum | `SuperApp_PQ/Core/Localization/AppLanguage.swift` |
| Runtime switcher | `SuperApp_PQ/Core/Localization/AppLocalizer.swift` |
| Change notification | `.appLanguageDidChange` (NotificationCenter) |

## Adding A New Key

1. Add the key to **both** strings files:

```
// en.lproj/Localizable.strings
"profile.edit.title" = "Edit Profile";
"profile.edit.saveButton" = "Save Changes";

// vi.lproj/Localizable.strings
"profile.edit.title" = "Chỉnh sửa hồ sơ";
"profile.edit.saveButton" = "Lưu thay đổi";
```

2. Run SwiftGen to regenerate:

```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

3. Use `L10n.*` in Swift — never raw strings:

```swift
// ✅ Correct
titleLabel.text = L10n.Profile.Edit.title
saveButton.setTitle(L10n.Profile.Edit.saveButton, for: .normal)

// ❌ Wrong
titleLabel.text = "Edit Profile"
```

## Runtime Language Switching

```swift
// Switch language at runtime (e.g. from a settings screen):
AppLocalizer.setLanguage(.vietnamese)
AppLocalizer.setLanguage(.english)
```

Screens that must update live (without restart) should listen to the notification **in the ViewModel**:

```swift
// In ViewModel.transform():
let localeRefresh = NotificationCenter.default.rx
    .notification(.appLanguageDidChange)
    .mapToVoid()

let content = Observable.merge(Observable.just(()), localeRefresh)
    .map { [contentProvider] in contentProvider.makeContent() }
    .asDriverOnErrorJustComplete()
```

Then drive labels from `content.map { $0.title }` — the ViewController doesn't need to know about language changes.

## Validate

```bash
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

## Rules Summary

- Add every new key to both `en.lproj` and `vi.lproj` files simultaneously.
- Run SwiftGen after any `.strings` file change.
- Use only `L10n.*` accessors in Swift code.
- Screens needing live updates: listen to `.appLanguageDidChange` through the ViewModel output stream, not in the ViewController.
- Do not hardcode user-facing copy anywhere in VCs, Views, or Components.
