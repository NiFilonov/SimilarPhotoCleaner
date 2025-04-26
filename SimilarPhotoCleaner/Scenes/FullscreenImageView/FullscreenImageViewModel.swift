//
//  FullscreenImageViewModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 22.04.2025.
//

import Foundation
import DifferenceKit
import Combine
import Photos

// MARK: - Protocol

protocol FullscreenImageViewModelable {
    var items: [AnyDifferentiable] { get }
    var selectedImagePublisher: AnyPublisher<PHAsset, Never> { get }
    func viewAppear()
    func selectImage(index: Int)
}

final class FullscreenImageViewModel: FullscreenImageViewModelable {
    
    // MARK: - Internal Properties
    
    private(set) var items = [AnyDifferentiable]()
    var selectedImagePublisher: AnyPublisher<PHAsset, Never> {
        $selectedImage
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    
    @Published private var model: PhotosModel
    @Published private var selectedImage: PHAsset!
    
    // MARK: - Initialization
    
    init(selectedImage: PHAsset, model: PhotosModel) {
        self.selectedImage = selectedImage
        self.model = model
    }
    
    // MARK: - Interface
    
    func viewAppear() {
        items = model.imagesModels.map { model in
            AnyDifferentiable(ImageCellViewModel(id: model.asset.localIdentifier,
                                                 model: model))
        }
    }
    
    func selectImage(index: Int) {
        selectedImage = model.imagesModels[index].asset
    }
}
