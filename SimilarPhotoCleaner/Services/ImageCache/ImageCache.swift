//
//  ImageCache.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 21.04.2025.
//

import UIKit

final class ImageCache {
    
    // MARK: - Constants
    
    private enum Constants {
        static let queueName = "com.similarphotocleaner.imagecache."
    }
    
    // MARK: - Private Properties
    
    private let cache = NSCache<NSString, UIImage>()
    private var accessHistory = [String: Date]()
    private let maxCacheItemsLimit: Int
    private let accessQueue = DispatchQueue(label: Constants.queueName+UUID().uuidString, attributes: .concurrent)
    
    // MARK: - Initialization
    
    init(config: ImageCacheConfig) {
        maxCacheItemsLimit = config.maxCacheItemsLimit
        cache.totalCostLimit = config.maxCacheSize
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearCache),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Internal Methods
    
    func cachedImage(for key: String) -> UIImage? {
        accessQueue.sync(flags: .barrier) {
            accessHistory[key] = Date()
        }
        return cache.object(forKey: key as NSString)
    }
    
    func cacheImage(_ image: UIImage, for key: String) {
        let cost = calculateCost(for: image)
        
        accessQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            
            while self.currentCacheSize() >= self.maxCacheItemsLimit {
                self.removeOldestImage()
            }
            
            self.cache.setObject(image, forKey: key as NSString, cost: cost)
            self.accessHistory[key] = Date()
        }
    }
    
    @objc func clearCache() {
        cache.removeAllObjects()
        accessQueue.async(flags: .barrier) {
            self.accessHistory.removeAll()
        }
    }
    
    // MARK: - Private Methods
    
    private func currentCacheSize() -> Int {
        return accessHistory.count
    }
    
    private func removeOldestImage() {
        guard let oldest = accessHistory.min(by: { $0.value < $1.value }) else { return }
        
        cache.removeObject(forKey: oldest.key as NSString)
        accessHistory.removeValue(forKey: oldest.key)
    }
    
    private func calculateCost(for image: UIImage) -> Int {
        guard let cgImage = image.cgImage else { return .zero }
        return cgImage.bytesPerRow * cgImage.height
    }
}
