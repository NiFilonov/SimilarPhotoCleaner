//
//  AlertHandler.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 26.04.2025.
//

import UIKit

typealias AlertHandler = (() -> Void)

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
    
    static func ok(handler: AlertHandler? = nil) -> Self {
        AlertAction(title: Strings.Alert.ok, style: .default, handler: handler)
    }
    
    static func cancel(handler: AlertHandler? = nil) -> Self {
        AlertAction(title: Strings.Alert.cancel, style: .cancel, handler: handler)
    }
    
    static func destructive(title: String, handler: AlertHandler? = nil) -> Self {
        AlertAction(title: title, style: .destructive, handler: handler)
    }
}
