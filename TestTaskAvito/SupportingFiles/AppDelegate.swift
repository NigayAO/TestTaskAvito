//
//  AppDelegate.swift
//  TestTaskAvito
//
//  Created by Alik Nigay on 26.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
        } else {
            window = UIWindow(frame: .zero)
            
            let navigationVC = UINavigationController(rootViewController: MainViewController())
            window?.rootViewController = navigationVC
            
            window?.makeKeyAndVisible()
        }
        
//        NetworkMonitor.shared.startMonitoring()
        
        return true
    }
}

