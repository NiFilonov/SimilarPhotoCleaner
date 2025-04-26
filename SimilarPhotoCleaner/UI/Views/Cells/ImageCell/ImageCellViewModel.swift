//
//  ImageCellViewModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import DifferenceKit
import UIKit
import Combine

// MARK: - Protocol

protocol ImageCellViewModelOutput: AnyObject {
    func imageCellViewModelImageTapped(_ imageCellViewModel: ImageCellViewModel)
}

struct ImageCellViewModel {
    
    // MARK: - Internal Protperties
    
    let id: AnyHashable
    let model: ImageModel
    weak var output: ImageCellViewModelOutput?
    
    // MARK: - Initialization
    
    init(id: AnyHashable, model: ImageModel) {
        self.id = id
        self.model = model
    }
    
    // MARK: - Internal Methods
    
    func onToggleSelection() {
        model.isSelected.toggle()
    }
    
    func onImageTapped() {
        output?.imageCellViewModelImageTapped(self)
    }
}

// MARK: - Differentiable

extension ImageCellViewModel: Differentiable {
    
    func isContentEqual(to source: ImageCellViewModel) -> Bool {
        return source.model == model
    }
    
    var differenceIdentifier: some Hashable {
        return id
    }
}
