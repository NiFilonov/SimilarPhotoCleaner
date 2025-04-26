//
//  PhotosManager.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import Photos

// MARK: - Protocol

protocol PhotoManagerProtocol {
    func getPhotos() async throws -> PHFetchResult<PHAsset>?
    func deleteAssets(_ assets: [PHAsset]) async throws -> Bool
    func calculateTotalSizeOfAssets(_ assets: [PHAsset]) async throws -> Double
}

final class PhotoManager: PhotoManagerProtocol {
    
    // MARK: - Dependencies
    
    private let photosPermissionProvider: PhotosPermissionProvider
    private let photosService: PhotosServiceProtocol
    
    // MARK: - Initialization
    
    init(photosPermissionProvider: PhotosPermissionProvider,
         photosService: PhotosServiceProtocol,
         appLifecycleService: AppLifecycleServiceProtocol) {
        self.photosPermissionProvider = photosPermissionProvider
        self.photosService = photosService
    }
    
    // MARK: - Interface
    
    func getPhotos() async throws -> PHFetchResult<PHAsset>? {
        try await checkPhotoAccess {
            photosService.fetchPhotos()
        }
    }
    
    func deleteAssets(_ assets: [PHAsset]) async throws -> Bool {
        try await checkPhotoAccess {
            try await photosService.deleteAssets(assets)
        }
    }
    
    func calculateTotalSizeOfAssets(_ assets: [PHAsset]) async throws -> Double {
        try await checkPhotoAccess {
            await photosService.calculateTotalSizeOfAssets(assets)
        }
    }
    
    // MARK: - Private Methods
    
    private func checkPhotoAccess<T>(_ operation: () async throws -> T) async throws -> T {
        if photosPermissionProvider.hasPhotoAccess {
            return try await operation()
        } else {
            let granted = await photosPermissionProvider.requestPhotoAccess()
            guard granted else { throw PhotosError.permissionDenied }
            return try await operation()
        }
    }
}
