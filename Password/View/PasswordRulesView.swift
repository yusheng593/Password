//
//  PasswordRulesView.swift
//  Password
//
//  Created by yusheng Lu on 2025/2/19.
//

import UIKit

class PasswordRulesView: UIView {
    private var rules:  [(String, Bool)]

    private let stackView = UIStackView()

    init(rules: [(String, Bool)]) {
        self.rules = rules
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing

        let otherRuleText: String = "Use at least 3 of these 4 criteria\nwhen setting your password:"

        if let firstRule = rules.first {
            let firstRuleView = PasswordRuleItemView(rule: firstRule.0, isValid: firstRule.1)
            stackView.addArrangedSubview(firstRuleView)
        }

        let otherRuleLabel = UILabel()
        otherRuleLabel.textColor = .systemGray
        otherRuleLabel.attributedText = formatRuleText(otherRuleText)
        otherRuleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        otherRuleLabel.numberOfLines = 0
        stackView.addArrangedSubview(otherRuleLabel)

        for rule in rules.dropFirst() {
            let ruleView = PasswordRuleItemView(rule: rule.0, isValid: rule.1)
            stackView.addArrangedSubview(ruleView)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.bottom.trailing.equalToSuperview().offset(-8)
        }
    }

    private func formatRuleText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let keyword = "3 of these 4"
        if let range = text.range(of: keyword) {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
        }
        return attributedString
    }
}

class PasswordRuleItemView: UIStackView {
    private let iconImageView = UIImageView()
    private let ruleLabel = UILabel()

    private let checkmarkImage = UIImage(systemName: "checkmark.circle")!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    private let xmarkImage = UIImage(systemName: "xmark.circle")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    private let circleImage = UIImage(systemName: "circle")!.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)

    var isCriteriaMet: Bool = false {
        didSet {
            iconImageView.image = isCriteriaMet ? checkmarkImage : xmarkImage
        }
    }

    init(rule: String, isValid: Bool) {
        super.init(frame: .zero)
        setupView(rule: rule, isValid: isValid)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(rule: String, isValid: Bool) {
        axis = .horizontal
        spacing = 8
        alignment = .leading
        distribution = .fill

//        iconImageView.image = isValid ? checkmarkImage : xmarkImage
//        iconImageView.tintColor = isValid ? .green : .red
        iconImageView.image = circleImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }

        ruleLabel.textColor = .systemGray
        ruleLabel.text = rule
        ruleLabel.font = UIFont.systemFont(ofSize: 16)
        ruleLabel.numberOfLines = 0

        addArrangedSubview(iconImageView)
        addArrangedSubview(ruleLabel)
    }

    func reset() {
        isCriteriaMet = false
        iconImageView.image = circleImage
    }

}
