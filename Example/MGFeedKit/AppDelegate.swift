//
//  AppDelegate.swift
//  MGFeedKit
//
//  Created by AldoOS on 03/31/2019.
//  Copyright (c) 2019 AldoOS. All rights reserved.
//

import UIKit
import MGFeedKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        window = UIWindow(frame: UIScreen.main.bounds)
//        let data = MGFeedData(title: "The Next Web", urlString: "https://thenextweb.com/feed/")
//        let data = MGFeedData(title: "Tech Crunch", urlString: "https://techcrunch.com/feed/")
//        let data = MGFeedData(title: "The Verge", urlString: "https://www.theverge.com/rss/index.xml")
//        let data = MGFeedData(title: "Digital Trend", urlString: "https://www.digitaltrends.com/feed/")

        let controller = MGFeedController.instance
        controller.assets = FeedAsset(
            string: FeedString(
                title: "Titolo",
                navigationTitle: "Titolo",
                searchBarPlaceholder: "Cerca"),
            font: FeedFont(
                navigationTitle: nil,
                cellTitle: nil,
                cellDate: nil,
                cellDescription: nil),
            image: FeedImage(
                navigationItemMenu: UIImage(),
                navigationItemShare: #imageLiteral(resourceName: "menu")),
            color: FeedColor(
                navigationBar: .black,
                navigationBarTint: .white,
                toolBar: .black,
                toolBarTint: .white,
                backgroundView: .black,
                backgroundTableView: .black,
                tableViewSeparator: .black,
                refreshTint: .white,
                searchBarTint: .white,
                backgroundViewCell: .black,
                cellTint: .white),
            data: FeedData(
                url: "https://www.digitaltrends.com/feed/",
                items: [],
                enableAds: true,
                adsUnitId: "ca-app-pub-3940256099942544/2934735716", darkKeyboard: true))
        
        controller.delegate = self
        controller.dataSource = self
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate: MGFeedControllerDelegate, MGFeedControllerDataSource {
    
    func controller(_ controller: UIViewController, didTapBarButtonItem barButtonItem: UIBarButtonItem) {
        
    }
    
    func leftBarButtonItems(_ controller: UIViewController) -> [UIBarButtonItem] {
       
        let button1 = UIBarButtonItem()
        button1.image = #imageLiteral(resourceName: "menu")
        button1.style = .plain
        button1.accessibilityIdentifier = "First"
        
        let button2 = UIBarButtonItem()
        button2.image = #imageLiteral(resourceName: "menu")
        button2.style = .plain
        button2.accessibilityIdentifier = "Second"
        

        return [button1, button2]
    }
    
    func rightBarButtonItems(_ controller: UIViewController) -> [UIBarButtonItem] {
        
        let button2 = UIBarButtonItem()
        button2.image = #imageLiteral(resourceName: "menu")
        button2.style = .plain
        button2.accessibilityIdentifier = "Second"
        
        
        return [button2]
    }
    
}

struct FeedAsset: MGFeedAsset {
    var string: MGFeedString
    var font: MGFeedFont
    var image: MGFeedImage
    var color: MGFeedColor
    var data: MGFeedData
}

struct FeedString: MGFeedString {
    var title: String
    var navigationTitle: String
    var searchBarPlaceholder: String
}

struct FeedFont: MGFeedFont {
    var navigationTitle: UIFont?
    var cellTitle: UIFont?
    var cellDate: UIFont?
    var cellDescription: UIFont?
}

struct FeedImage: MGFeedImage {
    var navigationItemMenu: UIImage
    var navigationItemShare: UIImage
}

struct FeedColor: MGFeedColor {
    var navigationBar: UIColor
    var navigationBarTint: UIColor
    var toolBar: UIColor
    var toolBarTint: UIColor
    var backgroundView: UIColor
    var backgroundTableView: UIColor
    var tableViewSeparator: UIColor
    var refreshTint: UIColor
    var searchBarTint: UIColor
    var backgroundViewCell: UIColor
    var cellTint: UIColor
}

struct FeedData: MGFeedData {
    var url: String
    var items: [MGFeedItem]
    var enableAds: Bool
    var adsUnitId: String
    var darkKeyboard: Bool
}
