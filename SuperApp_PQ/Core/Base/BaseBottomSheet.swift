//
//  BaseBottomSheet.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import UIKit
import SnapKit
import RxSwift

// MARK: - BaseBottomSheet

/// A reusable bottom sheet base view controller.
///
/// Features:
/// - Dimmed backdrop with tap-to-dismiss
/// - Pan gesture to drag-dismiss
/// - Dynamic content height via `preferredContentHeight`
/// - Spring entry animation / slide-out exit animation
///
/// Usage:
/// ```swift
/// final class ConfirmSheet: BaseBottomSheet {
///     override var preferredContentHeight: CGFloat { 300 }
///
///     override func setupContent() {
///         let label = UILabel.make(text: "Xác nhận?", font: AppFont.bodyMedium)
///         contentView.addSubview(label)
///         label.snp.makeConstraints { $0.center.equalToSuperview() }
///     }
/// }
///
/// // Present:
/// let sheet = ConfirmSheet()
/// sheet.modalPresentationStyle = .overFullScreen
/// present(sheet, animated: false)
/// ```
class BaseBottomSheet: UIViewController {

    // MARK: - Constants

    private enum Metric {
        static let cornerRadius: CGFloat       = 20
        static let handleHeight: CGFloat       = 4
        static let handleWidth: CGFloat        = 40
        static let handleTopPadding: CGFloat   = 8
        static let animationDuration: TimeInterval = 0.35
        static let dimAlpha: CGFloat           = 0.5
        static let dragDismissRatio: CGFloat   = 0.35  // dismiss if dragged > 35% of sheet height
    }

    // MARK: - Properties

    let disposeBag = DisposeBag()

    /// Override this in subclass to set the content height.
    var preferredContentHeight: CGFloat { 300 }

    /// Whether a tap on the dimmed area dismisses the sheet.
    var isDismissibleByBackdrop: Bool { true }

    /// Whether a downward pan gesture can dismiss the sheet.
    var isDismissibleByPan: Bool { true }

    // MARK: - UI

    private let backdropView: UIView = {
        let view                     = UIView()
        view.backgroundColor         = UIColor.black.withAlphaComponent(0)
        return view
    }()

    let contentView: UIView = {
        let view                     = UIView()
        view.backgroundColor         = AppColor.surface
        view.layer.cornerRadius      = Metric.cornerRadius
        view.layer.maskedCorners     = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds     = true
        return view
    }()

    private let handleView: UIView = {
        let view                     = UIView()
        view.backgroundColor         = AppColor.border
        view.layer.cornerRadius      = Metric.handleHeight / 2
        return view
    }()

    // MARK: - Pan state

    private var contentViewBottomConstraint: Constraint?
    private var initialTranslationY: CGFloat = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        setupGestures()
        setupContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubviews(backdropView, contentView)
        contentView.addSubview(handleView)

        backdropView.snp.makeConstraints { $0.edges.equalToSuperview() }

        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            contentViewBottomConstraint = make.bottom.equalToSuperview().offset(preferredContentHeight).constraint
            make.height.equalTo(preferredContentHeight + 40) // + bottom safe area buffer
        }

        handleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.handleTopPadding)
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.handleWidth)
            make.height.equalTo(Metric.handleHeight)
        }
    }

    private func setupGestures() {
        if isDismissibleByBackdrop {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleBackdropTap))
            backdropView.addGestureRecognizer(tap)
        }

        if isDismissibleByPan {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            contentView.addGestureRecognizer(pan)
        }
    }

    // MARK: - Override in subclass

    /// Override to add your content views into `contentView`.
    func setupContent() {}

    // MARK: - Animation

    private func animateIn() {
        view.layoutIfNeeded()
        contentViewBottomConstraint?.update(offset: 0)
        UIView.animate(
            withDuration: Metric.animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.backdropView.backgroundColor = UIColor.black.withAlphaComponent(Metric.dimAlpha)
            self.view.layoutIfNeeded()
        }
    }

    func animateOut(completion: (() -> Void)? = nil) {
        contentViewBottomConstraint?.update(offset: preferredContentHeight)
        UIView.animate(
            withDuration: Metric.animationDuration,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.backdropView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }

    // MARK: - Gesture Handlers

    @objc private func handleBackdropTap() {
        animateOut()
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .began:
            initialTranslationY = 0

        case .changed:
            let delta = max(0, translation.y)    // only downward
            contentViewBottomConstraint?.update(offset: delta)
            let progress = delta / preferredContentHeight
            let alpha = Metric.dimAlpha * (1 - progress)
            backdropView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            view.layoutIfNeeded()

        case .ended, .cancelled:
            let velocity = gesture.velocity(in: view).y
            let offset   = max(0, translation.y)
            let shouldDismiss = offset > preferredContentHeight * Metric.dragDismissRatio || velocity > 800

            if shouldDismiss {
                animateOut()
            } else {
                // Snap back
                contentViewBottomConstraint?.update(offset: 0)
                UIView.animate(withDuration: 0.25) {
                    self.backdropView.backgroundColor = UIColor.black.withAlphaComponent(Metric.dimAlpha)
                    self.view.layoutIfNeeded()
                }
            }

        default:
            break
        }
    }
}
