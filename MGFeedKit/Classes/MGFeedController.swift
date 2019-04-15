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
    
    public var data:MGFeed!
    public var assets:MGAsset!
    
    var items = [MGFeedItem]()
    var filteredItems = [MGFeedItem]()
   
    var activityIndicatorView:UIActivityIndicatorView!
    var searchController:UISearchController!
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = assets.string.title
        navigationItem.title = assets.string.title
        
        view.backgroundColor = assets.color.backgroundView
        navigationController?.navigationBar.tintColor = assets.color.navigationBarTint
        navigationController?.navigationBar.barTintColor = assets.color.navigationBar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = assets.string.searchBarPlaceholder
        searchController.searchBar.tintColor = assets.color.searchBarTint

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: nil, action: nil)

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = assets.color.backgroundTableView
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 112 + 25, bottom: 0, right: 0)
        tableView.separatorColor = assets.color.tableViewSeparator
        refreshControl.tintColor = assets.color.refreshTint
        refreshControl.addTarget(self, action: #selector(reloadData(button:)), for: .valueChanged)
        tableView.refreshControl = refreshControl

        activityIndicatorView = UIActivityIndicatorView(style: .white)
        activityIndicatorView.center = tableView.center
        view.addSubview(activityIndicatorView)

        setFeed(data)
    }
 
    @objc private func reloadData(button:UIButton) {
        refreshControl.endRefreshing()
        setFeed(data)
    }
    
    private func setFeed(_ data: MGFeed) {
        guard let url = URL(string: data.url) else { return }
        activityIndicatorView.startAnimating()
        let parser = FeedParser(URL: url)
        parser.parseAsync(queue: .global(qos: .userInitiated)) { [unowned self] (result) in
            switch result {
            case .atom(let feed):
                self.atomFeed(feed)
                break
            case .rss(let feed):
                self.rssFeed(feed)
                break
            case .json: break
            case .failure: break
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    private func atomFeed(_ feed:AtomFeed) {
        var newItems = [MGFeedItem]()
        feed.entries?.forEach({ (feedItem) in
            if let html = feedItem.content?.value {
                do {
                    let doc: Document = try SwiftSoup.parse(html)
                    let link: Element = try doc.select("img").first()!
                    let linkHref: String = try link.attr("src")

                    let item = MGFeedItem()
                    item.title = feedItem.title ?? ""
                    item.imageUrl = linkHref
                    item.itemUrl = feedItem.id ?? ""
                    item.author_pubDate = feedItem.published ?? Date()
                    item.itemDescription = html
                    newItems.append(item)
                } catch Exception.Error( _, _) {
                    //print(type)
                    //print(message)
                } catch _ {
                    //print(error)
                }
            }
        })
        self.items = newItems
    }
    
    private func rssFeed(_ feed:RSSFeed) {
        var newItems = [MGFeedItem]()
        feed.items?.forEach({ (feedItem) in
            let description = feedItem.description ?? ""
            let contentEncoded = feedItem.content?.contentEncoded ?? ""
            
            func imageUrlFrom(htmlString: String) -> String? {
                var document:Document!
                do {
                    document = try SwiftSoup.parse(htmlString)
                } catch Exception.Error(_, _) {
                    //print(type, message)
                } catch _ {
                    //print(error)
                }
                
                var links:Elements!
                do {
                    links = try document.select("img")
                } catch Exception.Error(_, _) {
                    //print(type, message)
                } catch _ {
                    //print(error)
                }
                
                var imageLink:String? = nil
                if let link = links.first() {
                    do {
                        imageLink = try link.attr("src")
                        return imageLink
                    } catch Exception.Error(_, _) {
                        //print(type, message)
                    } catch _ {
                        //print(error)
                    }
                }
                return imageLink
            }
            
            var url:String = ""
            if let imgUrl = imageUrlFrom(htmlString: description) {
                url = imgUrl
            } else if let imgUrl = imageUrlFrom(htmlString: contentEncoded) {
                url = imgUrl
            } else if let mediaThumbnailUrl = feedItem.media?.mediaThumbnails?.first?.attributes?.url {
                url = mediaThumbnailUrl
            } else if let enclosureUrl = feedItem.enclosure?.attributes?.url {
                url = enclosureUrl
            }
            
            let item = MGFeedItem()
            item.title = feedItem.title ?? ""
            item.imageUrl = url
            item.itemUrl = feedItem.link ?? ""
            item.author_pubDate = feedItem.pubDate ?? Date()
            item.itemDescription = description
            newItems.append(item)
        })
        self.items = newItems
    }
}

extension MGFeedController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredItems.count : items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MGFeedViewCell") as? MGFeedViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let item = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
        
        cell.itemImageView.sd_setShowActivityIndicatorView(true)
        cell.itemImageView.sd_setIndicatorStyle(.white)
        cell.itemImageView.sd_setImage(with: URL(string: item.imageUrl))
        
        cell.itemTitleLabel.text = item.title
        //cell.itemDescriptionContentLabel.text = feedItem.itemDescription.byConvertingHTMLToPlainText()
        
        cell.backgroundColor = assets.color.backgroundViewCell
        cell.contentView.backgroundColor = assets.color.backgroundViewCell
        cell.itemTitleLabel.textColor = assets.color.cellTint
        cell.itemDescriptionContentLabel.textColor = assets.color.cellTint
        
        cell.layoutIfNeeded()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MGFeedDetailController") as? MGFeedDetailController {
            let item = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
            controller.item = item
            controller.assets = assets
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension MGFeedController {
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var searchBarIsEmpty:Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter({( item : MGFeedItem) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}

extension MGFeedController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension MGFeedController {
    
    public static var instance: MGFeedController {
        let podBundle = Bundle(for: MGFeedController.self)
        let bundleURL = podBundle.url(forResource: resourceName, withExtension: resourceExtension)
        let bundle = Bundle(url: bundleURL!) ?? Bundle()
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let controller = storyboard.instantiateViewController(withIdentifier: controllerIdentifier) as? MGFeedController else {
            return MGFeedController()
        }
        return controller
    }
    
}

fileprivate let storyboardName = "MGFeed"
fileprivate let controllerIdentifier = "MGFeedController"
fileprivate let resourceName = "MGFeedKit"
fileprivate let resourceExtension = "bundle"
