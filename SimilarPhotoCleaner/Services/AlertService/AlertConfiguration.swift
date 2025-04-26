//
//  AlertConfiguration.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import UIKit

struct AlertConfiguration {
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    let actions: [AlertAction]
    let animated: Bool
    
    init(title: String? = nil,
         message: String? = nil,
         style: UIAlertController.Style = .alert,
         actions: [AlertAction] = [.ok()],
         animated: Bool = true) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
        self.animated = animated
    }
}
