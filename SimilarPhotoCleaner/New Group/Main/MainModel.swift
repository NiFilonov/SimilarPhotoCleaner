//
//  MainModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 18.04.2025.
//

import Foundation
import DifferenceKit

final class MainModel {
    var imagesCount: Int
    @Published var photos: [PhotosModel]
    
    init(imagesCount: Int, photos: [PhotosModel]) {
        self.imagesCount = imagesCount
        self.photos = photos
    }
    
    func update(imagesCount: Int, photos: [PhotosModel]) {
        self.imagesCount = imagesCount
        if self.photos != photos {
            self.photos = photos
        }
    }
}
