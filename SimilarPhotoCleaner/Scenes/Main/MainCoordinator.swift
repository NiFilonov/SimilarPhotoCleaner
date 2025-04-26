//
//  MainCoordinator.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 20.04.2025.
//

import UIKit
import Photos

final class MainCoordinator: Coordinatable {
    
    // MARK: - Internal Properties
    
    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    var coordinatorFinished: (() -> Void)?
    
    // MARK: - Private Properties
    
    private let photoManager: PhotoManagerProtocol
    private let imageGroupingService: ImageGroupingServiceProtocol
    private let appLifecycleService: AppLifecycleServiceProtocol
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController,
         photoManager: PhotoManagerProtocol,
         imageGroupingService: ImageGroupingServiceProtocol,
         appLifecycleService: AppLifecycleServiceProtocol) {
        self.navigationController = navigationController
        self.photoManager = photoManager
        self.imageGroupingService = imageGroupingService
        self.appLifecycleService = appLifecycleService
    }
    
    // MARK: - Internal Methods
    
    func start() {
        let viewModel = MainViewModel(
            photoManager: photoManager,
            imageGroupingService: imageGroupingService,
            appLifecycleService: appLifecycleService
        )
        
        let viewController = MainViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showFullscreenImage(model: PhotosModel,asset: PHAsset, sourceFrame: CGRect) {
        let fullscreenCoordinator = FullscreenImageCoordinator(navigationController: navigationController,
                                                               model: model,
                                                               asset: asset,
                                                               sourceFrame: sourceFrame,
                                                               parentCoordinator: self
        )
        addDependency(fullscreenCoordinator)
        fullscreenCoordinator.start()
    }
    
    func showCompletion(cleaningResult: CleaningResult) {
        let completionCoordinator = CompletionCoordinator(cleaningResult: cleaningResult,
                                                          navigationController: navigationController,
                                                          parentCoordinator: self)
        addDependency(completionCoordinator)
        completionCoordinator.start()
    }
}
