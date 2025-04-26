//
//  AppDelegate.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 05.04.2025.
//

import UIKit
import Dip

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    // MARK: - Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initDependencies()
        setupWindow()
        launchCoordinator()
        
        return true
    }
    
    // MARK: - Private Methods
    
    private func initDependencies() {
        DependencyContainer.uiContainers = [DIAssembly.container]
    }
    
    private func setupWindow() {
        window = UIWindow()
    }
    
    private func launchCoordinator() {
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
    }
}
