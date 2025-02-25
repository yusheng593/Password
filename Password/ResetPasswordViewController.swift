//
//  ViewController.swift
//  Password
//
//  Created by yusheng Lu on 2025/1/10.
//

import UIKit
import SnapKit

class ResetPasswordViewController: UIViewController {
    private let placeHolderText = "New password"

    private lazy var newPasswordView: PasswordTextField = {
        let view = PasswordTextField(placeHolderText: "New password")
        view.passwordTextField.delegate = self
        return view
    }()

    private lazy var repeatPasswordView: PasswordTextField = {
        let view = PasswordTextField(placeHolderText: "Repeat password")
        view.passwordTextField.delegate = self
        return view
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var rulesView: PasswordRulesView = {
        let view = PasswordRulesView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newPasswordView, rulesView, repeatPasswordView, resetButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
    }

    private func setupUI() {
        view.addSubview(passwordStackView)
        passwordStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    @objc private func resetButtonTapped() {
        print("Reset button tapped")
    }

    private func updateResetButtonState() {
        if ResetPasswordViewModel.isButtonCanUse() {
            resetButton.isEnabled = true
            resetButton.backgroundColor = .systemBlue
        } else {
            resetButton.isEnabled = false
            resetButton.backgroundColor = .systemGray
        }
    }

}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: string)
            if textField == newPasswordView.passwordTextField {

                let validationResults = ResetPasswordViewModel.validatePassword(newText)

                rulesView.ruleView0.isCriteriaMet = validationResults[0]
                rulesView.ruleView1.isCriteriaMet = validationResults[1]
                rulesView.ruleView2.isCriteriaMet = validationResults[2]
                rulesView.ruleView3.isCriteriaMet = validationResults[3]
                rulesView.ruleView4.isCriteriaMet = validationResults[4]

                let repeatPassword = repeatPasswordView.passwordTextField.text ?? ""
                ResetPasswordViewModel.validatePasswords(newPassword: newText, repeatPassword: repeatPassword)

                if newText.isEmpty {
                    rulesView.ruleView0.reset()
                    rulesView.ruleView1.reset()
                    rulesView.ruleView2.reset()
                    rulesView.ruleView3.reset()
                    rulesView.ruleView4.reset()
                }

                updateResetButtonState()

            } else if textField == repeatPasswordView.passwordTextField {
                let newPassword = newPasswordView.passwordTextField.text ?? ""

                ResetPasswordViewModel.validatePasswords(newPassword: newPassword, repeatPassword: newText)

                if newPassword != newText {
                    repeatPasswordView.errorMessageLabel.isHidden = false
                } else {
                    repeatPasswordView.errorMessageLabel.isHidden = true
                }

                updateResetButtonState()

            }
        }
        return true
    }
}
