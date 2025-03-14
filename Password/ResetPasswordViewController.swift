//
//  ViewController.swift
//  Password
//
//  Created by yusheng Lu on 2025/1/10.
//

import UIKit
import SnapKit

class ResetPasswordViewController: UIViewController {
    private var resetPasswordViewModel = ResetPasswordViewModel()
    private var alert: UIAlertController?
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
        setupTapGesture()
    }

    private func setupUI() {
        view.addSubview(passwordStackView)
        passwordStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func updateResetButtonState() {
        if resetPasswordViewModel.isButtonCanUse() {
            resetButton.isEnabled = true
            resetButton.backgroundColor = .systemBlue
        } else {
            resetButton.isEnabled = false
            resetButton.backgroundColor = .systemGray
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: string)
            if textField == newPasswordView.passwordTextField {

                let validationResults = resetPasswordViewModel.validatePassword(newText)

                rulesView.ruleView0.isCriteriaMet = validationResults[0]
                rulesView.ruleView1.isCriteriaMet = validationResults[1]
                rulesView.ruleView2.isCriteriaMet = validationResults[2]
                rulesView.ruleView3.isCriteriaMet = validationResults[3]
                rulesView.ruleView4.isCriteriaMet = validationResults[4]

                let repeatPassword = repeatPasswordView.passwordTextField.text ?? ""
                resetPasswordViewModel.validatePasswords(newPassword: newText, repeatPassword: repeatPassword)

                if newText.isEmpty {
                    rulesView.ruleView0.reset()
                    rulesView.ruleView1.reset()
                    rulesView.ruleView2.reset()
                    rulesView.ruleView3.reset()
                    rulesView.ruleView4.reset()
                }

                if validationResults.allSatisfy({ $0 }) {
                    newPasswordView.errorMessageLabel.isHidden = true
                }

                updateResetButtonState()

            } else if textField == repeatPasswordView.passwordTextField {
                let newPassword = newPasswordView.passwordTextField.text ?? ""

                resetPasswordViewModel.validatePasswords(newPassword: newPassword, repeatPassword: newText)

                if newPassword != newText {
                    repeatPasswordView.errorMessageLabel.isHidden = false
                    repeatPasswordView.errorMessageLabel.text = "Password does not match."
                } else {
                    repeatPasswordView.errorMessageLabel.isHidden = true
                }

                updateResetButtonState()

            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldEndEditing(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldEndEditing(textField)
        textField.resignFirstResponder()
        return true
    }

    private func textFieldEndEditing(_ textField: UITextField) {
        if textField == newPasswordView.passwordTextField {
            let password = textField.text ?? ""
            let validationResults = resetPasswordViewModel.validatePassword(password)
            let isValid = validationResults.allSatisfy { $0 }

            newPasswordView.errorMessageLabel.isHidden = isValid

            if isValid {
                newPasswordView.errorMessageLabel.text = nil
            } else {
                newPasswordView.errorMessageLabel.text = "Your password must meet the requirements below."
            }
        }
    }
}
//MARK: - Actions
extension ResetPasswordViewController {
    @objc private func resetButtonTapped() {
        showAlert(title: "Success", message: "You have successfully changed your password.")
    }

    private func showAlert(title: String, message: String) {
        self.alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        guard let alert = self.alert else { return }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        alert.title = title
        alert.message = message
        present(alert, animated: true, completion: nil)
    }
}
//MARK: - testable extension
extension ResetPasswordViewController {
    var testableViewModel: ResetPasswordViewModel {
        get {
            return resetPasswordViewModel
        }
        set {
            resetPasswordViewModel = newValue
        }
    }

    var testableNewPassword: PasswordTextField {
        return newPasswordView
    }

    var testableRepeatPassword: PasswordTextField {
        return repeatPasswordView
    }

    func testableTextFieldEndEditing(_ textField: UITextField) {
        textFieldEndEditing(textField)
    }

    func testableUpdateResetButtonState() {
        updateResetButtonState()
    }

    var testableResetButton: UIButton {
        return self.resetButton
    }

    @objc func testableResetButtonTapped() {
        resetButtonTapped()
    }

    var testableAlert: UIAlertController? {
        return self.alert
    }
}
