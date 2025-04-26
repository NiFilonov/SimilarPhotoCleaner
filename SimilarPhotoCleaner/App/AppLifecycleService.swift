//
//  AppLifecycleService.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 15.04.2025.
//

import UIKit

protocol AppLifecycleServiceProtocol {
    @MainActor
    func observeForeground() -> AsyncStream<Void>
}

@MainActor
final class AppLifecycleService: AppLifecycleServiceProtocol {
    func observeForeground() -> AsyncStream<Void> {
        AsyncStream { continuation in
            let observer = NotificationCenter.default.addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: .main
            ) { _ in
                continuation.yield()
            }
            
            continuation.onTermination = { _ in
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
}
