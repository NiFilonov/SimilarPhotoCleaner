//
//  UIApplication+Extension.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        guard let rootViewController = windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        
        return findTopViewController(from: rootViewController)
    }
    
    private func findTopViewController(from controller: UIViewController) -> UIViewController {
        if let navigation = controller as? UINavigationController {
            return navigation.visibleViewController ?? controller
        }
        
        return controller
    }
}
