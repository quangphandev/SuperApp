//
//  AppDivider.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import SnapKit
import UIKit

/// A thin separator line, optionally with a centered label.
///
/// Usage:
/// ```swift
/// // Simple horizontal line
/// let divider = AppDivider()
///
/// // With label (e.g. login screen "Hoặc đăng nhập bằng")
/// let divider = AppDivider(label: "Hoặc")
///
/// // Vertical divider
/// let vDivider = AppDivider(axis: .vertical)
/// ```
final class AppDivider: UIView {

    // MARK: - Properties

    private let axis:  NSLayoutConstraint.Axis
    private let label: String?

    // MARK: - Init

    init(
        axis:  NSLayoutConstraint.Axis = .horizontal,
        label: String? = nil,
        color: UIColor = UIColor.separator,
        thickness: CGFloat = 0.5
    ) {
        self.axis  = axis
        self.label = label
        super.init(frame: .zero)
        setupViews(color: color, thickness: thickness)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupViews(color: UIColor, thickness: CGFloat) {
        if let text = label, axis == .horizontal {
            setupWithLabel(text, lineColor: color, thickness: thickness)
        } else {
            setupSimple(color: color, thickness: thickness)
        }
    }

    private func setupSimple(color: UIColor, thickness: CGFloat) {
        backgroundColor = color
        if axis == .horizontal {
            snp.makeConstraints { make in make.height.equalTo(thickness) }
        } else {
            snp.makeConstraints { make in make.width.equalTo(thickness) }
        }
    }

    private func setupWithLabel(_ text: String, lineColor: UIColor, thickness: CGFloat) {
        let leftLine  = makeLine(color: lineColor, thickness: thickness)
        let rightLine = makeLine(color: lineColor, thickness: thickness)

        let label           = UILabel()
        label.text          = text
        label.font          = AppFont.caption
        label.textColor     = AppColor.textSecondary
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [leftLine, label, rightLine])
        stack.axis      = .horizontal
        stack.spacing   = AppSpacing.medium
        stack.alignment = .center

        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview() }

        leftLine.snp.makeConstraints { make in
            make.height.equalTo(thickness)
        }
        rightLine.snp.makeConstraints { make in
            make.height.equalTo(thickness)
            make.width.equalTo(leftLine.snp.width)
        }
    }

    private func makeLine(color: UIColor, thickness: CGFloat) -> UIView {
        let v = UIView()
        v.backgroundColor = color
        return v
    }
}
