//
//  AppDelegate.swift
//  MGFeedKit
//
//  Created by AldoOS on 03/31/2019.
//  Copyright (c) 2019 AldoOS. All rights reserved.
//

import UIKit
import MGFeedKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var feed:MGFeed!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let data = MGFeedData(title: "The Next Web", urlString: "https://thenextweb.com/feed/")
//        let data = MGFeedData(title: "Tech Crunch", urlString: "https://techcrunch.com/feed/")
//        let data = MGFeedData(title: "The Verge", urlString: "https://www.theverge.com/rss/index.xml")
//        let data = MGFeedData(title: "Digital Trend", urlString: "https://www.digitaltrends.com/feed/")

        feed = MGFeed(data: data)
        window?.rootViewController = UINavigationController(rootViewController: feed.controller)
        window?.makeKeyAndVisible()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

