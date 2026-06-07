# 📐 Bộ Quy Tắc Đặt Tên (Naming Convention) — SuperApp_PQ

> Tài liệu này định nghĩa bộ quy tắc đặt tên file, class, và thư mục cho toàn bộ dự án iOS `SuperApp_PQ`.
> Mục tiêu: nhất quán, ngắn gọn, dễ đọc và dễ tìm kiếm.

---

## 1. Bảng Viết Tắt Chuẩn (Abbreviation Table)

| Từ đầy đủ | Viết tắt | Ví dụ |
|---|---|---|
| `ViewController` | `VC` | `HomeVC`, `LoginVC` |
| `ViewModel` | `VM` | `HomeVM`, `LoginVM` |
| `View` | `View` | `AvatarView`, `CardView` |
| `Model` | `Model` | `UserModel`, `ProductModel` |
| `Manager` | `Manager` | `AuthManager`, `CacheManager` |
| `Service` | `Service` | `UserService`, `PaymentService` |
| `Repository` | `Repo` | `UserRepo`, `OrderRepo` |
| `Coordinator` | `Coordinator` | `AppCoordinator`, `HomeCoordinator` |
| `Router` | `Router` | `HomeRouter`, `AppRouter` |
| `Cell` (UITableViewCell / UICollectionViewCell) | `Cell` | `ProductCell`, `UserCell` |
| `Header` (section header) | `Header` | `CartHeader`, `OrderHeader` |
| `Footer` (section footer) | `Footer` | `CartFooter` |
| `Configuration` | `Config` | `AppConfig`, `NetworkConfig` |
| `Extension` | `+` (suffix trong tên file) | `UIView+Shadow.swift` |
| `Protocol` | `Protocol` | `UserProtocol` hoặc `Userable` |
| `Enum` | `Type` hoặc tên rõ ràng | `OrderStatusType`, `PaymentMethod` |
| `Builder` | `Builder` | `AlertBuilder`, `RequestBuilder` |
| `Handler` | `Handler` | `DeepLinkHandler`, `ErrorHandler` |
| `Helper` | `Helper` | `DateHelper`, `StringHelper` |
| `Constant` | `Constant` | `AppConstant`, `APIConstant` |
| `UILabel` | `lbl` | `lblTitle`, `lblSubtitle` |
| `UITextField` | `tf` | `tfEmail`, `tfPassword` |
| `UITextView` | `tv` | `tvDescription`, `tvNotes` |
| `UIImageView` | `img` | `imgAvatar`, `imgBanner` |
| `UIStackView` | `st` | `stMain`, `stActions` |
| `UITableView` | `tb` | `tbFeed`, `tbSettings` |
| `UICollectionView` | `cl` | `clBanners`, `clProducts` |
| `UIButton` | `btn` | `btnSubmit`, `btnCancel` |
| `UIView` (container) | `vw` | `vwHeader`, `vwCard` |
| `UIScrollView` | `sv` | `svContent`, `svMain` |
| `UISwitch` | `sw` | `swNotification`, `swDarkMode` |
| `UISlider` | `sl` | `slVolume`, `slBrightness` |
| `UIActivityIndicatorView` | `ai` | `aiLoading` |
| `UIPageControl` | `pc` | `pcBanner`, `pcOnboarding` |

---

## 2. Quy Tac Dat Ten File

Format chung: `[Ten chuc nang] + [Loai file]`

| File | Khong dung | Nen dung |
|---|---|---|
| View Controller | `HomeViewController.swift` | `HomeVC.swift` |
| ViewModel | `HomeViewModel.swift` | `HomeVM.swift` |
| Custom View | `CustomAvatarView.swift` | `AvatarView.swift` |
| Table Cell | `ProductTableViewCell.swift` | `ProductCell.swift` |
| Repository | `UserRepository.swift` | `UserRepo.swift` |
| Config | `NetworkConfiguration.swift` | `NetworkConfig.swift` |
| Extension | `UIViewExtension.swift` | `UIView+Shadow.swift` |

