// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let fitAppIcon = ImageAsset(name: "fit_app_icon")
  internal static let fitEmptyState = ImageAsset(name: "fit_empty_state")
  internal static let fitErrorSync = ImageAsset(name: "fit_error_sync")
  internal static let fitFullLogo = ImageAsset(name: "fit_full_logo")
  internal static let fitGpsRoute = ImageAsset(name: "fit_gps_route")
  internal static let fitHomeActive = ImageAsset(name: "fit_home_active")
  internal static let fitHomeInactive = ImageAsset(name: "fit_home_inactive")
  internal static let fitNutritionActive = ImageAsset(name: "fit_nutrition_active")
  internal static let fitNutritionInactive = ImageAsset(name: "fit_nutrition_inactive")
  internal static let fitProfileActive = ImageAsset(name: "fit_profile_active")
  internal static let fitProfileInactive = ImageAsset(name: "fit_profile_inactive")
  internal static let fitRunning = ImageAsset(name: "fit_running")
  internal static let fitSleepActive = ImageAsset(name: "fit_sleep_active")
  internal static let fitSleepInactive = ImageAsset(name: "fit_sleep_inactive")
  internal static let fitWordmark = ImageAsset(name: "fit_wordmark")
  internal static let fitWorkoutActive = ImageAsset(name: "fit_workout_active")
  internal static let fitWorkoutDone = ImageAsset(name: "fit_workout_done")
  internal static let fitWorkoutInactive = ImageAsset(name: "fit_workout_inactive")
  internal static let arrowTriangle2Circlepath = ImageAsset(name: "arrow.triangle.2.circlepath")
  internal static let book = ImageAsset(name: "book")
  internal static let checklist = ImageAsset(name: "checklist")
  internal static let checkmarkCircleFill = ImageAsset(name: "checkmark.circle.fill")
  internal static let checkmarkSeal = ImageAsset(name: "checkmark.seal")
  internal static let colorAccentPrimary = ColorAsset(name: "color.accent.primary")
  internal static let colorAccentSecondary = ColorAsset(name: "color.accent.secondary")
  internal static let colorBgBase = ColorAsset(name: "color.bg.base")
  internal static let colorBgNav = ColorAsset(name: "color.bg.nav")
  internal static let colorBorderDefault = ColorAsset(name: "color.border.default")
  internal static let colorBorderStrong = ColorAsset(name: "color.border.strong")
  internal static let colorBrandCore = ColorAsset(name: "color.brand.core")
  internal static let colorBrandOrbit = ColorAsset(name: "color.brand.orbit")
  internal static let colorBrandSpark = ColorAsset(name: "color.brand.spark")
  internal static let colorDangerDefault = ColorAsset(name: "color.danger.default")
  internal static let colorInfoDefault = ColorAsset(name: "color.info.default")
  internal static let colorSuccessDefault = ColorAsset(name: "color.success.default")
  internal static let colorSurfaceAccent = ColorAsset(name: "color.surface.accent")
  internal static let colorSurfaceBase = ColorAsset(name: "color.surface.base")
  internal static let colorSurfaceDisabled = ColorAsset(name: "color.surface.disabled")
  internal static let colorSurfaceRaised = ColorAsset(name: "color.surface.raised")
  internal static let colorSurfaceSelected = ColorAsset(name: "color.surface.selected")
  internal static let colorTextInverse = ColorAsset(name: "color.text.inverse")
  internal static let colorTextMuted = ColorAsset(name: "color.text.muted")
  internal static let colorTextPrimary = ColorAsset(name: "color.text.primary")
  internal static let colorTextSecondary = ColorAsset(name: "color.text.secondary")
  internal static let colorTextSubtle = ColorAsset(name: "color.text.subtle")
  internal static let colorWarningDefault = ColorAsset(name: "color.warning.default")
  internal static let ellipsis = ImageAsset(name: "ellipsis")
  internal static let exclamationmarkTriangleFill = ImageAsset(name: "exclamationmark.triangle.fill")
  internal static let exclamationmarkTriangle = ImageAsset(name: "exclamationmark.triangle")
  internal static let figureRun = ImageAsset(name: "figure.run")
  internal static let homeFill = ImageAsset(name: "home.fill")
  internal static let infoCircleFill = ImageAsset(name: "info.circle.fill")
  internal static let sparkles = ImageAsset(name: "sparkles")
  internal static let tray = ImageAsset(name: "tray")
  internal static let wifiSlash = ImageAsset(name: "wifi.slash")
  internal static let xmarkCircleFill = ImageAsset(name: "xmark.circle.fill")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
