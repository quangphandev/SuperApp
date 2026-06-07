//
//  UILabel+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import UIKit

// MARK: - Line Height

extension UILabel {

    /// Sets the paragraph line height multiple.
    /// Common design values: 1.3 (tight), 1.5 (body), 1.7 (spacious).
    ///
    /// Usage: `titleLabel.setLineHeight(1.5)`
    func setLineHeight(_ multiple: CGFloat) {
        guard let text else { return }
        let style                      = NSMutableParagraphStyle()
        style.lineHeightMultiple       = multiple
        style.alignment                = textAlignment
        style.lineBreakMode            = lineBreakMode
        attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: style,
                .font:           font as Any,
                .foregroundColor: textColor as Any
            ]
        )
    }

    /// Sets the paragraph line spacing in points.
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text else { return }
        let style               = NSMutableParagraphStyle()
        style.lineSpacing       = spacing
        style.alignment         = textAlignment
        style.lineBreakMode     = lineBreakMode
        attributedText = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: style,
                .font:           font as Any,
                .foregroundColor: textColor as Any
            ]
        )
    }
}

// MARK: - Letter Spacing

extension UILabel {

    /// Sets the character spacing (kern) in points.
    /// Positive values spread characters apart; negative values pull them together.
    ///
    /// Usage: `titleLabel.setLetterSpacing(0.5)`
    func setLetterSpacing(_ spacing: CGFloat) {
        guard let text else { return }
        let existing = attributedText?.attributes(at: 0, effectiveRange: nil) ?? [:]
        var attrs: [NSAttributedString.Key: Any] = existing
        attrs[.kern] = spacing
        attributedText = NSAttributedString(string: text, attributes: attrs)
    }
}

// MARK: - Attributed Helpers

extension UILabel {

    /// Sets text with mixed fonts / colors using a builder closure.
    ///
    /// Usage:
    /// ```swift
    /// label.setAttributed {
    ///     $0.append("Bạn có ", font: .systemFont(ofSize: 14), color: .label)
    ///     $0.append("3 tin nhắn", font: .boldSystemFont(ofSize: 14), color: AppColor.accent)
    /// }
    /// ```
    func setAttributed(_ builder: (NSMutableAttributedString) -> Void) {
        let result = NSMutableAttributedString()
        builder(result)
        attributedText = result
    }
}

extension NSMutableAttributedString {

    /// Appends a string segment with the given font and color.
    @discardableResult
    func append(
        _ string: String,
        font: UIFont,
        color: UIColor = .label,
        kern: CGFloat = 0
    ) -> NSMutableAttributedString {
        var attrs: [NSAttributedString.Key: Any] = [
            .font:            font,
            .foregroundColor: color
        ]
        if kern != 0 { attrs[.kern] = kern }
        append(NSAttributedString(string: string, attributes: attrs))
        return self
    }
}

// MARK: - Convenience Factory

extension UILabel {

    /// Creates a label with common styling in one call.
    ///
    /// Usage:
    /// ```swift
    /// let label = UILabel.make(text: "Hello", font: AppFont.body, color: AppColor.textPrimary, lines: 2)
    /// ```
    static func make(
        text: String? = nil,
        font: UIFont,
        color: UIColor = .label,
        alignment: NSTextAlignment = .left,
        lines: Int = 1
    ) -> UILabel {
        let label           = UILabel()
        label.text          = text
        label.font          = font
        label.textColor     = color
        label.textAlignment = alignment
        label.numberOfLines = lines
        return label
    }
}
