---
name: superapp-localization
description: "Add or update localization in SuperApp_PQ using SwiftGen, generated L10n, AppLanguage, AppLocalizer, English/Vietnamese .strings files, and runtime language switching. Use when adding text keys, replacing hardcoded UI strings, regenerating SwiftGen outputs, or wiring screens to refresh after language changes."
---

# SuperApp Localization Skill

## File Map

| Purpose | Path |
|---|---|
| SwiftGen config | `swiftgen.yml` |
| English strings | `SuperApp_PQ/Resources/en.lproj/Localizable.strings` |
| Vietnamese strings | `SuperApp_PQ/Resources/vi.lproj/Localizable.strings` |
| Generated strings | `SuperApp_PQ/Resources/Generated/Strings+Generated.swift` |
| Generated assets | `SuperApp_PQ/Resources/Generated/Assets+Generated.swift` |
| Language enum | `SuperApp_PQ/Core/Localization/AppLanguage.swift` |
| Runtime switcher | `SuperApp_PQ/Core/Localization/AppLocalizer.swift` |

## Adding A Key (Step-by-step)

**Step 1** — Add key to both files simultaneously:

```
// en.lproj/Localizable.strings
"home.welcome.greeting" = "Welcome back";
"home.welcome.subtitle" = "Here's what's new today.";

// vi.lproj/Localizable.strings
"home.welcome.greeting" = "Chào mừng trở lại";
"home.welcome.subtitle" = "Đây là những điều mới hôm nay.";
```

Key naming convention: `<feature>.<screen>.<element>` — lowercase, dot-separated.

**Step 2** — Regenerate SwiftGen:

```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

**Step 3** — Use `L10n.*` in Swift (never raw strings):

```swift
// Generated accessor (from Strings+Generated.swift)
welcomeLabel.text = L10n.Home.Welcome.greeting
subtitleLabel.text = L10n.Home.Welcome.subtitle
```

**Step 4** — Validate:

```bash
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

## Runtime Language Switching

```swift
// Switch language:
AppLocalizer.setLanguage(.vietnamese)
AppLocalizer.setLanguage(.english)
```

## Live Update Pattern (ViewModel-driven)

If the screen must refresh its text without restart, use this pattern in the ViewModel — the ViewController does not need any language-specific code:

```swift
func transform(input: Input) -> Output {
    let localeRefresh = NotificationCenter.default.rx
        .notification(.appLanguageDidChange)
        .mapToVoid()

    let content = Observable
        .merge(Observable.just(()), localeRefresh)
        .map { [contentProvider] in contentProvider.makeContent() }
        .asDriverOnErrorJustComplete()

    return Output(
        title: content.map { $0.title },
        subtitle: content.map { $0.subtitle }
    )
}
```

## Rules

- Add every new key to **both** English and Vietnamese files.
- Run SwiftGen after any `.strings` file change.
- Use only `L10n.*` — never hardcode user-facing copy in VCs, Views, or Components.
- Live-update screens: listen to `.appLanguageDidChange` through the ViewModel output stream.
- Key format: `<feature>.<screen>.<element>` — match the SwiftGen generated path.
