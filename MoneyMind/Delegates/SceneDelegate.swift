//
//  SceneDelegate.swift
//  MoneyMind
//
//  Created by Павел on 12.04.2025.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = UserManager.shared.theme.getUserInterfaceStyle()
        self.window = window
        
        let diContainer = registerAppDIContainer()
        let appCoordinator = AppCoordinator(window: window, diContainer: diContainer)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }
    
    func registerAppDIContainer() -> AppDIContainer {
        let assemblies: [Assembly] = [
            ServicesAssembly()
        ]
        let diContainer = AppDIContainer(assemblies: assemblies)
        return diContainer
    }
}
