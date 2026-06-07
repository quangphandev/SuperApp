//
//  AppBadgeView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import SnapKit
import UIKit

/// A badge overlay for count or dot notifications.
///
/// Modes:
/// - `.count(Int)` — shows a number (99+ capped). Badge disappears at 0.
/// - `.dot`        — shows a small solid dot (no number)
///
/// Usage:
/// ```swift
/// let badge = AppBadgeView()
/// badge.apply(to: messageButton)        // auto-pins to top-right corner
/// badge.setValue(.count(3))             // shows "3"
/// badge.setValue(.count(150))           // shows "99+"
/// badge.setValue(.count(0))             // hides badge
/// badge.setValue(.dot)                  // shows red dot
/// ```
final class AppBadgeView: UIView {

    // MARK: - Value

    enum Value {
        case count(Int)
        case dot
    }

    // MARK: - Constants

    private enum Metric {
        static let badgeSize: CGFloat = 18
        static let dotSize:   CGFloat = 10
        static let cornerInset: CGFloat = -4
        static let maxCount = 99
    }

    // MARK: - UI

    private let countLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.8
        return l
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor  = AppColor.error
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.systemBackground.cgColor
        addSubview(countLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        countLabel.frame   = bounds.insetBy(dx: 2, dy: 1)
    }

    // MARK: - API

    /// Updates the badge value with optional animation.
    func setValue(_ value: Value, animated: Bool = true) {
        let updateBlock = {
            switch value {
            case .count(let count):
                if count <= 0 {
                    self.isHidden = true
                    return
                }
                self.isHidden    = false
                let text         = count > Metric.maxCount ? "99+" : "\(count)"
                self.countLabel.text = text
                self.countLabel.isHidden = false

                // Dynamic width for multi-digit counts
                let isSingleDigit = count < 10
                let size: CGFloat = isSingleDigit ? Metric.badgeSize : Metric.badgeSize + CGFloat(text.count - 1) * 5
                self.snp.updateConstraints { make in
                    make.width.equalTo(size)
                }

            case .dot:
                self.isHidden        = false
                self.countLabel.isHidden = true
                self.snp.updateConstraints { make in
                    make.width.equalTo(Metric.dotSize)
                }
            }
        }

        if animated {
            UIView.animate(
                withDuration: 0.25,
                delay: 0,
                usingSpringWithDamping: 0.65,
                initialSpringVelocity: 0.8
            ) {
                updateBlock()
                self.superview?.layoutIfNeeded()
            }
        } else {
            updateBlock()
        }
    }

    /// Pins the badge to the top-right corner of `targetView`.
    /// Adds the badge as a sibling in `targetView.superview` with proper constraints.
    ///
    /// - Parameter offset: How far to inset into the corner (default: 4pt inward)
    func apply(to targetView: UIView, offset: CGFloat = Metric.cornerInset) {
        guard let parent = targetView.superview else { return }
        parent.addSubview(self)
        isHidden = true

        snp.makeConstraints { make in
            make.height.equalTo(Metric.badgeSize)
            make.width.equalTo(Metric.badgeSize)
            make.top.equalTo(targetView.snp.top).offset(offset)
            make.trailing.equalTo(targetView.snp.trailing).offset(-offset)
        }
    }
}
