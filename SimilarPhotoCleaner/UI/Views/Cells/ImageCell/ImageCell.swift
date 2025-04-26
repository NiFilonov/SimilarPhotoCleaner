//
//  ImageCell.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import UIKit
import Combine

final class ImageCell: BaseCollectionViewCell<ImageCellViewModel> {
    
    // MARK: - Constants
    
    private enum Constants {
        static let checkboxTrailingOffset: CGFloat = -10
    }
    
    // MARK: - Subviews
    
    private let imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.layer.roundedCornersSmall()
        return $0
    }(UIImageView())
    
    lazy private var checkboxView: CheckboxView = {
        $0.delegate = self
        return $0
    }(CheckboxView())
    
    // MARK: - Private Propertiees
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(checkboxView)
    }
    
    override func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        checkboxView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(.offset)
            $0.trailing.equalToSuperview().offset(Constants.checkboxTrailingOffset)
        }
    }
    
    // MARK: - Internal Methods
    
    override func update(with viewModel: ImageCellViewModel) {
        imageView.load(asset: viewModel.model.asset, size: .thumbnail)
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        viewModel?.model.$isSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSelected in
                self?.updateCheckbox(isSelected: isSelected)
            }
            .store(in: &cancellables)
    }
    
    private func updateCheckbox(isSelected: Bool) {
        checkboxView.set(isSelected: isSelected)
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc
    private func handleTap() {
        viewModel?.onImageTapped()
    }
}

// MARK: - CheckboxViewDelegate

extension ImageCell: CheckboxViewDelegate {

    func checkboxViewToggle(_ checkbox: CheckboxView) {
        viewModel?.onToggleSelection()
    }
}
