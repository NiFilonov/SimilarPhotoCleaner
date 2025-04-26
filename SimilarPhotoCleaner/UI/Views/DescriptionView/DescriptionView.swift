//
//  DescriptionView.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 25.04.2025.
//

import UIKit

final class DescriptionView: CustomView {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageSide: CGFloat = 40
    }
    
    // MARK: - Subviews
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.font = .text
        $0.numberOfLines = .zero
        return $0
    }(UILabel())
    
    // MARK: - Internal Methods
    
    func set(image: UIImage, title: String, selectedText: String) {
        imageView.image = image
        titleLabel.attributedText = highlightText(in: title, selectedText: selectedText)
    }
    
    // MARK: - Lifecycle
    
    override func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    override func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(Constants.imageSide)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(.doubleOffset)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func highlightText(in text: String, selectedText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: selectedText)
        
        if range.location != NSNotFound {
            attributedString.addAttributes([
                .foregroundColor: UIColor.selectedTextColor,
                .font: UIFont.textSelection
            ], range: range)
        }
        
        return attributedString
    }
}
