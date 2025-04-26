//
//  FullscreenImageCoordinator.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 20.04.2025.
//

import UIKit
import Photos

final class FullscreenImageCoordinator: Coordinatable {
    
    // MARK: - Internal Properties
    
    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    var coordinatorFinished: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let asset: PHAsset
    private let sourceFrame: CGRect
    private let model: PhotosModel
    private weak var parentCoordinator: Coordinatable?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         model: PhotosModel,
         asset: PHAsset,
         sourceFrame: CGRect,
         parentCoordinator: Coordinatable) {
        self.navigationController = navigationController
        self.asset = asset
        self.sourceFrame = sourceFrame
        self.model = model
        self.parentCoordinator = parentCoordinator
    }
    
    // MARK: - Internal Methods
    
    func start() {
        let viewModel = FullscreenImageViewModel(selectedImage: asset, model: model)
        let viewController = FullscreenImageViewController(viewModel: viewModel, sourceFrame: sourceFrame, coordinator: self)
        viewController.modalPresentationStyle = .overFullScreen
        
        navigationController.present(viewController, animated: true)
    }
    
    func finish() {
        coordinatorFinished?()
        parentCoordinator?.removeDependency(self)
    }
}
