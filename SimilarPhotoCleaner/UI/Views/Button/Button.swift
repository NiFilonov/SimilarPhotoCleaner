//
//  Button.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 22.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class Button: UIButton {
    
    // MARK: - Constants
    
    private enum Constants {
        static let height: CGFloat = 60
        static let iconSize: CGFloat = 20
        static let normalBackgroundColor: UIColor = .buttonColor
        static let selectedBackgroundColor: UIColor = .buttonColor.withAlphaComponent(0.7)
        static let disabledBackgroundColor: UIColor = .systemGray
        static let highlightAlpha: CGFloat = 0.7
        static let baseAlpha: CGFloat = 1.0
    }
    
    // MARK: - Subviews
    
    private let iconImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .buttonTextColor
        $0.isUserInteractionEnabled = false
        return $0
    }(UIImageView())
    
    private let titleTextLabel: UILabel = {
        $0.textColor = .buttonTextColor
        $0.font = .textButton
        $0.isUserInteractionEnabled = false
        return $0
    }(UILabel())
    
    private let containerView: UIView = {
        $0.isUserInteractionEnabled = false
        return $0
    }(UIView())
    
    // MARK: - Internal Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: .zero, height: Constants.height)
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: .small) {
                self.updateAppearance()
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: .small) {
                self.updateAppearance()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: .small) {
                self.updateAppearance()
            }
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Internal Methods
    
    func configure(title: String, icon: UIImage? = nil) {
        titleTextLabel.text = title
        iconImageView.image = icon
        iconImageView.isHidden = icon == nil
        updateAppearance()
        reloadConstraints()
    }
    
    func set(title: String) {
        titleTextLabel.text = title
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        layer.roundedCornersButton()
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleTextLabel)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.leading.greaterThanOrEqualToSuperview().offset(.offset)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(Constants.iconSize)
        }
        
        titleTextLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(.offset)
            $0.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func reloadConstraints() {
        if iconImageView.isHidden {
            titleTextLabel.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.bottom.equalToSuperview()
            }
        } else {
            titleTextLabel.snp.remakeConstraints {
                $0.leading.equalTo(iconImageView.snp.trailing).offset(.offset)
                $0.trailing.equalToSuperview()
                $0.top.bottom.equalToSuperview()
            }
        }
    }
    
    private func updateAppearance() {
        backgroundColor = isEnabled ?
        (isSelected ? Constants.selectedBackgroundColor : Constants.normalBackgroundColor) :
        Constants.disabledBackgroundColor
        alpha = isHighlighted ? Constants.highlightAlpha : Constants.baseAlpha
    }
}