---

## 3. Quy Tac Dat Ten Class / Struct / Enum

Format: `[Ten chuc nang][Viet tat loai]`

```swift
// Dung
class HomeVC: UIViewController { }
class HomeVM { }
struct UserModel { }
class ProductCell: UITableViewCell { }

// Sai
class HomeViewController: UIViewController { }
class HomeViewModel { }
class ProductTableViewCell: UITableViewCell { }
```

---

## 4. Cau Truc Thu Muc (SuperApp_PQ)

```
SuperApp_PQ/
  Features/
    Home/
      View/         HomeVC.swift
      ViewModel/    HomeVM.swift
      Coordinator/  HomeCoordinator.swift
      Model/        HomeFeatureItem.swift
      Service/      HomeService.swift
      Components/   HomeFeatureView.swift
  Core/
    Base/           BaseVC, BaseVM, BaseTableVC, ...
    Network/        APIEndpoint, APIClient, NetworkError
    Localization/   AppLanguage, AppLocalizer
  DesignSystem/
    Foundation/     AppColor, AppFont, AppSpacing, AppRadius, AppShadow, AppAnimation
    Components/     AppButton, AppCardView, AppChip, AppTextField, ...
  Resources/
    Generated/      Strings+Generated.swift, Assets+Generated.swift
    en.lproj/       Localizable.strings
    vi.lproj/       Localizable.strings
```

---

## 5. Quy Tac Dat Ten Extension (File)

Format: `[Class goc]+[Chuc nang].swift`

```
UIView+Shadow.swift
UIColor+Palette.swift
String+Validate.swift
Date+Format.swift
```

---

## 6. Quy Tac Dat Ten Protocol

```swift
// Hau to Protocol (cho abstraction layer lon)
protocol UserServiceProtocol { }
protocol FooCoordinating { }

// Hau to -able (delegate / utility)
protocol Loadable { }
protocol Bindable { }
protocol Reusable { }
```

---

## 7. Quy Tac Dat Ten Enum

Format: `[Ten chuc nang]Type` hoac `[Ten chuc nang]State`

```swift
enum OrderStatusType { case pending, processing, completed, cancelled }
enum PaymentMethod { case credit, debit, eWallet }
enum HomeState { case loading, loaded, error }
```

---

## 8. Quy Tac Bo Sung

- **PascalCase** cho file, class, struct, enum, protocol.
- **camelCase** cho bien, ham, property.
- **Khong dung prefix** kieu Objective-C (`PQ`, `SA`...).
- **Khong viet tat ten nghiep vu**, chi viet tat loai file (VC, VM, Repo...).
- Ten phai dien dat dung chuc nang: `ProductListVC` khong phai `ListVC`.

---

## 9. Quy Tac Dat Ten UI Component (Property Prefix)

Khi khai bao UI component la property cua ViewController, View, hoac Cell, **bat buoc** dung prefix viet tat:

| UIKit Class | Prefix | Vi du |
|---|---|---|
| `UILabel` | `lbl` | `lblTitle`, `lblSubtitle`, `lblPrice` |
| `UITextField` | `tf` | `tfEmail`, `tfPassword`, `tfSearch` |
| `UITextView` | `tv` | `tvDescription`, `tvNotes`, `tvBio` |
| `UIImageView` | `img` | `imgAvatar`, `imgBanner`, `imgIcon` |
| `UIStackView` | `st` | `stMain`, `stActions`, `stInfo` |
| `UITableView` | `tb` | `tbFeed`, `tbSettings`, `tbOrders` |
| `UICollectionView` | `cl` | `clBanners`, `clProducts`, `clGrid` |
| `UIButton` | `btn` | `btnSubmit`, `btnCancel`, `btnLogin` |
| `UIView` (container) | `vw` | `vwHeader`, `vwCard`, `vwSeparator` |
| `UIScrollView` | `sv` | `svContent`, `svMain` |
| `UISwitch` | `sw` | `swNotification`, `swDarkMode` |
| `UISlider` | `sl` | `slVolume`, `slBrightness` |
| `UIActivityIndicatorView` | `ai` | `aiLoading` |
| `UIPageControl` | `pc` | `pcBanner`, `pcOnboarding` |

