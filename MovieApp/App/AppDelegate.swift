//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Nurşah Ari on 17.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // UINavigationController oluştur
         let navController = UINavigationController()

         // MainCoordinator'u başlat ve navigationController ayarla
         mainCoordinator = MainCoordinator()
         mainCoordinator?.navigationController = navController
         mainCoordinator?.start()

         // UIWindow'un rootViewController'ını navigationController olarak ayarla
         window?.rootViewController = navController
         window?.makeKeyAndVisible()
        return true
    }
}

