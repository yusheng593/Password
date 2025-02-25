//
//  PasswordRulesView.swift
//  Password
//
//  Created by yusheng Lu on 2025/2/19.
//

import UIKit

class PasswordRulesView: UIView {
    var stackView = UIStackView()

    let rule0 = "8-32 characters (no spaces)"
    let rule1 = "uppercase letter (A-Z)"
    let rule2 = "lowercase (a-z)"
    let rule3 = "digit (0-9)"
    let rule4 = "special character (e.g. !@#$%^)"

    lazy var ruleView0 = PasswordRuleItemView(rule: rule0)
    lazy var ruleView1 = PasswordRuleItemView(rule: rule1)
    lazy var ruleView2 = PasswordRuleItemView(rule: rule2)
    lazy var ruleView3 = PasswordRuleItemView(rule: rule3)
    lazy var ruleView4 = PasswordRuleItemView(rule: rule4)

    override init(frame: CGRect) {
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

        let otherRuleLabel = UILabel()
        otherRuleLabel.textColor = .systemGray
        otherRuleLabel.attributedText = formatRuleText(otherRuleText)
        otherRuleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        otherRuleLabel.numberOfLines = 0
        stackView.addArrangedSubview(otherRuleLabel)



        let ruleViews = [ruleView0, otherRuleLabel, ruleView1, ruleView2, ruleView3, ruleView4]
        ruleViews.forEach {
            stackView.addArrangedSubview($0)
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
