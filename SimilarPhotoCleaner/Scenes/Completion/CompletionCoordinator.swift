//
//  CompletionCoordinator.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 25.04.2025.
//

import UIKit

final class CompletionCoordinator: Coordinatable {
    
    // MARK: - Internal Properties
    
    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController
    var coordinatorFinished: (() -> Void)?
    
    // MARK: - Private Properties
    
    private weak var parentCoordinator: Coordinatable?
    private let cleaningResult: CleaningResult
    
    // MARK: - Initialization
    
    init(cleaningResult: CleaningResult,
         navigationController: UINavigationController,
         parentCoordinator: Coordinatable) {
        self.cleaningResult = cleaningResult
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    // MARK: - Internal Methods
    
    func start() {
        let viewController = CompletionViewController(clearingResult: cleaningResult, coordinator: self)
        viewController.modalPresentationStyle = .overFullScreen
        
        navigationController.present(viewController, animated: true)
    }
    
    func finish() {
        coordinatorFinished?()
        parentCoordinator?.removeDependency(self)
    }
}
