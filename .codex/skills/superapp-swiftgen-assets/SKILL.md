---
name: superapp-swiftgen-assets
description: "Manage, add, and regenerate colors, images/icons, and localized texts using SwiftGen and Xcode build (Command+B)."
---

# SuperApp SwiftGen Assets & Localization Skill

This skill explains how to add new assets (colors, images, icons) and localized strings to the project, regenerate SwiftGen accessors, and use them in code.

## File Map

| Asset Type | Source Path | Generated Accessor Path | Code Usage Example |
|---|---|---|---|
| **Colors** | `SuperApp_PQ/Assets.xcassets/` | `SuperApp_PQ/Resources/Generated/Assets+Generated.swift` | `Asset.colorAccentPrimary.color` |
| **Images & Icons** | `SuperApp_PQ/Assets.xcassets/` | `SuperApp_PQ/Resources/Generated/Assets+Generated.swift` | `Asset.arrowTriangle2Circlepath.image` |
| **Localized Strings** | `SuperApp_PQ/Resources/en.lproj/Localizable.strings`<br>`SuperApp_PQ/Resources/vi.lproj/Localizable.strings` | `SuperApp_PQ/Resources/Generated/Strings+Generated.swift` | `L10n.Home.title` |

---

## 1. Adding Colors

1. Open `SuperApp_PQ/Assets.xcassets` in Xcode.
2. Click the `+` button at the bottom of the list and choose **New Color Set**.
3. Name the Color Set using the naming convention: `color.domain.name` (lowercase, separated by dots).
   * Example: `color.accent.primary`, `color.surface.card`
4. Set the color values for Light and Dark appearances in the inspector.
5. Save.

---

## 2. Adding Images & Icons

1. Prepare your assets in PNG or SVG (vector) format.
2. Drag and drop the asset into `SuperApp_PQ/Assets.xcassets` or open it in Xcode, click `+` and choose **New Image Set**.
3. Name the Image Set using the naming convention:
   * CamelCase or system SF Symbols name style (e.g., `arrow.triangle.2.circlepath`, `home.fill`, `ic_search`).
4. Select the asset, go to the Attributes Inspector, and configure:
   * For SVGs: Check **Preserve Vector Data** and set **Scales** to *Single Scale*.
5. Save.

---

## 3. Adding Localized Strings

1. Add your new localized string key to **both** files simultaneously:
   * English: [Localizable.strings](file:///Users/admin/Desktop/VCCProject/SuperApp/SuperApp_PQ/Resources/en.lproj/Localizable.strings)
   * Vietnamese: [Localizable.strings](file:///Users/admin/Desktop/VCCProject/SuperApp/SuperApp_PQ/Resources/vi.lproj/Localizable.strings)
2. Use the naming convention: `<feature>.<screen>.<element>` (lowercase, separated by dots).
   * Example:
     ```strings
     // English (en.lproj)
     "profile.edit.save_button" = "Save Changes";

     // Vietnamese (vi.lproj)
     "profile.edit.save_button" = "Lưu thay đổi";
     ```

---

## 4. Triggering SwiftGen Generation

There are two ways to run SwiftGen and generate the Swift accessors so that your new colors, images, and texts are available in code:

### Method A: Xcode Build (Command + B)
The Xcode project contains a custom **SwiftGen** Build Phase script that runs automatically prior to compilation.
* Simply press **Command + B** (or select **Product > Build**) in Xcode.
* SwiftGen will parse `Assets.xcassets` and the `.strings` files, updating [Assets+Generated.swift](file:///Users/admin/Desktop/VCCProject/SuperApp/SuperApp_PQ/Resources/Generated/Assets+Generated.swift) and [Strings+Generated.swift](file:///Users/admin/Desktop/VCCProject/SuperApp/SuperApp_PQ/Resources/Generated/Strings+Generated.swift).

### Method B: Terminal Command (CLI)
If you are working via terminal/CLI, run:
```bash
rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
```

---

## 5. Usage in Code

Once generation is complete, use the typed accessors instead of hardcoded strings or names:

### Colors
```swift
// ✅ Correct
cardView.backgroundColor = Asset.colorAccentPrimary.color
titleLabel.textColor = Asset.colorTextPrimary.color

// ❌ Wrong
cardView.backgroundColor = UIColor(named: "color.accent.primary")
```

### Images & Icons
```swift
// ✅ Correct
iconImageView.image = Asset.arrowTriangle2Circlepath.image
homeButton.setImage(Asset.homeFill.image, for: .normal)

// ❌ Wrong
iconImageView.image = UIImage(named: "arrow.triangle.2.circlepath")
```

### Localized Texts
```swift
// ✅ Correct
titleLabel.text = L10n.Profile.Edit.saveButton

// ❌ Wrong
titleLabel.text = "Save Changes"
```
