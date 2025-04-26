//
//  CheckboxView.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import UIKit

// MARK: - Delegate

protocol CheckboxViewDelegate: AnyObject {
    func checkboxViewToggle(_ checkbox: CheckboxView)
}

final class CheckboxView: CustomView {
    
    // MARK: - Internal Properties
    
    weak var delegate: CheckboxViewDelegate?
    
    private(set) var isSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    // MARK: - Subviews
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    // MARK: - Lifecycle
    
    override func commonInit() {
        super.commonInit()
        setupGesture()
        updateAppearance()
    }
    
    override func addSubviews() {
        addSubview(imageView)
    }
    
    override func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Internal Methods
    
    func set(isSelected: Bool) {
        guard self.isSelected != isSelected else { return }
        self.isSelected = isSelected
    }
    
    // MARK: - Private Methods
    
    private func setupGesture() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    private func updateAppearance() {
        imageView.image = isSelected
        ? Assets.Icons.checkboxChecked.image
        : Assets.Icons.checkboxUnchecked.image
    }
    
    //  MARK: - Actions
    
    @objc private func handleTap() {
        isSelected.toggle()
        delegate?.checkboxViewToggle(self)
    }
}
