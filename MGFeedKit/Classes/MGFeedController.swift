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
import SnapKit
import FirebaseCore
import GoogleMobileAds

public class MGFeedController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    public var delegate: MGFeedControllerDelegate?
    public var dataSource: MGFeedControllerDataSource?
    public var assets: MGFeedAsset!
    
    var items = [MGFeedItem]()
    var filteredItems = [MGFeedItem]()
   
    var activityIndicatorView: UIActivityIndicatorView!
    var searchController: UISearchController!
    var refreshControl: UIRefreshControl!
    var bannerView: GADBannerView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = assets.string.title
        navigationItem.title = assets.string.title
        
        view.backgroundColor = assets.color.view
        navigationController?.navigationBar.barTintColor = assets.color.navigationBar
        navigationController?.navigationBar.tintColor = assets.color.navigationBarContent
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = assets.string.searchBarPlaceholder
        searchController.searchBar.tintColor = assets.color.searchBarContent
        searchController.searchBar.keyboardAppearance = assets.data.keyboardAppearance

        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        if let items = dataSource?.leftBarButtonItems(self) {
            items.forEach({ $0.target = self })
            items.forEach({ $0.action = #selector(navigationItemAction(barButtonItem:)) })
            navigationItem.leftBarButtonItems = items
            navigationItem.leftItemsSupplementBackButton = true
        }
        
        if let items = dataSource?.rightBarButtonItems(self) {
            items.forEach({ $0.target = self })
            items.forEach({ $0.action = #selector(navigationItemAction(barButtonItem:)) })
            navigationItem.rightBarButtonItems = items
        }

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = assets.color.tableView
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 112 + 25, bottom: 0, right: 0)
        tableView.separatorColor = assets.color.tableViewSeparator
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = assets.color.refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData(button:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = assets.data.activityIndicatorStyle
        view.addSubview(activityIndicatorView)

        setFeed(assets.data)
        
        if let assets = assets, assets.data.enableAds == true, assets.data.adsUnitId.count > 0 {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            view.addSubview(bannerView)
            bannerView.snp.makeConstraints { make in
                make.bottom.equalTo(self.view)
                make.leading.equalTo(self.view)
                make.trailing.equalTo(self.view)
            }
            bannerView.adUnitID = assets.data.adsUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }

    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        activityIndicatorView.center = CGPoint(x: (UIScreen.main.bounds.width / 2.0), y: (UIScreen.main.bounds.height / 2.0))
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.center = CGPoint(x: (UIScreen.main.bounds.width / 2.0), y: (UIScreen.main.bounds.height / 2.0))
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let items = dataSource?.leftBarButtonItems(self) {
            items.forEach({ $0.target = self })
            items.forEach({ $0.action = #selector(navigationItemAction(barButtonItem:)) })
            navigationItem.leftBarButtonItems = items
            navigationItem.leftItemsSupplementBackButton = true
        }
        
        if let items = dataSource?.rightBarButtonItems(self) {
            items.forEach({ $0.target = self })
            items.forEach({ $0.action = #selector(navigationItemAction(barButtonItem:)) })
            navigationItem.rightBarButtonItems = items
        }
    }

    @objc private func navigationItemAction(barButtonItem: UIBarButtonItem) {
        self.delegate?.controller(self, didTapBarButtonItem: barButtonItem)
    }

    @objc private func reloadData(button:UIButton) {
        refreshControl.endRefreshing()
        setFeed(assets.data)
    }
    
    private func setFeed(_ data: MGFeedData) {
        guard let url = URL(string: data.url) else { return }
        activityIndicatorView.startAnimating()
        let parser = FeedParser(URL: url)
        parser.parseAsync(queue: .global(qos: .userInitiated)) { (result) in
            switch result {
            case .atom(let feed):
                self.atomFeed(feed)
                break
            case .rss(let feed):
                self.rssFeed(feed)
                break
            case .json:
                break
            case .failure:
                break
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
                    let link: Element? = try doc.select("img").first()
                    let linkHref: String = try link?.attr("src") ?? ""
                    newItems.append(MGFeedItem(
                        title: feedItem.title ?? "",
                        imageUrl: linkHref,
                        date: feedItem.published ?? Date(),
                        description: html.htmlToPlainText,
                        itemUrl: feedItem.id ?? ""))
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
            
            newItems.append(MGFeedItem(
                title: feedItem.title ?? "",
                imageUrl: url,
                date: feedItem.pubDate ?? Date(),
                description: description.htmlToPlainText,
                itemUrl: feedItem.link ?? ""))
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

        cell.backgroundColor = assets.color.tableViewCell
        cell.contentView.backgroundColor = assets.color.tableViewCell

        let item = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
        
        cell.headerImageView.sd_setShowActivityIndicatorView(true)
        cell.headerImageView.sd_setIndicatorStyle(assets.data.activityIndicatorStyle)
        cell.headerImageView.sd_setImage(with: URL(string: item.imageUrl))
        
        cell.titleLabel.text = item.title
        cell.titleLabel.textColor = assets.color.tableViewCellTitle
        if let font = assets.font.tableViewCellTitle {
            cell.titleLabel.font = font
        }
        
        cell.subtitleLabel.text = item.date?.string
        cell.subtitleLabel.textColor = assets.color.tableViewCellSubtitle
        if let font = assets.font.tableViewCellSubtitle {
            cell.subtitleLabel.font = font
        }

        cell.descriptionLabel.text = item.description
        cell.descriptionLabel.textColor = assets.color.tableViewCellDescription
        if let font = assets.font.tableViewCellDescription {
            cell.descriptionLabel.font = font
        }
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MGFeedDetailController") as? MGFeedDetailController {
            let item = isFiltering ? filteredItems[indexPath.row] : items[indexPath.row]
            controller.item = item
            controller.assets = assets
            controller.delegate = delegate
            controller.dataSource = dataSource
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension MGFeedController {
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var searchBarIsEmpty: Bool {
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

class MGFeedViewCell: UITableViewCell {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

fileprivate let storyboardName = "MGFeed"
fileprivate let controllerIdentifier = "MGFeedController"
fileprivate let resourceName = "MGFeedKit"
fileprivate let resourceExtension = "bundle"

public struct MGFeedItem {
    public let title: String
    public let imageUrl: String
    public let date: Date?
    public let description: String
    public let itemUrl: String
}

extension Date {

    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }

}

/// Quick-n-dirty translation of MWFeedParser's algorithm from Objective-C to Swift
/// seealso: https://github.com/mwaterfall/MWFeedParser/blob/master/Classes/NSString%2BHTML.m
extension NSString {
    var htmlToPlainText: String {
        let stopCharacters = CharacterSet(charactersIn: "< \t\n\r\(0x0085)\(0x000C)\(0x2028)\(0x2029)")
        let newLineAndWhitespaceCharacters = CharacterSet(charactersIn: " \t\n\r\(0x0085)\(0x000C)\(0x2028)\(0x2029)")
        let tagNameCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        let result = NSMutableString(capacity: length)
        let scanner = Scanner(string: self as String)
        scanner.charactersToBeSkipped = nil
        scanner.caseSensitive = true
        var str: NSString? = nil
        var tagName: NSString? = nil
        var dontReplaceTagWithSpace = false
        
        repeat {
            // Scan up to the start of a tag or whitespace
            if scanner.scanUpToCharacters(from: stopCharacters, into: &str), let s = str {
                result.append(s as String)
                str = nil
            }
            // Check if we've stopped at a tag/comment or whitespace
            if scanner.scanString("<", into: nil) {
                // Stopped at a comment, script tag, or other tag
                if scanner.scanString("!--", into: nil) {
                    // Comment
                    scanner.scanUpTo("-->", into: nil)
                    scanner.scanString("-->", into: nil)
                } else if scanner.scanString("script", into: nil) {
                    // Script tag where things don't need escaping!
                    scanner.scanUpTo("</script>", into: nil)
                    scanner.scanString("</script>", into: nil)
                } else {
                    // Tag - remove and replace with space unless it's
                    // a closing inline tag then dont replace with a space
                    if scanner.scanString("/", into: nil) {
                        // Closing tag - replace with space unless it's inline
                        tagName = nil
                        dontReplaceTagWithSpace = false
                        if scanner.scanCharacters(from: tagNameCharacters, into: &tagName), let t = tagName {
                            tagName = t.lowercased as NSString
                            dontReplaceTagWithSpace =
                                tagName == "a" ||
                                tagName == "b" ||
                                tagName == "i" ||
                                tagName == "q" ||
                                tagName == "span" ||
                                tagName == "em" ||
                                tagName == "strong" ||
                                tagName == "cite" ||
                                tagName == "abbr" ||
                                tagName == "acronym" ||
                                tagName == "label"
                        }
                        // Replace tag with string unless it was an inline
                        if !dontReplaceTagWithSpace && result.length > 0 && !scanner.isAtEnd {
                            result.append(" ")
                        }
                    }
                    // Scan past tag
                    scanner.scanUpTo(">", into: nil)
                    scanner.scanString(">", into: nil)
                }
            } else {
                // Stopped at whitespace - replace all whitespace and newlines with a space
                if scanner.scanCharacters(from: newLineAndWhitespaceCharacters, into: nil) {
                    if result.length > 0 && !scanner.isAtEnd {
                        result.append(" ") // Dont append space to beginning or end of result
                    }
                }
            }
        } while !scanner.isAtEnd
        
        // Cleanup
        
        // Decode HTML entities and return (this isn't included in this gist, but is often important)
        // let retString = (result as String).stringByDecodingHTMLEntities
        
        // Return
        return result as String // retString;
    }
    
}
