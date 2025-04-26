//
//  PhotosHeaderView.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import UIKit

// MARK: - Protocol

protocol PhotosHeaderViewDelegate: AnyObject {
    func selectionChanged(_ photosHeaderView: PhotosHeaderView)
}

final class PhotosHeaderView: CustomView {
    
    // MARK: - Internal Properties
    
    weak var delegate: PhotosHeaderViewDelegate?
    
    // MARK: - Subviews
    
    private let stackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private let titleLabel: UILabel = {
        $0.textColor = .primaryTextColor
        $0.font = .header2
        return $0
    }(UILabel())
    
    lazy private var selectionButton: UIButton = {
        $0.setTitleColor(.textButtonColor, for: .normal)
        $0.titleLabel?.font = .textInlineButton
        $0.addTarget(self, action: #selector(onSelectionClicked), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Lifecycle
    
    override func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(selectionButton)
    }
    
    override func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Internal Methods
    
    func update(title: String? = nil, actionTitle: String) {
        if let title {
            titleLabel.text = title
        }
        selectionButton.setTitle(actionTitle, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc
    private func onSelectionClicked() {
        delegate?.selectionChanged(self)
    }
}
