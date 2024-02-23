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
        window = UIWindow(frame: UIScreen.main.bounds)
        
         let navController = UINavigationController()

         mainCoordinator = MainCoordinator()
         mainCoordinator?.navigationController = navController
         mainCoordinator?.start()

         window?.rootViewController = navController
         window?.makeKeyAndVisible()
        return true
    }
}