### Vi du - Man hinh Login (LoginVC)

```swift
final class LoginVC: BaseVC<LoginVM> {

    // MARK: - UI Components

    private let imgLogo: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    private let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.largeTitle
        lbl.textColor = AppColor.textPrimary
        return lbl
    }()

    private let lblSubtitle: UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.body
        lbl.textColor = AppColor.textSecondary
        return lbl
    }()

    private let tfEmail: AppTextField = {
        let tf = AppTextField()
        tf.placeholder = L10n.Login.emailPlaceholder
        return tf
    }()

    private let tfPassword: AppTextField = {
        let tf = AppTextField()
        tf.placeholder = L10n.Login.passwordPlaceholder
        tf.isSecureTextEntry = true
        return tf
    }()

    private let stFields: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = AppSpacing.medium
        return st
    }()

    private let btnLogin: AppButton = {
        AppButton(title: L10n.Login.loginButton, style: .primary, size: .large)
    }()

    private let btnForgotPassword: AppButton = {
        AppButton(title: L10n.Login.forgotPassword, style: .ghost, size: .medium)
    }()
}
```

### Vi du - Cell

```swift
final class ProductCell: BaseCollectionCell {
    private let imgThumbnail: UIImageView = { ... }()
    private let lblName: UILabel = { ... }()
    private let lblPrice: UILabel = { ... }()
    private let btnAddToCart: AppButton = { ... }()
}
```

### Vi du - MVVM-C folder (Profile Feature)

```
Features/
  Profile/
    View/         ProfileVC.swift
    ViewModel/    ProfileVM.swift
    Coordinator/  ProfileCoordinator.swift
    Model/        ProfileModel.swift
    Service/      ProfileService.swift
    Components/   ProfileAvatarView.swift
```

```swift
// ProfileVC.swift
final class ProfileVC: BaseVC<ProfileVM> {
    private let imgAvatar: UIImageView = { ... }()
    private let lblName: UILabel = { ... }()
    private let lblBio: UILabel = { ... }()
    private let tbPosts: UITableView = { ... }()   // Dung: co context
    private let btnEdit: AppButton = { ... }()
    private let stHeader: UIStackView = { ... }()
}
```

### Quy tac bat buoc

- **Luon them context name sau prefix**: `lblTitle` khong phai `lbl`.
- **camelCase**: `lblUserName` khong phai `lbl_user_name`.
- **Khong dung type day du**: `titleLabel` → `lblTitle`, `emailTextField` → `tfEmail`.
- Ap dung cho ca **stored property** va **local variable** trong `setupViews()`.

---

## 10. Quy Tac File Header Comment

```swift
//
//  [TenFile].swift
//  SuperApp_PQ
//
//  Created by Phan Quang on [dd/MM/yy].
//
```

| Truong | Quy tac | Vi du |
|---|---|---|
| **Ngay** | `dd/MM/yy` | `22/5/26` |
| **Tac gia** | Ten day du | `Phan Quang` |
| **Ngay tao** | Ngay thuc te tao file | Tu dong theo ngay hien tai |

```swift
// Dung
//
//  HomeVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

// Sai - thieu header, hoac de nguyen ten mac dinh "ViewController.swift"
```

> [!TIP]
> Xcode tu dong dien ngay tao file. Kiem tra ten file trong header khop voi ten file thuc te.
> Ten tac gia lay tu macOS System Settings > Users & Groups > Full Name.
