//
//  AlertConfig+PermissionProvider.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import UIKit

extension AlertConfiguration {
    
    static let permissionRequest = AlertConfiguration(title: Strings.PermissionProvider.Alert.title,
                                                      message: Strings.PermissionProvider.Alert.message,
                                                      style: .alert,
                                                      actions: [AlertAction(title: Strings.PermissionProvider.Alert.action,
                                                                            style: .default,
                                                                            handler: {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    })],
                                                      animated: true
    )
    
}
