//
//  HeaderView.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 10.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class HeaderView: CustomView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let height: CGFloat = 69
    }
    
    // MARK: - Subviews
    
    private let stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        return $0
    }(UIStackView())
    
    private let titleLabel: UILabel = {
        $0.textColor = .secondaryTextColor
        $0.font = .header
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.textColor = .secondaryTextColor
        $0.font = .description
        return $0
    }(UILabel())
    
    // MARK: - Lifecycle
    
    override func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    override func setupSubviews() {
        backgroundColor = .secondaryBackgroundColor
    }
    
    override func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(.doubleOffset)
            $0.bottom.equalToSuperview().inset(.quadripleOffset)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.height)
        }
    }
    
    // MARK: - Internal Methods
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func update(description: String) {
        descriptionLabel.text = description
    }
}
