---
description: Add a localized string key to English and Vietnamese, regenerate SwiftGen, and validate strings.
---

# Add Localization Key

1. Add the same key to:
   - `SuperApp_PQ/Resources/en.lproj/Localizable.strings`
   - `SuperApp_PQ/Resources/vi.lproj/Localizable.strings`
2. Run:

```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml
rtk plutil -lint SuperApp_PQ/Resources/en.lproj/Localizable.strings SuperApp_PQ/Resources/vi.lproj/Localizable.strings
```

3. Replace hardcoded UI copy with `L10n.*`.
4. If the screen must update without restart, listen to `.appLanguageDidChange` in the ViewModel.
5. Build Staging.
