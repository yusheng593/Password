//
//  NewPasswordView.swift
//  Password
//
//  Created by yusheng Lu on 2025/2/17.
//

import UIKit

class PasswordTextField: UIView {
    private var placeHolderText: String

    lazy var newPasswordTextField: UITextField = {
        let textField = UITextField()
        //        textField.delegate = self
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        textField.leftView = createLeftIconView()
        textField.leftViewMode = .always
        textField.rightView = createRightToggleButton()
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [.foregroundColor: UIColor.secondaryLabel])
        return textField
    }()

    lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.8
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .natural
        label.text = "Your password must meet the requirements below."
        return label
    }()


    init(placeHolderText: String) {
        self.placeHolderText = placeHolderText
        super.init(frame: .zero)
        setupUI()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - extension PasswordTextField
extension PasswordTextField {
    private func setupUI() {
        addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }

        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalTo(newPasswordTextField)
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(8)
        }

        addSubview(errorMessageLabel)
        errorMessageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(newPasswordTextField)
            make.top.equalTo(dividerView.snp.bottom).offset(4)
        }
    }

    // MARK: - 左側鎖頭圖示
    private func createLeftIconView() -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: "lock.fill"))
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        containerView.addSubview(iconView)
        return containerView
    }

    // MARK: - 右側密碼顯示/隱藏按鈕
    private func createRightToggleButton() -> UIView {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = .gray
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        newPasswordTextField.isSecureTextEntry.toggle()
        let imageName = newPasswordTextField.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
