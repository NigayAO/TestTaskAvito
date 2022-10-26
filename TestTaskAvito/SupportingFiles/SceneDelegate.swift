//
//  SceneDelegate.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationVC = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationVC
        
        window?.makeKeyAndVisible()
    }
}

