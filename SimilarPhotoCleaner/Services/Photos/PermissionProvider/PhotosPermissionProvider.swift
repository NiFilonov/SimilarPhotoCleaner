//
//  PhotosPermissionProvider.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import Photos

typealias PhotoAccessHandler = ((Bool) -> ())

// MARK: - Protocol

protocol PhotosPermissionProvider {
    var hasPhotoAccess: Bool { get }
    func requestPhotoAccess() async -> Bool
}

final class PhotosPermissionProviderService: PhotosPermissionProvider {
    
    // MARK: - Constants
    
    private enum Constants {
        static let waitingTime: UInt64 = 1_000_000_000
    }
    
    // MARK: - Dependencies
    
    private let alertService: AlertServiceProtocol
    
    // MARK: - Initialization
    
    init(alertService: AlertServiceProtocol) {
        self.alertService = alertService
    }
    
    // MARK: - Interface
    
    var hasPhotoAccess: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    func requestPhotoAccess() async -> Bool {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            let accessGranted = await requestSystemPhotoAccess()
            if accessGranted { return true }
        } else if PHPhotoLibrary.authorizationStatus() == .limited {
            return await requestFullPhotoAccessWithRetry()
        } else {
            await MainActor.run {
                alertService.showAlert(config: .permissionRequest)
            }
        }
        return false
    }
    
    // MARK: - Private Methods
    
    private func requestSystemPhotoAccess() async -> Bool {
        let status = await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        return status == .authorized
    }
    
    private func requestFullPhotoAccessWithRetry() async -> Bool {
        while true {
            let status = await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization { status in
                    continuation.resume(returning: status)
                }
            }
            if status == .authorized {
                return true
            }
            
            try? await Task.sleep(nanoseconds: Constants.waitingTime)
        }
    }
}
