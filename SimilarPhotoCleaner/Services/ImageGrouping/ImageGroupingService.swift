//
//  SimilarDetection.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 14.04.2025.
//

import Photos
import Vision
import UIKit
import Accelerate

// MARK: - Protocol

protocol ImageGroupingServiceProtocol {
    func groupSimilar(fetchedAsset: PHFetchResult<PHAsset>) async -> [PhotosModel]
}

final class ImageGroupingService: ImageGroupingServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let bitsPerComponent: Int = 8
        static let bytesPerPixel: Int = 1
    }
    
    // MARK: - Private Properties
    
    private let minSimilarity: Double
    
    // MARK: - Initialization
    
    init(config: ImageGroupingServiceConfig = AppConfig.grouping) {
        self.minSimilarity = config.minSimilarity
    }
    
    // MARK: - Interface
    
    func groupSimilar(fetchedAsset: PHFetchResult<PHAsset>) async -> [PhotosModel] {
        let images = await fetchImages(from: fetchedAsset) ?? []
        var usedIndexes = [Int]()
        var groupedImages = [[PHAsset]]()
        
        for i in 0..<images.count {
            var similarityIndexes = [Int]()
            var similarityImages = [fetchedAsset.object(at: i)]
            for j in 0..<images.count {
                guard i != j && !usedIndexes.contains(i) && !usedIndexes.contains(j) else { continue }
                if let similarity = compareImages(images[i], images[j]) {
                    if similarity > minSimilarity {
                        similarityIndexes.append(i)
                        similarityIndexes.append(j)
                        similarityImages.append(fetchedAsset.object(at: j))
                    }
                }
            }
            if similarityImages.count > 1 {
                usedIndexes.append(contentsOf: similarityIndexes)
                groupedImages.append(similarityImages)
            }
        }
        
        return groupedImages.map { array in
            let imagesModels = array.map {
                ImageModel(id: $0.localIdentifier,
                           isSelected: false,
                           asset: $0)
            }
            
            return PhotosModel(id: UUID().uuidString,
                               imagesModels: imagesModels)
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchImages(from assets: PHFetchResult<PHAsset>) async -> [UIImage]? {
        var images: [UIImage] = []
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat

        for index in 0..<assets.count {
            let asset = assets.object(at: index)
            await withCheckedContinuation { continuation in
                imageManager.requestImage(for: asset, targetSize: .thumbnail, contentMode: .aspectFit, options: options) { image, _ in
                    if let image {
                        images.append(image)
                    }
                    continuation.resume()
                }
            }
        }

        return images.isEmpty ? nil : images
    }

    private func compareImages(_ image1: UIImage, _ image2: UIImage) -> Double? {
        guard image1.size == image2.size else { return nil }
        
        guard let imageData1 = getGrayscaleData(from: image1),
              let imageData2 = getGrayscaleData(from: image2)
        else { return nil }

        let width = Int(image1.size.width)
        let height = Int(image1.size.height)
        
        var floatData1 = [Float](repeating: .zero, count: width * height)
        var floatData2 = [Float](repeating: .zero, count: width * height)
        var resultData = [Float](repeating: .zero, count: width * height)
        
        vDSP.convertElements(of: imageData1, to: &floatData1)
        vDSP.convertElements(of: imageData2, to: &floatData2)
        
        vDSP.subtract(floatData2, floatData1, result: &resultData)
        vDSP.absolute(resultData, result: &resultData)
        vDSP.clip(resultData, to: 0...1, result: &resultData)
        
        let sum: Float = vDSP.sum(resultData)
        let ratio = Double(sum) / Double(width * height)
        let similarity = 1 - ratio
        
        return similarity
    }
    
    private func getGrayscaleData(from image: UIImage) -> [UInt8]? {
        guard let cgImage = image.cgImage else { return nil }
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let bytesPerRow = width * Constants.bytesPerPixel
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo: UInt32 = CGImageAlphaInfo.none.rawValue
        
        var imageData = [UInt8](repeating: .zero, count: width * height)
        
        guard let context = CGContext(data: &imageData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: Constants.bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else { return nil }
        
        let rect = CGRect(x: .zero, y: .zero, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        return imageData
    }
}
