//
//  AppDelegate.swift
//  ExpandableNavDemo
//
//  Created by Paige Sun on 2019-06-28.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        EPNavController.appearance.tintColor = #colorLiteral(red: 0.4520817399, green: 0.3181101084, blue: 0.8320295811, alpha: 1)
        EPNavController.appearance.navCornerRadius = 30
        EPNavController.appearance.topNavFromLayoutGuide = 60
        EPNavController.appearance.shadowColor = #colorLiteral(red: 0.3450980392, green: 0.3843137255, blue: 0.4431372549, alpha: 1)
        EPNavController.appearance.shadowOpacity = 0.4
        EPNavController.appearance.headlineFont = .systemFont(ofSize: 17, weight: .semibold)
        EPNavController.appearance.backButtonFont = .systemFont(ofSize: 17)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

