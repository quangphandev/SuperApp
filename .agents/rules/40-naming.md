---
description: File, class, and UI component naming conventions for all Swift files in SuperApp_PQ.
globs:
  - "SuperApp_PQ/**/*.swift"
alwaysApply: false
---

# Naming Conventions

Full reference: `NAMING_CONVENTION.md`.

## File & Type Naming

| Type | Suffix | Example |
|---|---|---|
| ViewController | `ViewController` | `HomeViewController`, `LoginViewController` |
| ViewModel | `ViewModel` | `HomeViewModel`, `LoginViewModel` |
| Coordinator | `Coordinator` | `HomeCoordinator` |
| Service | `Service` | `UserService` |
| Repository | `Repo` | `UserRepo` |
| Cell | `Cell` | `ProductCell` |
| Config | `Config` | `NetworkConfig` |
| Extension file | `UIView+Shadow.swift` | — |

Rules:
- PascalCase for files, types, enums.
- camelCase for variables, functions, properties.
- No ObjC prefixes (`PQ`, `SA`).
- No abbreviated domain names — only type-role suffixes.

## UI Component Property Suffix

**Required** for all UIKit component properties in ViewController, View, and Cell:

| UIKit Class | Suffix | Example |
|---|---|---|
| `UILabel` | `lbl` | `titleLabel`, `priceLabel` |
| `UITextField` | `tf` | `emailTextField`, `passwordTextField` |
| `UITextView` | `tv` | `descriptionTextView`, `notesTextView` |
| `UIImageView` | `img` | `avatarImageView`, `bannerImageView` |
| `UIStackView` | `st` | `mainStackView`, `actionsStackView` |
| `UITableView` | `tb` | `feedTableView`, `ordersTableView` |
| `UICollectionView` | `cl` | `bannersCollectionView`, `gridCollectionView` |
| `UIButton` | `btn` | `submitButton`, `loginButton` |
| `UIView` (container) | `vw` | `headerView`, `cardView` |
| `UIScrollView` | `sv` | `contentScrollView` |
| `UISwitch` | `sw` | `notificationSwitch` |
| `UISlider` | `sl` | `volumeSlider` |
| `UIActivityIndicatorView` | `ai` | `loadingActivityIndicator` |
| `UIPageControl` | `pc` | `bannerPageControl` |

Rules:
- Always add context after prefix: `titleLabel`, not just `lbl`.
- camelCase: `userNameLabel`, not `lbl_user_name`.
- Never use full type name: `titleLabel` → `titleLabel`, `emailTextField` → `emailTextField`.

## MVViewModel-C Feature Folder Structure

```
Features/<Name>/
  View/         <Name>ViewController.swift
  ViewModel/    <Name>ViewModel.swift
  Coordinator/  <Name>Coordinator.swift
  Model/        <Name>Model.swift
  Service/      <Name>Service.swift
  Components/   <Name><Component>View.swift   (feature-local only)
```

## File Header (Mandatory)

```swift
//
//  HomeViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 06/06/26.
//
```

## Quick Reference — LoginViewController Example

```swift
final class LoginViewController: BaseViewController<LoginViewModel> {
    private let logoImageView: UIImageView = { ... }()
    private let titleLabel: UILabel = { ... }()
    private let emailTextField: AppTextField = { ... }()
    private let passwordTextField: AppTextField = { ... }()
    private let fieldsStackView: UIStackView = { ... }()
    private let loginButton: AppButton = { ... }()
}
```
