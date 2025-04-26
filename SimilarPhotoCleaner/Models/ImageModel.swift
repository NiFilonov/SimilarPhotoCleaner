//
//  ImageModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 19.04.2025.
//

import Photos
import Combine

final class ImageModel {
    let id: AnyHashable
    @Published var isSelected: Bool = false
    var selectionPublisher: AnyPublisher<Bool, Never> {
        $isSelected.eraseToAnyPublisher()
    }
    let asset: PHAsset
    
    init(id: AnyHashable, isSelected: Bool, asset: PHAsset) {
        self.id = id
        self.isSelected = isSelected
        self.asset = asset
    }
}

extension ImageModel: Equatable {
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.isSelected == rhs.isSelected
        && lhs.asset == rhs.asset
    }
}
