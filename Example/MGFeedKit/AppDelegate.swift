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
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bannerView: GADBannerView!

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
                title: "Title",
                navigationTitle: "Title",
                searchBarPlaceholder: "Search"),
            font: FeedFont(
                tableViewCellTitle: nil,
                tableViewCellSubtitle: nil,
                tableViewCellDescription: nil),
            image: FeedImage(),
            color: FeedColor(
                navigationBar: .black,
                navigationBarContent: .white,
                refreshControl: .white,
                searchBar: .black,
                searchBarContent: .white,
                toolBar: .black,
                toolBarContent: .white,
                view: .black,
                viewContent: .white,
                tableView: .black,
                tableViewContent: .white,
                tableViewSeparator: .white,
                tableViewCell: .black,
                tableViewCellContent: .white,
                collectionView: .black,
                collectionViewContent: .white,
                tableViewCellTitle: .white,
                tableViewCellSubtitle: .white,
                tableViewCellDescription: .white),
            data: FeedData(
                url: "https://thenextweb.com/feed/",
                enableAds: false,
                adsUnitId: "ca-app-pub-3940256099942544/2934735716",
                keyboardAppearance: .dark,
                activityIndicatorStyle: .white))
//        controller.assets = FeedAsset(
//            string: FeedString(
//                title: "Titolo",
//                navigationTitle: "Titolo",
//                searchBarPlaceholder: "Cerca"),
//            font: FeedFont(
//                navigationTitle: nil,
//                cellTitle: nil,
//                cellDate: nil,
//                cellDescription: nil),
//            image: FeedImage(
//                navigationItemMenu: UIImage(),
//                navigationItemShare: #imageLiteral(resourceName: "menu")),
//            color: FeedColor(
//                navigationBar: .black,
//                navigationBarTint: .white,
//                toolBar: .black,
//                toolBarTint: .white,
//                backgroundView: .black,
//                backgroundTableView: .black,
//                tableViewSeparator: .black,
//                refreshTint: .white,
//                searchBarTint: .white,
//                backgroundViewCell: .black,
//                cellTint: .white),
//            data: FeedData(
//                url: "https://www.digitaltrends.com/feed/",
//                enableAds: true,
//                adsUnitId: "ca-app-pub-3940256099942544/2934735716", darkKeyboard: true))
        
        controller.delegate = self
        controller.dataSource = self
        window?.rootViewController = UINavigationController(rootViewController: controller)
        
        
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        view.addSubview(bannerView)
//        if let assets = assets, assets.data.enableAds == true, assets.data.adsUnitId.count > 0 {
//            bannerView.snp.makeConstraints { make in
//                make.bottom.equalTo(self.view)
//                make.leading.equalTo(self.view)
//                make.trailing.equalTo(self.view)
//            }
//            bannerView.adUnitID = assets.data.adsUnitId
//            bannerView.rootViewController = self
//            bannerView.load(GADRequest())
//            bannerView.delegate = self
//        }

        
        window?.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate: MGFeedControllerDelegate, MGFeedControllerDataSource {
    
    func controller(_ controller: UIViewController, didTapBarButtonItem barButtonItem: UIBarButtonItem) {
        if let con = controller as? MGFeedDetailController {
            print("link: \(con.item.itemUrl)")
        }
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
    
    func toolBarButtonItems(_ controller: UIViewController) -> [UIBarButtonItem] {
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
    var tableViewCellTitle: UIFont?
    var tableViewCellSubtitle: UIFont?
    var tableViewCellDescription: UIFont?
}

struct FeedImage: MGFeedImage {

}

struct FeedColor: MGFeedColor {
    var navigationBar: UIColor
    
    var navigationBarContent: UIColor
    
    var refreshControl: UIColor
    
    var searchBar: UIColor
    
    var searchBarContent: UIColor
    
    var toolBar: UIColor
    
    var toolBarContent: UIColor
    
    var view: UIColor
    
    var viewContent: UIColor
    
    var tableView: UIColor
    
    var tableViewContent: UIColor
    
    var tableViewSeparator: UIColor
    
    var tableViewCell: UIColor
    
    var tableViewCellContent: UIColor
    
    var collectionView: UIColor
    
    var collectionViewContent: UIColor
    
    var tableViewCellTitle: UIColor
    
    var tableViewCellSubtitle: UIColor
    
    var tableViewCellDescription: UIColor
    
}

struct FeedData: MGFeedData {
    var url: String
    
    var enableAds: Bool
    
    var adsUnitId: String
    
    var keyboardAppearance: UIKeyboardAppearance
    
    var activityIndicatorStyle: UIActivityIndicatorView.Style
    

}
