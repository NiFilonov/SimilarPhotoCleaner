//
//  Coordinatable.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import UIKit

protocol Coordinatable : AnyObject {
    var childCoordinators: [Coordinatable] { get set }
    var navigationController: UINavigationController { get set }
    var coordinatorFinished: (() -> Void)? { get set }
    func start()
}

extension Coordinatable {
    func addDependency(_ coordinator: Coordinatable) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatable?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
