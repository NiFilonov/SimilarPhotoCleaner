//
//  AppConfig.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 26.04.2025.
//

import Foundation

enum AppConfig {
    
    // MARK: - ImageCacheConfig
    
    static let cache = ImageCacheConfig(maxCacheItemsLimit: 100,
                                        maxCacheSize: 100 * 10_000_000)
    
    // MARK: - ImageGroupingServiceConfig
    
    static let grouping = ImageGroupingServiceConfig(minSimilarity: 0.01)
    
}
