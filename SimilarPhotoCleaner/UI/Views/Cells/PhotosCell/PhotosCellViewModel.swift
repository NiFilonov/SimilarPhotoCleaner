//
//  PhotosCellViewModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import DifferenceKit
import UIKit

// MARK: - Protocol

protocol PhotosCellViewModelOutput: AnyObject {
    func photosCellViewModel(_ photosCellViewModel: PhotosCellViewModel, imageData: ImageData)
}

struct PhotosCellViewModel {
    
    // MARK: - Internal Properties
    
    let id: AnyHashable
    let model: PhotosModel
    var items: [AnyDifferentiable] {
        model.imagesModels.map { model in
            ImageCellViewModel(id: model.asset.localIdentifier,
                               model: model)
        }.map { AnyDifferentiable($0) }
    }
    var selectionButtonTitle: String {
        model.imagesModels.allSatisfy { $0.isSelected }
        ? Strings.Main.Cell.ActionTitle.deselectAll
        : Strings.Main.Cell.ActionTitle.selectAll
    }
    var title: String {
        Strings.Main.Cell.title(String(model.imagesModels.count))
    }
    weak var output: PhotosCellViewModelOutput?
    
    // MARK: - Initialization
    
    init(id: AnyHashable, title: String, model: PhotosModel) {
        self.id = id
        self.model = model
    }
    
    // MARK: - Internal Methods
    
    func onAllSelectionClicked() {
        let isSelected = !model.imagesModels.allSatisfy { $0.isSelected }
        model.imagesModels.forEach({ $0.isSelected = isSelected })
    }
    
    func didTappedOn(imageData: ImageData) {
        output?.photosCellViewModel(self, imageData: imageData)
    }
}

// MARK: - Differentiable

extension PhotosCellViewModel: Differentiable {
    
    func isContentEqual(to source: PhotosCellViewModel) -> Bool {
        return source.model.imagesModels.count == model.imagesModels.count
    }
    
    var differenceIdentifier: some Hashable {
        return id
    }
}
