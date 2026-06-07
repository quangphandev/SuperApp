//
//  UITextField+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import UIKit

// MARK: - Padding

extension UITextField {

    /// Adds symmetric horizontal padding inside the text field.
    ///
    /// Usage: `emailTextField.addPadding(left: 16, right: 16)`
    func addPadding(left: CGFloat = 0, right: CGFloat = 0) {
        if left > 0 {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.height))
            leftViewMode = .always
        }
        if right > 0 {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: frame.height))
            rightViewMode = .always
        }
    }
}

// MARK: - Placeholder Styling

extension UITextField {

    /// Sets the placeholder text with a custom color.
    ///
    /// Usage: `field.setPlaceholderColor(AppColor.textSecondary)`
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: color]
        )
    }

    /// Sets both placeholder text and color at once.
    func setPlaceholder(_ text: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: color]
        )
    }
}

// MARK: - Left Icon

extension UITextField {

    /// Adds an icon to the left side of the text field with padding.
    ///
    /// Usage: `emailField.setLeftIcon(UIImage(systemName: "envelope"), padding: 12)`
    func setLeftIcon(_ image: UIImage?, padding: CGFloat = 12, tintColor: UIColor = .secondaryLabel) {
        guard let image else {
            leftView = nil
            leftViewMode = .never
            return
        }

        let containerWidth = image.size.width + padding * 2
        let container      = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: frame.height))

        let imageView         = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor   = tintColor
        imageView.contentMode = .scaleAspectFit
        imageView.frame       = CGRect(
            x: padding,
            y: (frame.height - image.size.height) / 2,
            width: image.size.width,
            height: image.size.height
        )
        container.addSubview(imageView)

        leftView     = container
        leftViewMode = .always
    }

    /// Adds an icon to the right side of the text field.
    func setRightIcon(_ image: UIImage?, padding: CGFloat = 12, tintColor: UIColor = .secondaryLabel) {
        guard let image else {
            rightView = nil
            rightViewMode = .never
            return
        }

        let containerWidth = image.size.width + padding * 2
        let container      = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: frame.height))

        let imageView         = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor   = tintColor
        imageView.contentMode = .scaleAspectFit
        imageView.frame       = CGRect(
            x: padding,
            y: (frame.height - image.size.height) / 2,
            width: image.size.width,
            height: image.size.height
        )
        container.addSubview(imageView)

        rightView     = container
        rightViewMode = .always
    }
}

// MARK: - Done / Toolbar

extension UITextField {

    /// Adds a toolbar with a Done button above the keyboard.
    /// Tapping Done dismisses the keyboard.
    ///
    /// Usage: `amountField.addDoneButton(title: "Xong")`
    func addDoneButton(title: String = "Xong", tintColor: UIColor = .systemBlue) {
        let toolbar    = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexible   = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: #selector(_doneButtonTapped)
        )
        doneButton.tintColor = tintColor
        toolbar.items        = [flexible, doneButton]
        toolbar.sizeToFit()
        inputAccessoryView   = toolbar
    }

    @objc private func _doneButtonTapped() {
        resignFirstResponder()
    }
}

// MARK: - Password Toggle

extension UITextField {

    /// Adds a show/hide password toggle button on the right side.
    /// Only meaningful when `isSecureTextEntry = true`.
    func addPasswordToggle(
        showImage: UIImage? = UIImage(systemName: "eye"),
        hideImage: UIImage? = UIImage(systemName: "eye.slash"),
        tintColor: UIColor = .secondaryLabel
    ) {
        let button         = UIButton(type: .custom)
        button.frame       = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor   = tintColor
        button.setImage(showImage, for: .normal)
        button.setImage(hideImage, for: .selected)
        button.addTarget(self, action: #selector(_togglePassword(_:)), for: .touchUpInside)

        let container      = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.center      = CGPoint(x: 22, y: 22)
        container.addSubview(button)

        rightView          = container
        rightViewMode      = .always
    }

    @objc private func _togglePassword(_ sender: UIButton) {
        sender.isSelected  = !sender.isSelected
        isSecureTextEntry  = !isSecureTextEntry

        // Workaround: cursor resets on iOS when toggling secure entry
        if let text {
            self.text = ""
            self.text = text
        }
    }
}
