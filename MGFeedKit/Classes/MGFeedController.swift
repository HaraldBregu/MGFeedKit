// 
//  MGFeedController.swift
//
//  Created by harald bregu on 28/02/2019.
//  Copyright © 2019 Dream Building Company. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import FeedKit
import SwiftSoup
import SDWebImage

public class MGFeedController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var searchController:UISearchController!
    var feedData: MGFeedData!
    var feedDataItems = [MGFeedDataItem]()
    var filterFeedDataItems = [MGFeedDataItem]()
    var didTapMenu:((MGFeedController) -> ()) = { _ in }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = feedData.title
        navigationItem.title = feedData.title
//        view.backgroundColor = UIColor("#15161D")
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = UIColor("#15161D")
//        navigationController?.navigationBar.tintColor = UIColor("#F3F7F8")
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true

//        let icon: IoniconsType = IoniconsType.naviconRound
//        let image = UIImage(icon: .ionicons(icon), size: CGSize(width: 34, height: 34), textColor: .white)
//        let menuBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(revealMenuViewcontroller))
//        navigationItem.leftBarButtonItem = menuBarButtonItem

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "mg.feedlist.nav.search.title".localized
//        searchController.searchBar.tintColor = UIColor("#F3F7F8")

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
//        tableView.backgroundColor = UIColor("#15161D")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 112 + 25, bottom: 0, right: 0)
//        tableView.separatorColor = UIColor("#F3F7F8")
        tableView.refreshControl = refreshControl

        activityIndicatorView.style = .white
        activityIndicatorView.center = tableView.center

//        refreshControl.tintColor = UIColor("#15161D")
//        refreshControl.addAction(for: .touchUpInside) { [unowned self] in
//            self.setFeed(self.feedData)
//        }
        self.setFeed(self.feedData)
    }
 
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.toolbar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = UIColor("#15161D")
//        navigationController?.navigationBar.tintColor = UIColor("#F3F7F8")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setFeed(_ feedData: MGFeedData) {
        
        startActivityIndicatorView()
        
        var feedURL = URL(string: feedData.urlString) ?? URL(string: "https://google.com/")!
        let parser = FeedParser(URL: feedURL)
        parser.parseAsync(queue: .global(qos: .userInitiated)) { [unowned self] (result) in
            switch result {
            case .atom(let atomFeed):
                var newFeedDataItems = [MGFeedDataItem]()
                atomFeed.entries?.forEach({ (atomFeedItem) in
                    if let html = atomFeedItem.content?.value {
                        do {
                            let doc: Document = try SwiftSoup.parse(html)
                            let link: Element = try doc.select("img").first()!
                            let linkHref: String = try link.attr("src")
                            newFeedDataItems.append(MGFeedDataItem(title: atomFeedItem.title ?? "", imageUrl: linkHref, itemUrl: atomFeedItem.id ?? "", author_pubDate: atomFeedItem.published ?? Date(), itemDescription: html))
                        } catch Exception.Error(let type, let message) {
                            print(type)
                            print(message)
                        } catch let error {
                            print(error)
                        }
                    }
                })
                self.feedDataItems = newFeedDataItems
                DispatchQueue.main.async {
                    self.stopActivityIndicatorView()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
                break
            case .rss(let rssFeed):
                var newFeedDataItems = [MGFeedDataItem]()
                rssFeed.items?.forEach({ (rssFeedItem) in
                    let description = rssFeedItem.description ?? ""
                    let contentEncoded = rssFeedItem.content?.contentEncoded ?? ""
                    
                    func imageUrlFrom(htmlString: String) -> String? {
                        var document:Document!
                        do {
                            document = try SwiftSoup.parse(htmlString)
                        } catch Exception.Error(let type, let message) {
                            print(type, message)
                        } catch let error {
                            print(error)
                        }
                        
                        var links:Elements!
                        do {
                            links = try document.select("img")
                        } catch Exception.Error(let type, let message) {
                            print(type, message)
                        } catch let error {
                            print(error)
                        }
                        
                        var imageLink:String? = nil
                        if let link = links.first() {
                            do {
                                imageLink = try link.attr("src")
                                return imageLink
                            } catch Exception.Error(let type, let message) {
                                print(type, message)
                            } catch let error {
                                print(error)
                            }
                        }
                        return imageLink
                    }
                    
                    var url:String = ""
                    if let imgUrl = imageUrlFrom(htmlString: description) {
                        url = imgUrl
                    } else if let imgUrl = imageUrlFrom(htmlString: contentEncoded) {
                        url = imgUrl
                    } else if let mediaThumbnailUrl = rssFeedItem.media?.mediaThumbnails?.first?.attributes?.url {
                        url = mediaThumbnailUrl
                    } else if let enclosureUrl = rssFeedItem.enclosure?.attributes?.url {
                        url = enclosureUrl
                    }
                    
                    newFeedDataItems.append(MGFeedDataItem(title: rssFeedItem.title ?? "", imageUrl: url, itemUrl: rssFeedItem.link ?? "", author_pubDate: rssFeedItem.pubDate ?? Date(), itemDescription: description))
                })
                self.feedDataItems = newFeedDataItems
                DispatchQueue.main.async {
                    self.stopActivityIndicatorView()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
                break
            case .json: break
            case .failure: break
            }
        }
    }
    
    @objc private func revealMenuViewcontroller() {
        didTapMenu(self)
    }
    
    private var refreshControl:UIRefreshControl {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }
    
    lazy var activityIndicatorView:UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = view.center
        return activityIndicatorView
    }()
    
    public func startActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    public func stopActivityIndicatorView() {
        activityIndicatorView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
}
