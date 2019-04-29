// 
//  MGFeedDetailController.swift
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
import SDWebImage
import GSImageViewerController
import SnapKit
import FirebaseCore
import GoogleMobileAds


public class MGFeedDetailController: UIViewController {
    @IBOutlet var tableView: UITableView!
   
    public var delegate: MGFeedControllerDelegate?
    public var dataSource: MGFeedControllerDataSource?
    public var assets: MGFeedAsset!
    public var item: MGFeedItem!

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
        navigationItem.largeTitleDisplayMode = .never

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

        if let items = dataSource?.toolBarButtonItems(self) {
            items.forEach({ $0.target = self })
            items.forEach({ $0.action = #selector(navigationItemAction(barButtonItem:)) })
            toolbarItems = items
            navigationController?.setToolbarHidden(false, animated: true)
            navigationController?.toolbar.barTintColor = assets.color.toolBar
            navigationController?.toolbar.tintColor = assets.color.toolBarContent
            navigationController?.toolbar.isTranslucent = false
        }
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.backgroundColor = assets.color.tableView
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 112 + 25, bottom: 0, right: 0)
        tableView.separatorColor = assets.color.tableViewSeparator
        
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    @objc private func navigationItemAction(barButtonItem: UIBarButtonItem) {
        self.delegate?.controller(self, didTapBarButtonItem: barButtonItem)
    }
    
}

extension MGFeedDetailController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MGFeedDetailViewCell") as? MGFeedDetailViewCell else {
            return UITableViewCell(frame: .zero)
        }

        cell.backgroundColor = assets.color.tableViewCell
        cell.contentView.backgroundColor = assets.color.tableViewCell

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
        if let font = assets.font.tableViewCellTitle {
            cell.subtitleLabel.font = font
        }
        
        cell.descriptionLabel.text = item.description
        cell.descriptionLabel.textColor = assets.color.tableViewCellDescription
        if let font = assets.font.tableViewCellDescription {
            cell.descriptionLabel.font = font
        }

        UITapGestureRecognizer(addToView: cell.headerImageView) { [unowned self] gesture in
            let imageInfo = GSImageInfo(image: cell.headerImageView.image ?? UIImage(), imageMode: .aspectFit, imageHD: nil)
            let transitionInfo = GSTransitionInfo(fromView: cell.headerImageView)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            self.present(imageViewer, animated: true, completion: nil)
        }

        return cell
    }
    
}

class MGFeedDetailViewCell: UITableViewCell {
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

extension DateFormatter {
    
    @discardableResult
    static func formatedDate(dateString:String, fromFormat:String, toFormat:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = toFormat
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        return dateFormatterPrint.string(from: date)
    }
    
}

extension UIGestureRecognizer {
    
    @discardableResult
    convenience init(addToView targetView: UIView, closure: @escaping (_ gesture: UIGestureRecognizer) -> Void) {
        self.init()
        GestureTarget.add(gesture: self, closure: closure, toView: targetView)
    }
    
}

fileprivate class GestureTarget: UIView {
    
    class ClosureContainer {
        weak var gesture: UIGestureRecognizer?
        let closure: ((_ gesture: UIGestureRecognizer) -> Void)
        init(closure: @escaping (_ gesture: UIGestureRecognizer) -> Void) {
            self.closure = closure
        }
    }
    
    var containers = [ClosureContainer]()
    
    convenience init() {
        self.init(frame: .zero)
        isHidden = true
    }
    
    class func add(gesture: UIGestureRecognizer, closure: @escaping (_ gesture: UIGestureRecognizer) -> Void, toView targetView: UIView) {
        let target: GestureTarget
        if let existingTarget = existingTarget(inTargetView: targetView) {
            target = existingTarget
        } else {
            target = GestureTarget()
            targetView.addSubview(target)
        }
        let container = ClosureContainer(closure: closure)
        container.gesture = gesture
        target.containers.append(container)
        
        gesture.addTarget(target, action: #selector(GestureTarget.target(gesture:)))
        targetView.addGestureRecognizer(gesture)
    }
    
    class func existingTarget(inTargetView targetView: UIView) -> GestureTarget? {
        for subview in targetView.subviews {
            if let target = subview as? GestureTarget {
                return target
            }
        }
        return nil
    }
    
    func cleanUpContainers() {
        containers = containers.filter({ $0.gesture != nil })
    }
    
    @objc func target(gesture: UIGestureRecognizer) {
        cleanUpContainers()
        for container in containers {
            guard let containerGesture = container.gesture else {
                continue
            }
            if gesture === containerGesture {
                container.closure(gesture)
            }
        }
    }
    
}
