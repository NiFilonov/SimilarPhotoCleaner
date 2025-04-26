//
//  AppCoordinator.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import Foundation
import UIKit
import Dip

final class AppCoordinator: @preconcurrency Coordinatable {
    private let window: UIWindow
    
    var childCoordinators: [Coordinatable] = []
    
    var coordinatorFinished: (() -> Void)?
    
    var navigationController: UINavigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
        setupWindow()
    }

    @MainActor func start() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            photoManager: try! DIAssembly.container.resolve(),
            imageGroupingService: try! DIAssembly.container.resolve(),
            appLifecycleService: try! DIAssembly.container.resolve()
        )
        
        addDependency(mainCoordinator)
        mainCoordinator.start()
    }
    
    private func setupWindow() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
