//
//  PhotosService.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import Photos

// MARK: - Protocol

protocol PhotosServiceProtocol: AnyObject {
    func fetchPhotos() -> PHFetchResult<PHAsset>?
    func deleteAssets(_ assets: [PHAsset]) async throws -> Bool
    func calculateTotalSizeOfAssets(_ assets: [PHAsset]) async -> Double
}

final class PhotosService: PhotosServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let sortDescriptor = "creationDate"
    }
    
    // MARK: - Dependencies
    
    private let photosPermissionProvider: PhotosPermissionProvider
    
    // MARK: - Initialization
    
    init(photosPermissionProvider: PhotosPermissionProvider) {
        self.photosPermissionProvider = photosPermissionProvider
    }
    
    // MARK: - Interface
    
    func fetchPhotos() -> PHFetchResult<PHAsset>? {
        guard photosPermissionProvider.hasPhotoAccess else {
            return nil
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: Constants.sortDescriptor, ascending: true)]
        
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    func deleteAssets(_ assets: [PHAsset]) async throws -> Bool {
        guard photosPermissionProvider.hasPhotoAccess else {
            throw PhotosError.permissionDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
            }) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }

    func calculateTotalSizeOfAssets(_ assets: [PHAsset]) async -> Double {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isNetworkAccessAllowed = true
        
        return await withTaskGroup(of: Int64.self) { group in
            for asset in assets {
                group.addTask {
                    await withCheckedContinuation { continuation in
                        imageManager.requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
                            continuation.resume(returning: Int64(data?.count ?? 0))
                        }
                    }
                }
            }
            
            var totalBytes: Int64 = 0
            for await bytes in group {
                totalBytes += bytes
            }
            
            return bytesToMb(totalBytes)
        }
    }
    
    // MARK: - Private Methods
    
    private func bytesToMb(_ value: Int64) -> Double {
        return Double(value) / (1024 * 1024)
    }
}
