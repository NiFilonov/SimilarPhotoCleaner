//
//  PhotosModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 19.04.2025.
//

import Foundation

final class PhotosModel {
    let id: AnyHashable
    let imagesModels: [ImageModel]
    
    init(id: AnyHashable, imagesModels: [ImageModel]) {
        self.id = id
        self.imagesModels = imagesModels
    }
    
    func copyWithUnselectedPhotos() -> PhotosModel {
        PhotosModel(id: id,
                    imagesModels: imagesModels.filter({ !$0.isSelected }))
    }
}

extension PhotosModel: Equatable {
    static func == (lhs: PhotosModel, rhs: PhotosModel) -> Bool {
        lhs.imagesModels == rhs.imagesModels
    }
}
