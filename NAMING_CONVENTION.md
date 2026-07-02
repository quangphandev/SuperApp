# 📐 Bộ Quy Tắc Đặt Tên (Naming Convention) — SuperApp_PQ

> Tài liệu này định nghĩa bộ quy tắc đặt tên file, class, và thư mục cho toàn bộ dự án iOS `SuperApp_PQ`.
> Mục tiêu: nhất quán, rõ ràng, dễ đọc, dễ tìm kiếm và tuân thủ chặt chẽ Swift API Design Guidelines.

---

## 1. Bảng Viết Tắt & Hậu Tố Chuẩn (Abbreviation & Suffix Table)

| Từ đầy đủ | Viết tắt / Hậu tố | Ví dụ |
|---|---|---|
| `ViewController` | `ViewController` (không viết tắt) | `HomeViewController`, `LoginViewController` |
| `ViewModel` | `ViewModel` (không viết tắt) | `HomeViewModel`, `LoginViewModel` |
| `View` | `View` | `AvatarView`, `CardView` |
| `Model` | `Model` | `UserModel`, `ProductModel` |
| `Manager` | `Manager` | `AuthManager`, `CacheManager` |
| `Service` | `Service` | `UserService`, `PaymentService` |
| `Repository` | `Repository` | `UserRepository`, `OrderRepository` |
| `Coordinator` | `Coordinator` | `AppCoordinator`, `HomeCoordinator` |
| `Router` | `Router` | `HomeRouter`, `AppRouter` |
| `UITableViewCell` | `TableViewCell` | `ProductTableViewCell`, `UserTableViewCell` |
| `UICollectionViewCell` | `CollectionViewCell` | `ProductCollectionViewCell`, `UserCollectionViewCell` |
| `Header` (section header) | `HeaderView` | `CartHeaderView`, `OrderHeaderView` |
| `Footer` (section footer) | `FooterView` | `CartFooterView` |
| `Configuration` | `Config` | `AppConfig`, `NetworkConfig` |
| `Extension` | `+` (suffix trong tên file) | `UIView+Shadow.swift` |
| `Protocol` | `Protocol` | `UserRepositoryProtocol` |
| `Enum` | `Type` hoặc tên rõ ràng | `OrderStatusType`, `PaymentMethod` |
| `Builder` | `Builder` | `AlertBuilder`, `RequestBuilder` |
| `Handler` | `Handler` | `DeepLinkHandler`, `ErrorHandler` |
| `Helper` | `Helper` | `DateHelper`, `StringHelper` |
| `Constant` | `Constant` | `AppConstant`, `APIConstant` |

---

## 2. Quy Tắc Đặt Tên File

Format chung: `[Tên chức năng] + [Loại file]`

| File | Không dùng | Nên dùng |
|---|---|---|
| View Controller | `HomeVC.swift` | `HomeViewController.swift` |
| ViewModel | `HomeVM.swift` | `HomeViewModel.swift` |
| Custom View | `CustomAvatarView.swift` | `AvatarView.swift` |
| Table Cell | `ProductCell.swift`, `ProductVC.swift` | `ProductTableViewCell.swift` |
| Collection Cell | `ProductCell.swift` | `ProductCollectionViewCell.swift` |
| Repository | `UserRepo.swift` | `UserRepository.swift` |
| Config | `NetworkConfiguration.swift` | `NetworkConfig.swift` |
| Extension | `UIViewExtension.swift` | `UIView+Shadow.swift` |

---

## 3. Quy Tắc Đặt Tên Class / Struct / Enum

Format: `[Tên chức năng][Viết rõ loại]` (PascalCase)

```swift
// Đúng
class HomeViewController: UIViewController { }
class HomeViewModel { }
struct UserModel { }
class ProductTableViewCell: UITableViewCell { }

// Sai
class HomeVC: UIViewController { }
class HomeVM { }
class ProductCell: UITableViewCell { }
class ProductTableViewCell: UITableViewCell { }
```

---

## 4. Cấu Trúc Thư Mục (SuperApp_PQ)

```
SuperApp_PQ/
  Features/
    Home/
      View/         HomeViewController.swift
      ViewModel/    HomeViewModel.swift
      Coordinator/  HomeCoordinator.swift
      Model/        HomeFeatureItem.swift
      Service/      HomeService.swift
      Components/   HomeFeatureView.swift
  Core/
    Base/           BaseViewController, BaseViewModel, BaseTableViewController, ...
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

## 5. Quy Tắc Đặt Tên Extension (File)

Format: `[Class gốc]+[Chức năng].swift`

```
UIView+Shadow.swift
UIColor+Palette.swift
String+Validate.swift
Date+Format.swift
```

---

## 6. Quy Tắc Đặt Tên Protocol

```swift
// Hậu tố Protocol (cho abstraction layer lớn)
protocol UserRepositoryProtocol { }
protocol HomeCoordinating { }

