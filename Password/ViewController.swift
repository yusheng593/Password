//
//  ViewController.swift
//  Password
//
//  Created by yusheng Lu on 2025/1/10.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // 測試使用
    let passwordRules: [(String, Bool)] = [
        ("8-32 characters (no spaces)", false),
        ("uppercase letter (A-Z)", true),
        ("lowercase (a-z)", true),
        ("digit (0-9)", false),
        ("special character (e.g. !@#$%^)", false)
    ]

    private let placeHolderText = "New password"

    private lazy var passwordStackView: UIStackView = {
        let newPasswordTextField = PasswordTextField(placeHolderText: "New password")
        let repeatPasswordTextField = PasswordTextField(placeHolderText: "Repeat password")

        let rulesView = PasswordRulesView(rules: passwordRules)
        rulesView.backgroundColor = .systemGray6

        let stackView = UIStackView(arrangedSubviews: [newPasswordTextField, rulesView, repeatPasswordTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        return button
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
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(passwordStackView)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }

}

