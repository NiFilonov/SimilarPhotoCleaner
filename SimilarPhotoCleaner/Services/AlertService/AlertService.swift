//
//  AlertService.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import UIKit

// MARK: - Protocol

protocol AlertServiceProtocol {
    func showAlert(config: AlertConfiguration)
}

final class AlertService: AlertServiceProtocol {
    
    // MARK: - Private Properties
    
    private var currentViewController: UIViewController? {
        UIApplication.shared.topViewController
    }
    
    // MARK: - Interface
    
    func showAlert(config: AlertConfiguration) {
        guard let vc = currentViewController else { return }
        
        let alert = makeAlertController(config: config)
        
        vc.present(alert, animated: config.animated)
    }
    
    // MARK: - Private Methods
    
    private func makeAlertController(config: AlertConfiguration) -> UIAlertController {
        let alert = UIAlertController(title: config.title,
                                      message: config.message,
                                      preferredStyle: config.style
        )
        
        config.actions.forEach { actionConfig in
            let action = UIAlertAction(title: actionConfig.title,
                                       style: actionConfig.style) { _ in
                actionConfig.handler?()
            }
            alert.addAction(action)
        }
        
        return alert
    }
}
