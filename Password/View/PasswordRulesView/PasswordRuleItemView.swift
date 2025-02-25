//
//  PasswordRuleItemView.swift
//  Password
//
//  Created by yusheng Lu on 2025/2/19.
//

import UIKit

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

    init(rule: String) {
        super.init(frame: .zero)
        setupView(rule: rule)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(rule: String) {
        axis = .horizontal
        spacing = 8
        alignment = .leading
        distribution = .fill

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