// Hậu tố -able (delegate / utility)
protocol Loadable { }
protocol Bindable { }
protocol Reusable { }
```

---

## 7. Quy Tắc Đặt Tên Enum

Format: `[Tên chức năng]Type` hoặc `[Tên chức năng]State`

```swift
enum OrderStatusType { case pending, processing, completed, cancelled }
enum PaymentMethod { case credit, debit, eWallet }
enum HomeState { case loading, loaded, error }
```

---

## 8. Quy Tắc Bổ Sung

- **PascalCase** cho file, class, struct, enum, protocol.
- **camelCase** cho biến, hàm, property.
- **Không dùng prefix** kiểu Objective-C (`PQ`, `SA`...).
- **Không viết tắt tên nghiệp vụ hay loại file chính** (VC $\rightarrow$ ViewController, VM $\rightarrow$ ViewModel).
- Tên phải diễn đạt đúng chức năng: `ProductListViewController` không phải `ListViewController`.

---

## 9. Quy Tắc Đặt Tên UI Component (Property Suffix)

Khi khai báo UI component là property của ViewController, View, hoặc Cell, **bắt buộc** dùng hậu tố là tên loại Component đầy đủ (camelCase):

| UIKit Class | Hậu tố | Ví dụ |
|---|---|---|
| `UILabel` | `Label` | `titleLabel`, `subtitleLabel`, `priceLabel` |
| `UITextField` | `TextField` | `emailTextField`, `passwordTextField`, `searchTextField` |
| `UITextView` | `TextView` | `descriptionTextView`, `notesTextView`, `bioTextView` |
| `UIImageView` | `ImageView` | `avatarImageView`, `bannerImageView`, `iconImageView` |
| `UIStackView` | `StackView` | `mainStackView`, `actionsStackView`, `infoStackView` |
| `UITableView` | `TableView` | `feedTableView`, `settingsTableView`, `ordersTableView` |
| `UICollectionView` | `CollectionView` | `bannersCollectionView`, `productsCollectionView` |
| `UIButton` | `Button` | `submitButton`, `cancelButton`, `loginButton` |
| `UIView` (container) | `View` | `headerView`, `cardView`, `separatorView` |
| `UIScrollView` | `ScrollView` | `contentScrollView`, `mainScrollView` |
| `UISwitch` | `Switch` | `notificationSwitch`, `darkModeSwitch` |
| `UISlider` | `Slider` | `volumeSlider`, `brightnessSlider` |
| `UIActivityIndicatorView` | `ActivityIndicator` | `loadingActivityIndicator` |
| `UIPageControl` | `PageControl` | `bannerPageControl`, `onboardingPageControl` |

### Ví dụ - Màn hình Login (LoginViewController)

```swift
final class LoginViewController: BaseViewController<LoginViewModel> {

    // MARK: - UI Components

    private let logoImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.largeTitle
        lbl.textColor = AppColor.textPrimary
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = AppFont.body
        lbl.textColor = AppColor.textSecondary
        return lbl
    }()

    private let emailTextField: AppTextField = {
        let tf = AppTextField()
        tf.placeholder = L10n.Login.emailPlaceholder
        return tf
    }()

    private let passwordTextField: AppTextField = {
        let tf = AppTextField()
        tf.placeholder = L10n.Login.passwordPlaceholder
        tf.isSecureTextEntry = true
        return tf
    }()

    private let fieldsStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = AppSpacing.medium
        return st
    }()

    private let loginButton: AppButton = {
        AppButton(title: L10n.Login.loginButton, style: .primary, size: .large)
    }()

    private let forgotPasswordButton: AppButton = {
        AppButton(title: L10n.Login.forgotPassword, style: .ghost, size: .medium)
    }()
}
```

### Ví dụ - Cell

```swift
final class ProductCollectionViewCell: BaseCollectionCell {
    private let thumbnailImageView: UIImageView = { ... }()
    private let nameLabel: UILabel = { ... }()
    private let priceLabel: UILabel = { ... }()
    private let addToCartButton: AppButton = { ... }()
}
```

### Ví dụ - MVVM-C folder (Profile Feature)

```
Features/
  Profile/
    View/         ProfileViewController.swift
    ViewModel/    ProfileViewModel.swift
    Coordinator/  ProfileCoordinator.swift
    Model/        ProfileModel.swift
    Service/      ProfileService.swift
    Components/   ProfileAvatarView.swift
```

```swift
// ProfileViewController.swift
final class ProfileViewController: BaseViewController<ProfileViewModel> {
    private let avatarImageView: UIImageView = { ... }()
    private let nameLabel: UILabel = { ... }()
    private let bioLabel: UILabel = { ... }()
    private let postsTableView: UITableView = { ... }()
    private let editButton: AppButton = { ... }()
    private let headerStackView: UIStackView = { ... }()
}
```

### Quy tắc bắt buộc

- **Luôn thêm hậu tố đầy đủ**: `titleLabel` không phải `title`, `loginButton` không phải `login`.
- **camelCase**: `userNameLabel` không phải `user_name_label`.
- **Không viết tắt**: `titleLabel` $\rightarrow$ không dùng `titleLbl`, `emailTextField` $\rightarrow$ không dùng `emailTF`.
- Áp dụng cho cả **stored property** và **local variable** trong `setupViews()`.

---

## 10. Quy Tắc File Header Comment

```swift
//
//  [TenFile].swift
//  SuperApp_PQ
//
//  Created by Phan Quang on [dd/MM/yy].
//
```

| Trường | Quy tắc | Ví dụ |
|---|---|---|
| **Ngày** | `dd/MM/yy` | `22/05/26` |
| **Tác giả** | Tên đầy đủ | `Phan Quang` |
| **Ngày tạo** | Ngày thực tế tạo file | Tự động theo ngày hiện tại |

```swift
// Đúng
//
//  HomeViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/05/26.
//
```
