//
//  ImageLoader.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 23.04.2025.
//

import Foundation
import Photos
import UIKit

// MARK: - Protocol

protocol ImageLoaderProtocol {
    func loadThumbnail(for asset: PHAsset, targetSize: CGSize, _ completion: @escaping (UIImage?) -> Void)
    func loadFullImage(for asset: PHAsset, _ completion: @escaping (UIImage?) -> Void)
    func clearCache()
}

final class ImageLoader: ImageLoaderProtocol {
    
    static let `default`: ImageLoaderProtocol = ImageLoader()
    
    // MARK: - Private Properties
    
    private let imageManager = PHImageManager.default()
    private let fullCache = ImageCache(config: AppConfig.cache)
    private var thumbnailCache = [String: ImageCache]()
    
    // MARK: - Interface
    
    func loadThumbnail(for asset: PHAsset, targetSize: CGSize, _ completion: @escaping (UIImage?) -> Void) {
        if let cache = thumbnailCache[targetSize.debugDescription] {
            if let cachedImage = cache.cachedImage(for: asset.localIdentifier) {
                completion(cachedImage)
                return
            }
        } else {
            thumbnailCache[targetSize.debugDescription] = ImageCache(config: AppConfig.cache)
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset,
                                  targetSize: targetSize,
                                  contentMode: .aspectFill,
                                  options: options,
                                  resultHandler: { [weak self] image, _ in
            if let image {
                self?.thumbnailCache[targetSize.debugDescription]?.cacheImage(image, for: asset.localIdentifier)
            }
            completion(image)
        })
    }
    
    func loadFullImage(for asset: PHAsset, _ completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = fullCache.cachedImage(for: asset.localIdentifier) {
            completion(cachedImage)
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset,
                                  targetSize: PHImageManagerMaximumSize,
                                  contentMode: .default,
                                  options: options,
                                  resultHandler: { [weak self] image, _ in
            if let image {
                self?.fullCache.cacheImage(image, for: asset.localIdentifier)
            }
            completion(image)
        })
    }
    
    func clearCache() {
        thumbnailCache.removeAll()
        fullCache.clearCache()
    }
}
