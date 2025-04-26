//
//  DIAssembly.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Dip

enum DIAssembly {
    
    @MainActor
    static let container: DependencyContainer = {
        let container = DependencyContainer()
        
        container.register(.singleton) {
            AppLifecycleService() as AppLifecycleServiceProtocol
        }
        
        container.register(.singleton) {
            AlertService() as AlertServiceProtocol
        }
        
        container.register {
            PhotosPermissionProviderService(alertService: $0) as PhotosPermissionProvider
        }
        
        container.register {
            PhotosService(photosPermissionProvider: $0) as PhotosServiceProtocol
        }

        container.register {
            PhotoManager(photosPermissionProvider: $0, photosService: $1, appLifecycleService: $2) as PhotoManagerProtocol
        }
        
        container.register {
            ImageGroupingService() as ImageGroupingServiceProtocol
        }
        
        return container
    }()
}
