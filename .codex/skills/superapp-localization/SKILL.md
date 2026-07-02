---
name: superapp-localization
description: "Add or update localization in SuperApp_PQ using SwiftGen, generated L10n, AppLanguage, AppLocalizer, English/Vietnamese .strings files, and runtime language switching. Use when adding text keys, replacing hardcoded UI strings, regenerating SwiftGen outputs, or wiring screens to refresh after language changes."
---

# SuperApp Localization

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

**Step 1** — Add to both files simultaneously. Key format: `<feature>.<screen>.<element>`.

```
// en.lproj/Localizable.strings
"home.welcome.greeting" = "Welcome back";

// vi.lproj/Localizable.strings
"home.welcome.greeting" = "Chào mừng trở lại";
```

**Step 2** — Regenerate:

```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

**Step 3** — Use `L10n.*` only — never raw strings:

```swift
welcomeLabel.text = L10n.Home.Welcome.greeting  // ✅
welcomeLabel.text = "Welcome back"              // ❌
```

**Step 4** — Validate:

```bash
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings \
           SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

## Runtime Language Switching

```swift
AppLocalizer.setLanguage(.vietnamese)
AppLocalizer.setLanguage(.english)
```

## Live Update ViewModel Pattern

Screens that must refresh without restart — handle in ViewModel, not ViewController:

```swift
func transform(input: Input) -> Output {
    let localeRefresh = NotificationCenter.default.rx
        .notification(.appLanguageDidChange).mapToVoid()

    let content = Observable.merge(Observable.just(()), localeRefresh)
        .map { [contentProvider] in contentProvider.makeContent() }
        .asDriverOnErrorJustComplete()

    return Output(title: content.map { $0.title })
}
```

## Rules

- Add every key to **both** English and Vietnamese files.
- Run SwiftGen after any `.strings` change.
- Use only `L10n.*` in Swift code.
- Live-update screens: listen to `.appLanguageDidChange` via ViewModel output stream.
- Do not hardcode user-facing copy in VCs, Views, or Components.
